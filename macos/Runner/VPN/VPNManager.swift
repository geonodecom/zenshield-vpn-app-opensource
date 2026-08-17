import Foundation
import Combine
import NetworkExtension
import SystemExtensions

final class VPNManager {
    static let shared: VPNManager = VPNManager()
    private var manager = NEVPNManager.shared()

    static var useSystemExtension: Bool = true

    private let userDefaults = UserDefaults.standard
    private let vpnAlreadyPromptedForSystemExtension = "vpnAlreadyPromptedForSystemExtension13"

    func setup() async throws {
        NSLog("[Zenshield] VPNManager.setup start")
        do {
            try await loadVPNPreference()
            NSLog("[Zenshield] VPNManager.setup done")
        } catch {
            NSLog("[Zenshield] VPNManager.setup error: %@", error.localizedDescription)
            print(error.localizedDescription)
        }
    }

    func reset() {
        NSLog("[Zenshield] VPNManager.reset")
        disconnect()

        Task { [weak self] () in
            self?.manager = .shared()
            do {
                let managers = try await NETunnelProviderManager.loadAllFromPreferences()
                NSLog("[Zenshield] VPNManager.reset removing %d manager(s)", managers.count)
                for manager in managers {
                    try await manager.removeFromPreferences()
                }
                try await self?.loadVPNPreference()
                NSLog("[Zenshield] VPNManager.reset done")
            } catch {
                NSLog("[Zenshield] VPNManager.reset error: %@", error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }

    func connect(with config: String,
                 disableMemoryLimit: Bool = false) async throws {
        NSLog("[Zenshield] VPNManager.connect start useSystemExtension=%d", VPNManager.useSystemExtension ? 1 : 0)
        if VPNManager.useSystemExtension {
            try await ensureSystemExtensionInstalled()
            NSLog("[Zenshield] VPNManager.connect system extension ready")
        }

        try await enableVPNManager()

        var options: [String: NSString] = [
            "Config": config as NSString,
            "DisableMemoryLimit": (disableMemoryLimit ? "YES" : "NO") as NSString,
        ]

        if VPNManager.useSystemExtension {
            options["BasePath"] = FilePath.sharedBasePath as NSString
            options["WorkingPath"] = FilePath.sharedWorkingPath as NSString
            options["TempPath"] = FilePath.sharedTempPath as NSString
        } else {
            options["BasePath"] = FilePath.sharedDirectory.relativePath as NSString
            options["WorkingPath"] = FilePath.workingDirectory.relativePath as NSString
            options["TempPath"] = FilePath.cacheDirectory.relativePath as NSString
        }

        NSLog("[Zenshield] VPNManager.connect startVPNTunnel")
        try manager.connection.startVPNTunnel(options: options)
        NSLog("[Zenshield] VPNManager.connect startVPNTunnel returned, connection.status=%d", manager.connection.status.rawValue)
    }

    func disconnect() {
        Task {
            try? await NETunnelProviderManager.loadAllFromPreferences()
                .map { manager in
                    manager.connection.stopVPNTunnel()
                }
        }
    }

    private func loadVPNPreference() async throws {
        do {
            let tunnelName = "Zenshield"
            let managers = try await NETunnelProviderManager.loadAllFromPreferences()
            if let manager = managers.first(where: { manager in
                manager.localizedDescription == tunnelName
            }) {
                self.manager = manager
                let pid = (manager.protocolConfiguration as? NETunnelProviderProtocol)?.providerBundleIdentifier ?? "nil"
                NSLog("[Zenshield] VPNManager.loadVPNPreference using existing manager provider=%@", pid)
                return
            }
            let newManager = NETunnelProviderManager()
            let `protocol` = NETunnelProviderProtocol()
            if VPNManager.useSystemExtension {
                // SystemTunnel target: com.zenshield.vpn.networkextension (tunnelBundleSuffix from Common.xcconfig)
                `protocol`.providerBundleIdentifier = Bundle.main.baseBundleIdentifier + "." + Bundle.main.tunnelBundleSuffix
            } else {
                // Legacy app extension Tunnel target: com.zenshield.vpn.packettunnel
                `protocol`.providerBundleIdentifier = Bundle.main.baseBundleIdentifier + ".packettunnel"
            }
            NSLog("[Zenshield] VPNManager.loadVPNPreference creating new manager provider=%@", `protocol`.providerBundleIdentifier ?? "nil")
            `protocol`.serverAddress = "localhost"
            newManager.protocolConfiguration = `protocol`
            newManager.localizedDescription = tunnelName
            try await newManager.saveToPreferences()
            try await newManager.loadFromPreferences()
            self.manager = newManager
        } catch {
            NSLog("[Zenshield] VPNManager.loadVPNPreference error: %@", error.localizedDescription)
            print(error.localizedDescription)
        }
    }

    private func enableVPNManager() async throws {
        manager.isEnabled = true
        do {
            try await manager.saveToPreferences()
            try await manager.loadFromPreferences()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func ensureSystemExtensionInstalled() async throws {
        let status = await SystemExtension.getExtensionStatus()
        NSLog("[Zenshield] VPNManager.ensureSystemExtensionInstalled extension status=%@ (%@)", String(describing: status), status.description)

        defer {
            userDefaults.set(true, forKey: vpnAlreadyPromptedForSystemExtension)
        }

        switch status {
        case .enabled:
            NSLog("[Zenshield] VPNManager.ensureSystemExtensionInstalled branch: enabled -> return success")
            return

        case .awaitingUserApproval, .installed:
            let alreadyPrompted = userDefaults.bool(forKey: vpnAlreadyPromptedForSystemExtension)
            if alreadyPrompted {
                NSLog("[Zenshield] VPNManager.ensureSystemExtensionInstalled branch: awaitingUserApproval, alreadyPrompted=true -> throw systemExtensionRequiresUserApproval")
                throw VPNError.systemExtensionRequiresUserApproval
            }
            NSLog("[Zenshield] VPNManager.ensureSystemExtensionInstalled branch: awaitingUserApproval, alreadyPrompted=false -> return (user will see approval UI)")
            return

        case .notInstalled:
            NSLog("[Zenshield] VPNManager.ensureSystemExtensionInstalled branch: status=%@ -> calling install(forceUpdate: true)", String(describing: status))
            let result = try await SystemExtension.install(forceUpdate: true, inBackground: false)
            NSLog("[Zenshield] VPNManager.ensureSystemExtensionInstalled install returned result=%@", String(describing: result))
            try handleInstallResult(result)
        case .uninstalling:
            NSLog("[Zenshield] VPNManager.ensureSystemExtensionInstalled branch: uninstalling -> calling install (no throw)")
            _ = try? await SystemExtension.install(forceUpdate: true, inBackground: false)
        }
    }

    private func handleInstallResult(_ result: OSSystemExtensionRequest.Result?) throws {
        switch result {
        case .completed:
            NSLog("[Zenshield] VPNManager.handleInstallResult branch: .completed -> success")
            return
        case .willCompleteAfterReboot:
            NSLog("[Zenshield] VPNManager.handleInstallResult branch: .willCompleteAfterReboot -> throw systemExtensionUnknownError")
            throw VPNError.systemExtensionUnknownError
        case nil:
            let alreadyPrompted = userDefaults.bool(forKey: vpnAlreadyPromptedForSystemExtension)
            if alreadyPrompted {
                NSLog("[Zenshield] VPNManager.handleInstallResult branch: nil, alreadyPrompted=true -> throw systemExtensionRequiresUserApproval")
                //throw VPNError.systemExtensionRequiresUserApproval
            } else {
                NSLog("[Zenshield] VPNManager.handleInstallResult branch: nil, alreadyPrompted=false -> throw systemExtensionUnknownError")
                throw VPNError.systemExtensionUnknownError
            }
        case .some(let other):
            NSLog("[Zenshield] VPNManager.handleInstallResult branch: .some(%@) -> throw systemExtensionUnknownError", String(describing: other))
            throw VPNError.systemExtensionUnknownError
        }
    }
}

enum VPNError: LocalizedError {
    case systemExtensionRequiresUserApproval
    case systemExtensionUnknownError

    var errorDescription: String? {
        switch self {
        case .systemExtensionRequiresUserApproval:
            return "Please approve the system extension in System Preferences → Privacy & Security → Extensions, then try connecting again."
        case .systemExtensionUnknownError:
            return "System extension could not be installed. Please check System Preferences → Privacy & Security → Extensions."
        }
    }
}
