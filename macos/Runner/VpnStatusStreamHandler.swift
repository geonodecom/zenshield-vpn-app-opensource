import Foundation
import FlutterMacOS
import NetworkExtension


final class VpnStatusStreamHandler: NSObject, FlutterStreamHandler {
    private static var eventSink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        Self.eventSink = events
        sendCurrentStatus()
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        Self.eventSink = nil
        return nil
    }

    private func sendCurrentStatus() {
        let status = NEVPNManager.shared().connection.status
        let value = Self.eventString(for: status)
        Self.eventSink?(value)
    }

    static func sendStatus(_ status: NEVPNStatus) {
        let value = eventString(for: status)
        NSLog("[Zenshield] VPN connection status changed: %@ -> sending to Flutter", value)
        eventSink?(value)
    }

    private static func eventString(for status: NEVPNStatus) -> String {
        switch status {
        case .invalid:
            return "Disconnected"
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting"
        case .connected:
            return "Connected"
        case .reasserting:
            return "Connecting"
        case .disconnecting:
            return "Disconnecting"
        @unknown default:
            return "Disconnected"
        }
    }
}
