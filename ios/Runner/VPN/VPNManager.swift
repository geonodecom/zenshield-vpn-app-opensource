import Foundation
import Combine
import NetworkExtension

private struct VPNNotConfiguredError: LocalizedError {
    var errorDescription: String? {
        "Packet tunnel is not configured. Check signing, Network Extension capability, and that the Tunnel extension is embedded."
    }
}

final class VPNManager {
    static let shared: VPNManager = VPNManager()
    private var tunnelManager: NETunnelProviderManager?
    
    private static let tunnelLocalizedDescription = "Quattro VPN"
    
    func setup() async throws {
        try await loadVPNPreference()
    }
    
    func reset() {
        disconnect()
        Task { [weak self] in
            guard let self else { return }
            do {
                let managers = try await NETunnelProviderManager.loadAllFromPreferences()
                for manager in managers {
                    try await manager.removeFromPreferences()
                }
                self.tunnelManager = nil
                try await self.loadVPNPreference()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func connect(with config: String,
                 disableMemoryLimit: Bool = false,
                 isPaid: Bool = false,
                 timeout: Int) async throws {
        if tunnelManager == nil {
            try await loadVPNPreference()
        }
        guard let manager = tunnelManager else {
            throw VPNNotConfiguredError()
        }
        try await enableVPNManager(manager)
        try manager.connection.startVPNTunnel(options: [
            "Config": config as NSString,
            "DisableMemoryLimit": (disableMemoryLimit ? "YES" : "NO") as NSString,
            "IsPaid": NSNumber(value: isPaid),
            "Timeout": NSNumber(value: timeout)
        ])
    }
    
    func disconnect() {
        Task {
            guard let managers = try? await NETunnelProviderManager.loadAllFromPreferences() else {
                return
            }
            for manager in managers {
                manager.connection.stopVPNTunnel()
            }
        }
    }
    
    private func loadVPNPreference() async throws {
        let tunnelName = Self.tunnelLocalizedDescription
        let managers = try await NETunnelProviderManager.loadAllFromPreferences()
        if let manager = managers.first(where: { $0.localizedDescription == tunnelName }) {
            tunnelManager = manager
            return
        }
        let newManager = NETunnelProviderManager()
        let `protocol` = NETunnelProviderProtocol()
        `protocol`.providerBundleIdentifier = Bundle.main.baseBundleIdentifier + "." + Bundle.main.tunnelBundleSuffix
        `protocol`.serverAddress = "localhost"
        newManager.protocolConfiguration = `protocol`
        newManager.localizedDescription = tunnelName
        newManager.isEnabled = true
        try await newManager.saveToPreferences()
        try await newManager.loadFromPreferences()
        tunnelManager = newManager
    }
    
    private func enableVPNManager(_ manager: NETunnelProviderManager) async throws {
        manager.isEnabled = true
        try await manager.saveToPreferences()
        try await manager.loadFromPreferences()
    }
}
