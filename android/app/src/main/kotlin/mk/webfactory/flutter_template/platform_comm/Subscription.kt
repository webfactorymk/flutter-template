package mk.webfactory.flutter_template.platform_comm;

/**
 * Service subscription. Call [cancel] to unsubscribe.
 */
class Subscription(private var cancel: (() -> Unit)?) {

    /**
     * Cancels the subscription.
     *
     * Can be called once. Subsequent calls have no effect.
     */
    fun cancel() {
        cancel?.invoke()
        cancel = null
    }
}