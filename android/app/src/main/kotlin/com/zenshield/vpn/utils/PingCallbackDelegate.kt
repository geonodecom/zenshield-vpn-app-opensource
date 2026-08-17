import android.os.Handler
import android.os.Looper
import com.vpnapp.zenshield.libbox.PingResultCallback

class PingCallbackDelegate(
    private val emitter: (String?) -> Unit
) : PingResultCallback {

    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onResult(result: String?) {
        mainHandler.post {
            emitter(result)
        }
    }
}