package mk.webfactory.flutter_template.platform_comm

import com.google.gson.Gson

const val nativeLogs = "nativeLogs"
const val platformTestMethod = "platformTestMethod"

/**
 * Convenience app platform methods for communication w/ the flutter code.
 */
object Platform {

    var platformComm: PlatformComm? = null
    
    private val jsonConverter: Gson = Gson()
    
    fun log(message: String) {
        platformComm?.invokeProcedure(nativeLogs, message)
    }
    
//    // Listens for custom log messages from the platform side.
//    Subscription listenToNativeLogs() => this.listenMethod<String>(
//    method: nativeLogs, callback: (logMessage) => Logger.d(logMessage));
//
//    // For testing only.
//    Future<String> echoMessage(String echoMessage) =>
//    this.invokeMethod(method: platformTestMethod, param: echoMessage);
}