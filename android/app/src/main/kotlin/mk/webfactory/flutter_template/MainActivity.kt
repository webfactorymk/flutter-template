package mk.webfactory.flutter_template

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import mk.webfactory.flutter_template.platform_comm.Platform
import mk.webfactory.flutter_template.platform_comm.PlatformComm

const val MAIN_ENGINE_CACHE_ID = "main_engine_cache"

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        if (BuildConfig.USE_CACHED_FLUTTER_ENGINE) {
            FlutterEngineCache.getInstance().put(MAIN_ENGINE_CACHE_ID, flutterEngine)
        }
        PlatformComm.configure(flutterEngine)
                .run { Platform.log("MainActivity: configureFlutterEngine") }
    }

    override fun shouldDestroyEngineWithHost(): Boolean = !BuildConfig.USE_CACHED_FLUTTER_ENGINE

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return if (BuildConfig.USE_CACHED_FLUTTER_ENGINE)
            FlutterEngineCache.getInstance().get(MAIN_ENGINE_CACHE_ID) else null
    }
}
