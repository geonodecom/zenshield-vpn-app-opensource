import Combine
import ZenshieldBox

final class MethodHandler: NSObject, FlutterPlugin {
    
    // MARK: - Constants
    enum Methods: String {
        case initMethod = "init"
        case startMethod = "start"
        case stopMethod = "stop"
        case resetMethod = "reset"
        case getPingMethod = "get_ping"
        case changeServerMethod = "change_server"
        case testLinkMethod = "test_link"
        case getLinksOutboundsMethod = "get_links_outbounds"
    }
    
    enum ErrorCodes: String {
        case invalidArgs = "INVALID_ARGS"
        case setupConnection = "SETUP_CONNECTION"
        case noArguments = "NO_ARGUMENTS"
        case notCorrectLink = "NOT_CORRECT_LINK"
        case serverChangeError = "SERVER_CHANGE_ERROR"
    }
    
    public static let name = "\(Bundle.main.serviceIdentifier)/method"
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: Self.name, binaryMessenger: registrar.messenger())
        let instance = MethodHandler()
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.channel = channel
    }
    
    private var channel: FlutterMethodChannel?
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case Methods.initMethod.rawValue:
            handleInit(result: result)
            
        case Methods.startMethod.rawValue:
            handleStart(arguments: call.arguments, result: result)
            
        case Methods.stopMethod.rawValue:
            handleStop(result: result)
            
        case Methods.resetMethod.rawValue:
            handleReset(result: result)
            
        case Methods.getPingMethod.rawValue:
            handleGetPing(arguments: call.arguments, result: result)
            
        case Methods.changeServerMethod.rawValue:
            handleChangeServer(arguments: call.arguments, result: result)
            
        case Methods.testLinkMethod.rawValue:
            handleTestLink(arguments: call.arguments, result: result)
            
        case Methods.getLinksOutboundsMethod.rawValue:
            handleGetLinksOutbounds(arguments: call.arguments, result: result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Method Handlers
    
    private func handleInit(result: @escaping FlutterResult) {
        let paths = [
            "basePath": FilePath.sharedDirectory.relativePath,
            "workingPath": FilePath.workingDirectory.relativePath,
            "tempPath": FilePath.cacheDirectory.relativePath
        ]
        result(paths)
    }
    
    private func handleStart(arguments: Any?, result: @escaping FlutterResult) {
        @Sendable func mainResult(_ res: Any?) async -> Void {
            await MainActor.run {
                result(res)
            }
        }
        
        Task {
            guard
                let args = arguments as? [String: Any],
                let isPaid = (args["isPaid"] as? NSNumber)?.boolValue,
                let timoutSec = (args["timeoutSec"] as? NSNumber)?.intValue,
                let config = (args["config"] as? NSString) as? String
            else {
                await mainResult(FlutterError(code: ErrorCodes.invalidArgs.rawValue,
                                              message: "Config is missing or invalid",
                                              details: nil))
                return
            }
            
            do {
                try await VPNManager.shared.setup()
                try await VPNManager.shared.connect(with: config,
                                                    disableMemoryLimit: false,
                                                    isPaid: isPaid,
                                                    timeout: timoutSec)
            } catch {
                await mainResult(FlutterError(code: ErrorCodes.setupConnection.rawValue,
                                              message: error.localizedDescription,
                                              details: nil))
                return
            }
            
            await mainResult(true)
        }
    }
    
    private func handleStop(result: @escaping FlutterResult) {
        VPNManager.shared.disconnect()
        result(true)
    }
    
    private func handleReset(result: @escaping FlutterResult) {
        VPNManager.shared.reset()
        result(true)
    }
    
    private func handleGetPing(arguments: Any?, result: @escaping FlutterResult) {
        @Sendable func mainResult(_ res: Any?) async -> Void {
            await MainActor.run {
                result(res)
            }
        }
        
        Task {
            guard let linksString = arguments as? String else {
                await mainResult(FlutterError(code: ErrorCodes.noArguments.rawValue,
                                              message: "No arguments found",
                                              details: nil))
                return
            }
            
            let delegate = PingCallBack { pingResult in
                result(pingResult)
            }
            
            let wrapper = LibboxNewPingResultExportWrapper(delegate)
            wrapper?.checkIcmpPing(forLinks: linksString)
        }
    }
    
    private func handleChangeServer(arguments: Any?, result: @escaping FlutterResult) {
        guard let args = arguments as? [String: Any],
              let link = args["link"] as? String,
              let port = args["port"] as? Int,
              let bearer = args["bearer"] as? String else {
            result(FlutterError(code: ErrorCodes.invalidArgs.rawValue,
                                message: "Missing required parameters (link, port, or bearer)",
                                details: nil))
            return
        }
        
        let response = LibboxPutSelector(link, bearer, port)
        
        if !response.isEmpty {
            result(FlutterError(code: ErrorCodes.serverChangeError.rawValue,
                                message: "Error changing server: \(response)",
                                details: nil))
            return
        }
        
        result(nil)
    }
    
    private func handleTestLink(arguments: Any?, result: @escaping FlutterResult) {
        guard let link = arguments as? String else {
            result(FlutterError(code: ErrorCodes.noArguments.rawValue,
                                message: "No arguments found",
                                details: nil))
            return
        }
        
        let isCorrect = LibboxTestLink(link)
        
        if isCorrect {
            result(nil)
        } else {
            result(FlutterError(code: ErrorCodes.notCorrectLink.rawValue,
                                message: "Link is not correct",
                                details: nil))
        }
    }
    
    private func handleGetLinksOutbounds(arguments: Any?, result: @escaping FlutterResult) {
        guard let links = arguments as? String else {
            result(FlutterError(code: ErrorCodes.noArguments.rawValue,
                                message: "No arguments found",
                                details: nil))
            return
        }
        
        let linksOutbounds = LibboxGetLinksJson(links)
        result(linksOutbounds)
    }
}
