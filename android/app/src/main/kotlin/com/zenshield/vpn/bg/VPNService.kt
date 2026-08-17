package com.zenshield.vpn.bg

import android.content.Intent
import android.content.pm.PackageManager.NameNotFoundException
import android.net.VpnService
import android.os.Build
import android.util.Log
import com.zenshield.vpn.Settings
import com.zenshield.vpn.ktx.toIpPrefix
import com.vpnapp.zenshield.libbox.Notification
import com.vpnapp.zenshield.libbox.TunOptions
import com.zenshield.vpn.utils.MIUIUtils
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext

class VPNService : VpnService(), PlatformInterfaceWrapper {
    private val service = BoxService(this, this)

    companion object {
        // Cap the tun MTU on Android. sing-box hands us 1400, but the real
        // usable MTU inside a vless-over-websocket-over-TLS tunnel is lower
        // (outer TCP/IP + TLS + WS + vless overhead on top of a ~1500 link).
        // At 1400 the largest TLS records black-hole: the tunnel connects and
        // small flows (DNS, probes) work, but full HTTPS pages hang/time out.
        // Clamping the tun MTU makes the OS advertise a smaller TCP MSS, so
        // both directions use segments that fit through the tunnel. 1280 is the
        // widely-safe VPN MTU (IPv6 minimum). Windows (wintun) is unaffected.
        private const val MAX_TUN_MTU = 1280
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.i("onStartCommand", "starting")

        return service.onStartCommand()
    }

    override fun onRevoke() {
        runBlocking { withContext(Dispatchers.Main) { service.onRevoke() } }
    }

    override fun autoDetectInterfaceControl(fd: Int) {
        protect(fd)
    }

    fun addExcludePackage(builder: Builder, packageName: String) {
        try {
            builder.addDisallowedApplication(packageName)
        } catch (e: NameNotFoundException) {
            Log.e(
                    "VPNService",
                    "Failed to add disallowed application (NameNotFoundException): $packageName",
                    e
            )
        } catch (e: Exception) {
            Log.e("VPNService", "Failed to add disallowed application (Exception): $packageName", e)
        }
    }

    fun addIncludePackage(builder: Builder, packageName: String) {
        try {
            builder.addAllowedApplication(packageName)
        } catch (e: NameNotFoundException) {
            Log.e(
                    "VPNService",
                    "Failed to add allowed application (NameNotFoundException): $packageName",
                    e
            )
        } catch (e: Exception) {
            Log.e("VPNService", "Failed to add allowed application (Exception): $packageName", e)
        }
    }

    override fun openTun(options: TunOptions): Int {
        if (prepare(this) != null) error("android: missing vpn permission")

        val diagTag = "VPN-DIAG"
        val tunMtu = minOf(options.mtu, MAX_TUN_MTU)
        Log.i(diagTag, "openTun: mtu=$tunMtu (requested=${options.mtu}) autoRoute=${options.autoRoute} smartMode=${Settings.isSmartModeEnabled}")

        val builder = Builder().setSession("Zenshield VPN").setMtu(tunMtu)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            builder.setMetered(false)
        }

        var hasInet4Address = false
        val inet4Address = options.inet4Address
        while (inet4Address.hasNext()) {
            hasInet4Address = true
            val address = inet4Address.next()
            builder.addAddress(address.address(), address.prefix())
        }

        var hasInet6Address = false
        val inet6Address = options.inet6Address
        while (inet6Address.hasNext()) {
            hasInet6Address = true
            val address = inet6Address.next()
            builder.addAddress(address.address(), address.prefix())
        }

        var addedDefaultRoute4 = false
        var addedDefaultRoute6 = false

        if (options.autoRoute) {
            builder.addDnsServer(options.dnsServerAddress.value)
            Log.i(diagTag, "openTun: dns=${options.dnsServerAddress.value}")

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val inet4RouteAddress = options.inet4RouteAddress
                if (inet4RouteAddress.hasNext()) {
                    while (inet4RouteAddress.hasNext()) {
                        builder.addRoute(inet4RouteAddress.next().toIpPrefix())
                    }
                } else if (hasInet4Address) {
                    builder.addRoute("0.0.0.0", 0)
                    addedDefaultRoute4 = true
                }

                val inet6RouteAddress = options.inet6RouteAddress
                if (inet6RouteAddress.hasNext()) {
                    while (inet6RouteAddress.hasNext()) {
                        builder.addRoute(inet6RouteAddress.next().toIpPrefix())
                    }
                } else if (hasInet6Address) {
                    builder.addRoute("::", 0)
                    addedDefaultRoute6 = true
                }

                val inet4RouteExcludeAddress = options.inet4RouteExcludeAddress
                while (inet4RouteExcludeAddress.hasNext()) {
                    builder.excludeRoute(inet4RouteExcludeAddress.next().toIpPrefix())
                }

                val inet6RouteExcludeAddress = options.inet6RouteExcludeAddress
                while (inet6RouteExcludeAddress.hasNext()) {
                    builder.excludeRoute(inet6RouteExcludeAddress.next().toIpPrefix())
                }
            } else {
                val inet4RouteAddress = options.inet4RouteRange
                if (inet4RouteAddress.hasNext()) {
                    while (inet4RouteAddress.hasNext()) {
                        val address = inet4RouteAddress.next()
                        builder.addRoute(address.address(), address.prefix())
                    }
                } else if (hasInet4Address) {
                    builder.addRoute("0.0.0.0", 0)
                    addedDefaultRoute4 = true
                }

                val inet6RouteAddress = options.inet6RouteRange
                if (inet6RouteAddress.hasNext()) {
                    while (inet6RouteAddress.hasNext()) {
                        val address = inet6RouteAddress.next()
                        builder.addRoute(address.address(), address.prefix())
                    }
                } else if (hasInet6Address) {
                    builder.addRoute("::", 0)
                    addedDefaultRoute6 = true
                }
            }

            if (Settings.perAppProxyEnabled) {
                val appList = Settings.perAppProxyList

                if (Settings.perAppProxyMode == Settings.PER_APP_PROXY_INCLUDE) {
                    if (Settings.isSmartModeEnabled) {
                        appList.forEach { addIncludePackage(builder, it) }
                        addIncludePackage(builder, packageName)
                    }
                } else {
                    if (Settings.isSmartModeEnabled) {
                        appList.forEach { addExcludePackage(builder, it) }
                    }
                }
            } else {
                if (Settings.isSmartModeEnabled) {
                    val includePackage = options.includePackage
                    if (includePackage.hasNext()) {
                        while (includePackage.hasNext()) {
                            val pkg = includePackage.next()
                            addIncludePackage(builder, pkg)
                        }
                    }

                    val excludePackage = options.excludePackage
                    if (excludePackage.hasNext()) {
                        while (excludePackage.hasNext()) {
                            val pkg = excludePackage.next()
                            addExcludePackage(builder, pkg)
                        }
                    }
                }
            }


        }

        // Control-plane traffic (agreements, configs, auth) must bypass the tunnel.
        addExcludePackage(builder, packageName)

        Log.i(
            diagTag,
            "openTun: hasInet4=$hasInet4Address hasInet6=$hasInet6Address " +
                "defaultRoute4=$addedDefaultRoute4 defaultRoute6=$addedDefaultRoute6 " +
                "perAppProxy=${Settings.perAppProxyEnabled} selfExcluded=true",
        )

        val pfd =
                builder.establish()
                        ?: error("android: the application is not prepared or is revoked")
        service.fileDescriptor = pfd
        Log.i(diagTag, "openTun: established tun fd=${pfd.fd}")
        return pfd.fd
    }

    override fun writeLog(message: String) = service.writeLog(message)

    override fun sendNotification(notification: Notification) =
            service.sendNotification(notification)
}
