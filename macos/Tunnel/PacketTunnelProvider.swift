import NetworkExtension

class PacketTunnelProvider: ExtensionProvider {
    override func startTunnel(options: [String : NSObject]?)
    async throws {
        try await super.startTunnel(options: options)
    }
}
