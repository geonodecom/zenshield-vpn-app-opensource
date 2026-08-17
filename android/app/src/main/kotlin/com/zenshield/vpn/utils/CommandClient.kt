package com.zenshield.vpn.utils

import com.vpnapp.zenshield.libbox.CommandClient
import com.vpnapp.zenshield.libbox.CommandClientHandler
import com.vpnapp.zenshield.libbox.CommandClientOptions
import com.vpnapp.zenshield.libbox.Libbox
import go.Seq
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch

open class CommandClient(
        private val scope: CoroutineScope,
        private val connectionType: ConnectionType,
        private val handler: Handler,
) {

    enum class ConnectionType {
        Status
    }

    interface Handler {
        fun updateStatus(status: String) {}
    }

    private var commandClient: CommandClient? = null
    private val clientHandler = ClientHandler()
    fun connect() {
        disconnect()
        val options = CommandClientOptions()
        options.command =
                when (connectionType) {
                    ConnectionType.Status -> Libbox.CommandStatus
                }
        options.statusInterval = 1 * 1000 * 1000 * 1000
        val commandClient = CommandClient(clientHandler, options)
        scope.launch(Dispatchers.IO) {
            for (i in 1..10) {
                delay(100 + i.toLong() * 50)
                try {
                    commandClient.connect()
                } catch (_: Exception) {
                    continue
                }
                if (!isActive) {
                    runCatching { commandClient.disconnect() }
                    return@launch
                }
                this@CommandClient.commandClient = commandClient
                return@launch
            }
            runCatching { commandClient.disconnect() }
        }
    }

    fun disconnect() {
        commandClient?.apply {
            runCatching { disconnect() }
            Seq.destroyRef(refnum)
        }
        commandClient = null
    }

    private inner class ClientHandler : CommandClientHandler {

        override fun connected() {}

        override fun disconnected(message: String?) {}

        override fun clearLogs() {}

        override fun writeLogs(logs: String?) {}

        override fun writeStatus(message: String?) {
            if (message == null) return
            handler.updateStatus(message)
        }

        override fun writeVPNState(state: String?) {}
    }
}
