import Foundation
import ZenshieldBox


class PingCallBack: NSObject, LibboxPingResultCallbackProtocol {
    private let emitter: (String?) -> ()
    
    init(emitter: @escaping (String?) -> Void) {
        self.emitter = emitter
    }
    
    func onResult(_ result: String?) {
        DispatchQueue.main.async {
            self.emitter(result)
        }
    }
}
