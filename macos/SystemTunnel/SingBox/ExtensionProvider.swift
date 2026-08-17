import Foundation
import ZenshieldBox
import NetworkExtension
import CoreLocation

open class ExtensionProvider: NEPacketTunnelProvider {
    public var username: String? = nil
    private var commandServer: LibboxCommandServer!
    private var boxService: LibboxBoxService!
    private var systemProxyAvailable = false
    private var systemProxyEnabled = false
    private var platformInterface: ExtensionPlatformInterface!
    private var config: String!
    
    override open func startTunnel(options: [String: NSObject]?) async throws {
        NSLog("[Zenshield] ExtensionProvider startTunnel entered")
        LibboxClearServiceError()
        
        guard let config = options?["Config"] as? NSString as? String else {
            writeFatalError("(packet-tunnel) error: config not provided")
            return
        }
        
        var error: NSError?
        let preparedConfig = LibboxGetFullConfig(config, &error)
        
        if let error {
            writeFatalError("(packet-tunnel) error: prepare config: \(error.localizedDescription)")
            return
        }
        
        guard let enabledMemorylimit = options?["DisableMemoryLimit"] as? NSString else {
            writeFatalError("(packet-tunnel) error: EnabledMemorylimit not provided")
            return
        }
        
        self.config = preparedConfig
        
        let setupOptions = LibboxSetupOptions()
        
        let basePath = options?["BasePath"] as? NSString as? String ?? FilePath.sharedDirectory.relativePath
        let workingPath = options?["WorkingPath"] as? NSString as? String ?? FilePath.workingDirectory.relativePath
        let tempPath = options?["TempPath"] as? NSString as? String ?? FilePath.cacheDirectory.relativePath
        

        
        setupOptions.basePath = basePath
        setupOptions.workingPath = workingPath
        setupOptions.tempPath = tempPath
        
        let oldMask = umask(0o000)
        defer { umask(oldMask) }
#if os(tvOS)
        setupOptions.isTVOS = true
#endif
        LibboxSetup(setupOptions, &error)
        if let error {
            writeFatalError("(packet-tunnel) error: setup service: \(error.localizedDescription)")
            return
        }
        
        LibboxRedirectStderr((tempPath as NSString).appendingPathComponent("stderr.log"), &error)
        if let error {
            writeFatalError("(packet-tunnel) redirect stderr error: \(error.localizedDescription)")
            return
        }
        
        LibboxSetMemoryLimit(enabledMemorylimit == "NO")
        
        if platformInterface == nil {
            platformInterface = ExtensionPlatformInterface(self)
        }
        commandServer = LibboxNewCommandServer(platformInterface, Int32(300))
        do {
            try commandServer.start()
        } catch {
            writeFatalError("(packet-tunnel): log server start error: \(error.localizedDescription)")
            return
        }
        await startService()
    }
    
    func writeMessage(_ message: String) {
        if let commandServer {
            commandServer.writeMessage(message)
        }
    }
    
    public func writeFatalError(_ message: String) {
        NSLog("[Zenshield] ExtensionProvider fatal: %@", message)
        writeMessage(message)
        var error: NSError?
        LibboxWriteServiceError(message, &error)
        cancelTunnelWithError(nil)
    }
    
    struct Variant {
        static let useSystemExtension = true
    }
    private func startService() async {
        let configContent = config
        var error: NSError?
        let service = LibboxNewService(configContent, platformInterface, &error)
        if let error {
            writeFatalError("(packet-tunnel) error: create service: \(error.localizedDescription)")
            return
        }
        guard let service else {
            return
        }
        do {
            try service.start()
        } catch {
            writeFatalError("(packet-tunnel) error: start service: \(error.localizedDescription)")
            return
        }
        NSLog("[Zenshield] ExtensionProvider startService: Libbox service started (openTun will run next)")
        commandServer.setService(service)
        boxService = service
#if os(macOS)
        if service.needWIFIState() {
            if !Variant.useSystemExtension {
                locationManager = CLLocationManager()
                locationDelegate = stubLocationDelegate(boxService)
                locationManager?.delegate = locationDelegate
                locationManager?.requestLocation()
            } else {
                commandServer.writeMessage("(packet-tunnel) WIFI SSID and BSSID information is not currently available in the standalone version of SFM. We are working on resolving this issue.")
            }
        }
#endif
    }
    
#if os(macOS)
    
    private var locationManager: CLLocationManager?
    private var locationDelegate: stubLocationDelegate?
    
    class stubLocationDelegate: NSObject, CLLocationManagerDelegate {
        private unowned let boxService: LibboxBoxService
        init(_ boxService: LibboxBoxService) {
            self.boxService = boxService
        }
        
        func locationManagerDidChangeAuthorization(_: CLLocationManager) {
            boxService.updateWIFIState()
        }
        
        func locationManager(_: CLLocationManager, didUpdateLocations _: [CLLocation]) {}
        
        func locationManager(_: CLLocationManager, didFailWithError _: Error) {}
    }
    
#endif
    
    private func stopService() {
        if let service = boxService {
            do {
                try service.close()
            } catch {
                writeMessage("(packet-tunnel) error: stop service: \(error.localizedDescription)")
            }
            boxService = nil
            commandServer.setService(nil)
        }
        if let platformInterface {
            platformInterface.reset()
        }
    }
    
    func reloadService() async {
        writeMessage("(packet-tunnel) reloading service")
        reasserting = true
        defer {
            reasserting = false
        }
        stopService()
        commandServer.resetLog()
        await startService()
    }
    
    func postServiceClose() {
        boxService = nil
    }
    
    override open func stopTunnel(with reason: NEProviderStopReason) async {
        writeMessage("(packet-tunnel) stopping, reason: \(reason)")
        stopService()
        if let server = commandServer {
            try? await Task.sleep(nanoseconds: 100 * NSEC_PER_MSEC)
            try? server.close()
            commandServer = nil
        }
    }
    
    override open func handleAppMessage(_ messageData: Data) async -> Data? {
        messageData
    }
    
    override open func sleep() async {
        if let boxService {
            boxService.pause()
        }
    }
    
    override open func wake() {
        if let boxService {
            boxService.wake()
        }
    }
}
