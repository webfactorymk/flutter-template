package mk.webfactory.flutter_template.platform_comm

import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/** A call that's received from the flutter side. */
typealias Callback<P> = (P) -> Any?

/** A call without params that's received from the flutter side. */
typealias CallbackNoParams = () -> Any?

/** Internal. A call with raw unconverted params. */
typealias CallbackRaw = (Any?) -> Any?

/** Serializes in item */
typealias Serialize<E> = (E) -> Any?

/** Deserializes in item */
typealias Deserialize<E> = (Any?) -> E

const val methodChannelGeneral = "com.my-app.package-name.general" //todo match with flutter side

/**
 *  Global platform communication for app actions that don't require a plugin.
 *
 *  Note: Needs to be singleton otherwise it will overwrite the [MethodChannel].
 *
 *  Get a configured instance from: [Platform.platformComm] or use [Platform] directly.
 */
class PlatformComm(private val methodChannel: MethodChannel) {

    private val flutterCallbackMap: MutableMap<String, CallbackRaw> = mutableMapOf()

    companion object {
        @JvmStatic
        fun configure(flutterEngine: FlutterEngine): PlatformComm {
            Platform.platformComm?.let {
                Log.d("PlatformComm (native)", "Already configured - configuring again")
                Platform.log("PlatformComm: Already configured - configuring again")
                it.teardown()
            }
            Log.d("PlatformComm (native)", "Configuring...")
            val methodChannel = MethodChannel(flutterEngine.dartExecutor, methodChannelGeneral)
            val platformComm = PlatformComm(methodChannel)
            Platform.platformComm = platformComm
            return platformComm
        }
    }

    init {
        methodChannel.setMethodCallHandler { call, result ->
            Log.d("PlatformComm (native)", "Method call: ${call.method} /w args: ${call.arguments}")

            val callback: CallbackRaw? = flutterCallbackMap[call.method]
            if (callback != null) {
                val response: Any?
                try {
                    response = callback(call.arguments)
                } catch (exp: Exception) {
                    result.error(call.method, "Error executing method call ${call.method}", exp)
                    return@setMethodCallHandler
                }
                if (response is Unit) {
                    result.success("")
                } else {
                    result.success(response)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    /**
     * Invokes a flutter method with or without parameters and expects a result.
     *
     * Use [serializeParam] to convert your [param] to serializable data
     * that can be sent through a [MethodChannel.invokeMethod] like JSON
     * string for example.
     *
     * The same goes for [deserializeResult]. Provide the conversion from
     * raw dynamic data returned from the flutter method to your type [R].
     *
     * See [MethodChannel.invokeMethod].
     */
    fun <R, P> invokeMethod(
        method: String,
        param: P? = null,
        serializeParam: Serialize<P>? = null,
        deserializeResult: Deserialize<R>? = null,
        resultCallback: ResultCallback<R>,
    ) {
        methodChannel.invokeMethod(
            method,
            if (param != null) (serializeParam?.invoke(param) ?: param) else null,
            object : MethodChannel.Result {
                override fun success(result: Any?) {
                    try {
                        @Suppress("UNCHECKED_CAST")
                        resultCallback.success(
                            deserializeResult?.invoke(result)
                                ?: result as R
                        )
                    } catch (exp: Exception) {
                        resultCallback.error("Could not deserialize result of method $method", exp)
                    }
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) =
                    resultCallback.error(errorMessage, errorDetails)

                override fun notImplemented() = resultCallback.notImplemented()
            }
        )
    }

    /** Like invoke method, but it doesn't expect a result. */
    fun <P> invokeProcedure(
        method: String,
        param: P? = null,
        serializeParam: Serialize<P>? = null,
    ) {
        methodChannel.invokeMethod(
            method,
            if (param != null) (serializeParam?.invoke(param) ?: param) else null
        )
    }

    /**
     * Listens for the specified [method] to be invoked on the flutter side
     * overwriting any previously registered listeners.
     *
     * Provide [callback] to be invoked from the flutter side
     * with param [P] and provide [deserializeParams] for converting
     * the raw `Any?` params to [P]. If [deserializeParams] is
     * not provided the raw params are cast to [P].
     *
     * The result from the [callback] is returned to the invoking
     * component on the platform side.
     */
    fun <P> listenMethod(
        method: String,
        callback: Callback<P>,
        deserializeParams: Deserialize<P>? = null,
    ): Subscription {
        flutterCallbackMap[method] =
            @Suppress("UNCHECKED_CAST")
            fun(paramsRaw) = callback(deserializeParams?.invoke(paramsRaw) ?: paramsRaw as P)

        return Subscription(cancel = fun() { flutterCallbackMap.remove(method) })
    }

    /** Like [listenMethod] but without params. */
    fun listenMethodNoParams(
        method: String,
        callback: CallbackNoParams,
    ): Subscription {
        flutterCallbackMap[method] = fun(_) = callback()
        return Subscription(cancel = fun() { flutterCallbackMap.remove(method) })
    }

    fun teardown() {
        methodChannel.setMethodCallHandler(null)
    }
}
