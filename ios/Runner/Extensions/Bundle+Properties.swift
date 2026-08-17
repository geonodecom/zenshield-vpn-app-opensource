import Foundation

extension Bundle {
    var serviceIdentifier: String {
        (infoDictionary?["SERVICE_IDENTIFIER"] as? String)!
    }
    
    var baseBundleIdentifier: String {
        (infoDictionary?["BUNDLE_IDENTIFIER"] as? String)!
    }
    
    var tunnelBundleSuffix: String {
        (infoDictionary?["TUNNEL_BUNDLE_SUFFIX"] as? String)!
    }
}
