/// A call that's received from the native/platform side.
typedef dynamic PlatformCallback<P>(P param);

/// A call without params that's received from the native/platform side.
typedef dynamic PlatformCallbackNoParams();

/// Internal. A platform call with raw unconverted params.
typedef dynamic PlatformCallbackRaw(dynamic param);
