import Cocoa
import FlutterMacOS

public class DesktopUpdaterPlugin: NSObject, FlutterPlugin {
    func getCurrentVersion() -> String {
        let infoDictionary = Bundle.main.infoDictionary!
        let version = infoDictionary["CFBundleVersion"] as! String
        return version
    }
    
    func restartApp() {
        let executablePath = Bundle.main.executablePath!
        let bundlePath = Bundle.main.bundlePath
        let executableName = (executablePath as NSString).lastPathComponent
        print("executablePath path: \(executablePath)")

        let updateFolder: String
        if let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first,
           let bundleId = Bundle.main.bundleIdentifier {
            updateFolder = appSupport.appendingPathComponent(bundleId).appendingPathComponent("update").path
        } else {
            updateFolder = bundlePath + "/Contents/update"
        }

        let scriptBody = """
        #!/bin/bash
        UPDATE_FOLDER="$1"
        BUNDLE_PATH="$2"
        EXECUTABLE_NAME="$3"
        sleep 2
        /usr/bin/rsync -a "$UPDATE_FOLDER/" "$BUNDLE_PATH/Contents/" || exit 1
        /bin/chmod 755 "$BUNDLE_PATH/Contents/MacOS/$EXECUTABLE_NAME"
        for f in "$BUNDLE_PATH/Contents/Library/SystemExtensions"/*/Contents/MacOS/*; do
          [ -f "$f" ] && /bin/chmod 755 "$f"
        done
        /usr/bin/open "$BUNDLE_PATH"
        /bin/rm -rf "$UPDATE_FOLDER"
        """
        let scriptURL = FileManager.default.temporaryDirectory.appendingPathComponent("desktop_updater_restart_\(ProcessInfo.processInfo.processIdentifier).sh")
        do {
            try scriptBody.write(to: scriptURL, atomically: true, encoding: .utf8)
            try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: scriptURL.path)
        } catch {
            print("Error writing launcher script: \(error)")
            return
        }

        let launcher = Process()
        launcher.executableURL = URL(fileURLWithPath: "/bin/bash")
        launcher.arguments = [scriptURL.path, updateFolder, bundlePath, executableName]
        launcher.standardInput = nil
        launcher.standardOutput = nil
        launcher.standardError = nil
        do {
            try launcher.run()
        } catch {
            print("Error launching updater script: \(error)")
            try? FileManager.default.removeItem(at: scriptURL)
            return
        }

        NSApplication.shared.terminate(nil)
    }
    
    func copyAndReplaceFiles(from sourcePath: String, to destinationPath: String) throws {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: sourcePath)
        
        while let element = enumerator?.nextObject() as? String {
            let sourceItemPath = (sourcePath as NSString).appendingPathComponent(element)
            let destinationItemPath = (destinationPath as NSString).appendingPathComponent(element)
            
            var isDir: ObjCBool = false
            if fileManager.fileExists(atPath: sourceItemPath, isDirectory: &isDir) {
                if isDir.boolValue {
                    // Ensure the directory exists at destination
                    if !fileManager.fileExists(atPath: destinationItemPath) {
                        try fileManager.createDirectory(atPath: destinationItemPath, withIntermediateDirectories: true, attributes: nil)
                    }
                } else {
                    // Handle file or symbolic link
                    let attributes = try fileManager.attributesOfItem(atPath: sourceItemPath)
                    if attributes[.type] as? FileAttributeType == .typeSymbolicLink {
                        // Handle symbolic link
                        if fileManager.fileExists(atPath: destinationItemPath) {
                            try fileManager.removeItem(atPath: destinationItemPath)
                        }
                        let target = try fileManager.destinationOfSymbolicLink(atPath: sourceItemPath)
                        try fileManager.createSymbolicLink(atPath: destinationItemPath, withDestinationPath: target)
                    } else {
                        // Handle regular file
                        if fileManager.fileExists(atPath: destinationItemPath) {
                            // Replace existing file
                            try fileManager.replaceItem(at: URL(fileURLWithPath: destinationItemPath), withItemAt: URL(fileURLWithPath: sourceItemPath), backupItemName: nil, options: [], resultingItemURL: nil)
                        } else {
                            // Copy new file
                            try fileManager.copyItem(atPath: sourceItemPath, toPath: destinationItemPath)
                        }
                    }
                }
            }
        }
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "desktop_updater", binaryMessenger: registrar.messenger)
        let instance = DesktopUpdaterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        case "restartApp":
            restartApp()
            result(nil)
        case "getExecutablePath":
            result(Bundle.main.executablePath)
        case "getCurrentVersion":
            result(getCurrentVersion())
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
