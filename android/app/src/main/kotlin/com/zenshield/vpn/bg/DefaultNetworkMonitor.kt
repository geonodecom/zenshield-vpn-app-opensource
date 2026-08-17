package com.zenshield.vpn.bg

import android.net.Network
import android.net.NetworkCapabilities
import android.os.Build
import com.zenshield.vpn.Application
import com.zenshield.vpn.constant.Bugs
import com.vpnapp.zenshield.libbox.InterfaceUpdateListener
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.net.NetworkInterface

object DefaultNetworkMonitor {

    private var defaultNetwork: Network? = null
    private var listener: InterfaceUpdateListener? = null

    suspend fun start() {
        DefaultNetworkListener.start(this) {
            defaultNetwork = it
            checkDefaultInterfaceUpdate(it)
        }
        defaultNetwork = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val active = Application.connectivity.activeNetwork
            val caps = active?.let { Application.connectivity.getNetworkCapabilities(it) }
            if (caps?.hasTransport(NetworkCapabilities.TRANSPORT_VPN) == true) null else active
        } else {
            null
        }
    }

    suspend fun stop() {
        DefaultNetworkListener.stop(this)
    }

    suspend fun require(): Network {
        val network = defaultNetwork
        if (network != null) {
            return network
        }
        return DefaultNetworkListener.get()
    }

    fun setListener(listener: InterfaceUpdateListener?) {
        this.listener = listener
        checkDefaultInterfaceUpdate(defaultNetwork)
    }

    private fun checkDefaultInterfaceUpdate(
        newNetwork: Network?
    ) {
        val listener = listener ?: return
        if (newNetwork != null) {
            val interfaceName =
                (Application.connectivity.getLinkProperties(newNetwork) ?: return).interfaceName
            (0 until 10).forEach { times ->
                var interfaceIndex: Int
                try {
                    interfaceIndex = NetworkInterface.getByName(interfaceName).index
                } catch (e: Exception) {
                    Thread.sleep(100)
                    return@forEach
                }
                if (Bugs.fixAndroidStack) {
                    GlobalScope.launch(Dispatchers.IO) {
                        listener.updateDefaultInterface(interfaceName, interfaceIndex, false, false)
                    }
                } else {
                    listener.updateDefaultInterface(interfaceName, interfaceIndex, false, false)
                }
            }
        } else {
            if (Bugs.fixAndroidStack) {
                GlobalScope.launch(Dispatchers.IO) {
                    listener.updateDefaultInterface("", -1, false, false)
                }
            } else {
                listener.updateDefaultInterface("", -1, false, false)
            }
        }
    }

}