package mk.webfactory.flutter_template.platform_comm

import com.google.gson.Gson
import mk.webfactory.flutter_template.BuildConfig
import mk.webfactory.flutter_template.model.TaskGroup

const val nativeLogs = "nativeLogs"
const val platformTestMethod = "platformTestMethod"
const val platformTestMethod2 = "platformTestMethod2"

/**
 * Convenience app platform methods for communication w/ the flutter code.
 */
object Platform {
    private val jsonConverter: Gson = Gson()

    // Each time the flutter engine is configured this instance will be renewed
    var platformComm: PlatformComm? = null
        set(value) {
            field = value
            if (value != null) {
                initPlatformComm(value)
            }
        }

    private fun initPlatformComm(platformComm: PlatformComm) {
        if (BuildConfig.DEBUG) {
            // For testing only.
            platformComm.listenMethod<String>(platformTestMethod, fun(echoMessage) = echoMessage)
            platformComm.listenMethod<TaskGroup>(
                method = platformTestMethod2,
                callback = fun(echoObject) = jsonConverter.toJson(echoObject),
                deserializeParams = fun(resultJson) =
                    jsonConverter.fromJson(resultJson as String, TaskGroup::class.java))
        }
    }

    fun log(message: String) {
        platformComm?.invokeProcedure(nativeLogs, message)
    }
}