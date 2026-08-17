//
//  PacketTunnelProvider.swift
//  SystemTunnel
//

import NetworkExtension

@objc(PacketTunnelProvider)
class PacketTunnelProvider: ExtensionProvider {
    override func startTunnel(options: [String: NSObject]?) async throws {
        let keys = options.map { Array($0.keys).sorted().joined(separator: ", ") } ?? "nil"
        NSLog("[Zenshield] PacketTunnelProvider startTunnel options keys: %@", keys)
        try await super.startTunnel(options: options)
    }
}
