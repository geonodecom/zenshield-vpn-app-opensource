import Foundation
import ZenshieldBox
import NetworkExtension

open class ExtensionProvider: NEPacketTunnelProvider {
    public var username: String? = nil
    private var commandServer: LibboxCommandServer!
    private var boxService: LibboxBoxService!
    private var systemProxyAvailable = false
    private var systemProxyEnabled = false
    private var platformInterface: ExtensionPlatformInterface!
    private var config: String!
    private var unpaidStartTime: Date?
    private var paymentTimer: DispatchSourceTimer?
    private var isStarting = false

    override open func startTunnel(options: [String: NSObject]?) async throws {
        guard !isStarting else {
            return
        }
        isStarting = true
        defer { isStarting = false }
        LibboxClearServiceError()
        
        guard let config = options?["Config"] as? NSString as? String else {
            writeFatalError("(packet-tunnel) error: config not provided")
            return
        }
        
        var parseError : NSError?
        var preparedConfig = LibboxGetFullConfig(config, &parseError)

        if (parseError != nil) {
            writeFatalError("(packet-tunnel) error: config parsing failed: \(String(describing: parseError?.localizedDescription))")
        }

        preparedConfig = Self.appendLocalSocksInbound(to: preparedConfig)

        guard let enabledMemorylimit = options?["DisableMemoryLimit"] as? NSString else {
            writeFatalError("(packet-tunnel) error: EnabledMemorylimit not provided")
            return
        }

        self.config = preparedConfig

        guard let isPaidNumber = options?["IsPaid"] as? NSNumber else {
            writeFatalError("(packet-tunnel) error: is paid not provided")
            return
        }
        
        let isPaid = isPaidNumber.boolValue
        
        if !isPaid {
            guard let timeout = options?["Timeout"] as? NSNumber else {
                return
            }
            unpaidStartTime = Date()
            schedulePaymentTimer(timeout: timeout.intValue)
        }
        
        let options = LibboxSetupOptions()
        options.basePath = FilePath.sharedDirectory.relativePath
        options.workingPath = FilePath.workingDirectory.relativePath
        options.tempPath = FilePath.cacheDirectory.relativePath
        var error: NSError?
#if os(tvOS)
        options.isTVOS = true
#endif
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

    private func schedulePaymentTimer(timeout: Int) {
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer.schedule(deadline: .now() + 60, repeating: .never, leeway: .seconds(1))
        timer.setEventHandler { [weak self, weak timer] in
            guard let self = self, let start = self.unpaidStartTime else { return }
            let elapsed = Date().timeIntervalSince(start)
            timer?.cancel()
            if elapsed >= Double(timeout) {
                Task {
                    await self.stopTunnel(with: NEProviderStopReason.none)
                    self.cancelTunnelWithError(nil)
                }
            } else {
                self.schedulePaymentTimer(timeout: timeout)
            }
        }
        timer.resume()
        paymentTimer = timer
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

    private static func insertBeforeArrayClose(in json: String, arrayKey: String, insertion: String) -> String? {
        // Match "key": [ with flexible whitespace (pretty-printed or compact)
        guard let keyRange = json.range(of: "\"\(arrayKey)\"") else { return nil }
        // Find the '[' after the key
        var searchIdx = keyRange.upperBound
        while searchIdx < json.endIndex && json[searchIdx] != "[" {
            searchIdx = json.index(after: searchIdx)
        }
        guard searchIdx < json.endIndex else { return nil }
        // Now find the matching ']'
        var depth = 1
        var idx = json.index(after: searchIdx) // skip the '['
        while idx < json.endIndex && depth > 0 {
            let ch = json[idx]
            if ch == "[" { depth += 1 }
            else if ch == "]" { depth -= 1 }
            if depth > 0 { idx = json.index(after: idx) }
        }
        guard depth == 0 else { return nil }
        // idx points to the closing ']', insert before it
        var result = json
        result.insert(contentsOf: insertion, at: idx)
        return result
    }

    private static func appendLocalSocksInbound(to configJson: String) -> String {
        let socksInbound = #",{"type":"socks","tag":"local-socks","listen":"127.0.0.1","listen_port":10801}"#
        let socksRule = #",{"inbound":["local-socks"],"outbound":"direct"}"#

        var result = configJson

        // Insert socks inbound into "inbounds" array
        if let inserted = Self.insertBeforeArrayClose(in: result, arrayKey: "inbounds", insertion: socksInbound) {
            result = inserted
        } else {
            return configJson
        }

        // Insert socks routing rule into route.rules array (not dns.rules)
        if let routeRange = result.range(of: "\"route\"") {
            let routeSubstring = String(result[routeRange.lowerBound...])
            if let inserted = Self.insertBeforeArrayClose(in: routeSubstring, arrayKey: "rules", insertion: socksRule) {
                result = String(result[result.startIndex..<routeRange.lowerBound]) + inserted
            }
        }

        return result
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
        let startResult: Result<Void, Error> = await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try service.start()
                    continuation.resume(returning: .success(()))
                } catch {
                    continuation.resume(returning: .failure(error))
                }
            }
        }
        switch startResult {
        case .success:
            break
        case .failure(let error):
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
