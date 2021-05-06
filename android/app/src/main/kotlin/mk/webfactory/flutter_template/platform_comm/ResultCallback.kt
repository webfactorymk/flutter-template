package mk.webfactory.flutter_template.platform_comm

import androidx.annotation.UiThread

interface ResultCallback<R> {

    /** Handles a successful result. */
    @UiThread
    fun success(result: R)

    /**
     * Handles an error result.
     *
     * @param errorMessage A human-readable error message String, possibly null.
     * @param errorDetails Error details, possibly null.
     */
    @UiThread
    fun error(errorMessage: String?, errorDetails: Any?)

    /** Handles a call to an unimplemented method.  */
    @UiThread
    fun notImplemented()
}