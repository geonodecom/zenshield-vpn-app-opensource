#if os(macOS)
import Foundation
import SystemExtensions

public class SystemExtension: NSObject, OSSystemExtensionRequestDelegate {
    private let forceUpdate: Bool
    private let inBackground: Bool
    private let semaphore = DispatchSemaphore(value: 0)
    private var result: OSSystemExtensionRequest.Result?
    private var properties: [OSSystemExtensionProperties]?
    private var error: Error?

    /// Must match SystemTunnel target PRODUCT_BUNDLE_IDENTIFIER (e.g. com.zenshield.vpn.networkextension)
    private var extensionName: String {
        Bundle.main.baseBundleIdentifier + "." + Bundle.main.tunnelBundleSuffix
    }

    private init(_ forceUpdate: Bool = false, _ inBackground: Bool = false) {
        self.forceUpdate = forceUpdate
        self.inBackground = inBackground
    }

    public func request(_: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        if forceUpdate {
            NSLog("[Zenshield] SystemExtension actionForReplacingExtension -> replace (forceUpdate=true)")
            return .replace
        }
        if existing.isAwaitingUserApproval, !inBackground {
            NSLog("[Zenshield] SystemExtension actionForReplacingExtension -> replace (existing isAwaitingUserApproval)")
            return .replace
        }
        if existing.bundleIdentifier == ext.bundleIdentifier,
           existing.bundleVersion == ext.bundleVersion,
           existing.bundleShortVersion == ext.bundleShortVersion
        {
            NSLog("[Zenshield] SystemExtension actionForReplacingExtension -> cancel (same version)")
            return .cancel
        } else {
            NSLog("[Zenshield] SystemExtension actionForReplacingExtension -> replace (version mismatch)")
            return .replace
        }
    }

    public func requestNeedsUserApproval(_: OSSystemExtensionRequest) {
        NSLog("[Zenshield] SystemExtension requestNeedsUserApproval (user must approve in System Settings)")
        semaphore.signal()
    }

    public func request(_: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        NSLog("[Zenshield] SystemExtension didFinishWithResult: %@", String(describing: result))
        self.result = result
        semaphore.signal()
    }

    public func request(_: OSSystemExtensionRequest, didFailWithError error: Error) {
        NSLog("[Zenshield] SystemExtension didFailWithError: %@", error.localizedDescription)
        self.error = error
        semaphore.signal()
    }

    public func request(_: OSSystemExtensionRequest, foundProperties properties: [OSSystemExtensionProperties]) {
        NSLog("[Zenshield] SystemExtension foundProperties: count=%@", String(describing: properties.count))
        self.properties = properties
        semaphore.signal()
    }

    public func activation() throws -> OSSystemExtensionRequest.Result? {
        NSLog("[Zenshield] SystemExtension activation submitting for %@", extensionName)
        let request = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionName, queue: .main)
        request.delegate = self
        OSSystemExtensionManager.shared.submitRequest(request)
        semaphore.wait()
        if let error {
            NSLog("[Zenshield] SystemExtension activation failed with error: %@", error.localizedDescription)
            throw error
        }
        NSLog("[Zenshield] SystemExtension activation completed result=%@", String(describing: result))
        return result
    }

    public func deactivation() throws -> OSSystemExtensionRequest.Result? {
        NSLog("[Zenshield] SystemExtension deactivation submitting for %@", extensionName)
        let request = OSSystemExtensionRequest.deactivationRequest(forExtensionWithIdentifier: extensionName, queue: .main)
        request.delegate = self
        OSSystemExtensionManager.shared.submitRequest(request)
        semaphore.wait()
        if let error {
            NSLog("[Zenshield] SystemExtension deactivation failed with error: %@", error.localizedDescription)
            throw error
        }
        NSLog("[Zenshield] SystemExtension deactivation completed result=%@", String(describing: result))
        return result
    }

    public func getProperties() throws -> [OSSystemExtensionProperties] {
        NSLog("[Zenshield] SystemExtension getProperties requesting for %@", extensionName)
        let request = OSSystemExtensionRequest.propertiesRequest(forExtensionWithIdentifier: extensionName, queue: .main)
        request.delegate = self
        OSSystemExtensionManager.shared.submitRequest(request)
        semaphore.wait()
        if let error {
            NSLog("[Zenshield] SystemExtension getProperties failed with error: %@", error.localizedDescription)
            throw error
        }
        guard let properties = properties else {
            NSLog("[Zenshield] SystemExtension getProperties no properties returned")
            throw NSError(domain: "SystemExtension", code: -1, userInfo: [NSLocalizedDescriptionKey: "No properties returned"])
        }
        NSLog("[Zenshield] SystemExtension getProperties success: count=%@", String(describing: properties.count))
        return properties
    }

    public static func isInstalled() async -> Bool {
        await (try? Task {
            try await isInstalledBackground()
        }.result.get()) == true
    }

    public nonisolated static func isInstalledBackground() async throws -> Bool {
        for _ in 0 ..< 3 {
            do {
                let propList = try SystemExtension().getProperties()
                if propList.isEmpty {
                    return false
                }
                for extensionProp in propList {
                    if !extensionProp.isAwaitingUserApproval, !extensionProp.isUninstalling {
                        return true
                    }
                }
            } catch {
                try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            }
        }
        return false
    }

    public nonisolated static func install(forceUpdate: Bool = false, inBackground: Bool = false) async throws -> OSSystemExtensionRequest.Result? {
        NSLog("[Zenshield] SystemExtension install(forceUpdate=%d, inBackground=%d)", forceUpdate ? 1 : 0, inBackground ? 1 : 0)
        let res = try await Task.detached {
            try SystemExtension(forceUpdate, inBackground).activation()
        }.result.get()
        NSLog("[Zenshield] SystemExtension install returning result=%@", String(describing: res))
        return res
    }

    public nonisolated static func uninstall() async throws -> OSSystemExtensionRequest.Result? {
        NSLog("[Zenshield] SystemExtension uninstall starting")
        let res = try await Task.detached {
            try SystemExtension().deactivation()
        }.result.get()
        NSLog("[Zenshield] SystemExtension uninstall completed result=%@", String(describing: res))
        return res
    }

    public nonisolated static func forceUninstall() async throws -> OSSystemExtensionRequest.Result? {
        NSLog("[Zenshield] SystemExtension forceUninstall starting")
        do {
            let res = try await uninstall()
            NSLog("[Zenshield] SystemExtension forceUninstall completed result=%@", String(describing: res))
            return res
        } catch {
            NSLog("[Zenshield] SystemExtension forceUninstall error (ignoring): %@", error.localizedDescription)
            return nil
        }
    }

    public nonisolated static func getExtensionStatus() async -> ExtensionStatus {
        NSLog("[Zenshield] SystemExtension getExtensionStatus requesting...")
        do {
            let propList = try SystemExtension().getProperties()

            if propList.isEmpty {
                NSLog("[Zenshield] SystemExtension getExtensionStatus -> notInstalled (empty list)")
                return .notInstalled
            }

            let skipUninstallingWhenMultiple = propList.count > 1

            for extensionProp in propList {
                if extensionProp.isUninstalling {
                    if skipUninstallingWhenMultiple {
                        continue
                    }
                    NSLog("[Zenshield] SystemExtension getExtensionStatus -> uninstalling")
                    return .uninstalling
                }
                if extensionProp.isAwaitingUserApproval {
                    NSLog("[Zenshield] SystemExtension getExtensionStatus -> awaitingUserApproval")
                    return .awaitingUserApproval
                }
                if extensionProp.isEnabled {
                    NSLog("[Zenshield] SystemExtension getExtensionStatus -> enabled")
                    return .enabled
                }
                NSLog("[Zenshield] SystemExtension getExtensionStatus -> installed (not enabled)")
                return .installed
            }

            NSLog("[Zenshield] SystemExtension getExtensionStatus -> uninstalling (all entries skipped)")
            return .uninstalling
        } catch {
            NSLog("[Zenshield] SystemExtension getExtensionStatus -> notInstalled (error: %@)", error.localizedDescription)
            return .notInstalled
        }
    }
}

public enum ExtensionStatus {
    case notInstalled
    case installed
    case enabled
    case awaitingUserApproval
    case uninstalling

    var description: String {
        switch self {
        case .notInstalled:
            return "Not installed"
        case .installed:
            return "Installed but not enabled"
        case .enabled:
            return "Enabled and ready"
        case .awaitingUserApproval:
            return "Awaiting user approval"
        case .uninstalling:
            return "Uninstalling"
        }
    }
}
#endif
