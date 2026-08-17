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
        LibboxClearServiceError()
        
        guard let config = options?["Config"] as? NSString as? String else {
            writeFatalError("(packet-tunnel) error: config not provided")
            return
        }
        
        var preparedConfig = LibboxGetFullConfig(config, nil)
        preparedConfig = Self.appendLocalSocksInbound(to: preparedConfig)
        
        guard let enabledMemorylimit = options?["DisableMemoryLimit"] as? NSString else {
            writeFatalError("(packet-tunnel) error: EnabledMemorylimit not provided")
            return
        }
        
        self.config = preparedConfig
        
        let options = LibboxSetupOptions()
        options.basePath = FilePath.sharedDirectory.relativePath
        options.workingPath = FilePath.workingDirectory.relativePath
        options.tempPath = FilePath.cacheDirectory.relativePath
        var error: NSError?
#if os(tvOS)
        options.isTVOS = true
#endif
//        if let username {
//            options.username = username
//        }
        LibboxSetup(options, &error)
        if let error {
            writeFatalError("(packet-tunnel) error: setup service: \(error.localizedDescription)")
            return
        }
        
        LibboxRedirectStderr(FilePath.cacheDirectory.appendingPathComponent("stderr.log").relativePath, &error)
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
#if DEBUG
        NSLog(message)
#endif
        writeMessage(message)
        var error: NSError?
        LibboxWriteServiceError(message, &error)
        cancelTunnelWithError(nil)
    }
    
    struct Variant {
        static let useSystemExtension = false
    }
    
    private static func appendLocalSocksInbound(to configJson: String) -> String {
        guard let data = configJson.data(using: .utf8),
              var root = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return configJson
        }
        var inbounds = root["inbounds"] as? [[String: Any]] ?? []
        let localSocks: [String: Any] = [
            "type": "socks",
            "tag": "local-socks",
            "listen": "127.0.0.1",
            "listen_port": 10801,
        ]
        inbounds.append(localSocks)
        root["inbounds"] = inbounds
        
        var route = root["route"] as? [String: Any] ?? [:]
        var rules = route["rules"] as? [[String: Any]] ?? []
        let localSocksRule: [String: Any] = [
            "inbound": ["local-socks"],
            "outbound": "direct",
        ]
        rules.append(localSocksRule)
        route["rules"] = rules
        root["route"] = route
        
        guard let outData = try? JSONSerialization.data(withJSONObject: root),
              let out = String(data: outData, encoding: .utf8) else {
            return configJson
        }
        return out
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
