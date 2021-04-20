import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/http/interceptors/request/request_interceptor.dart';
import 'package:flutter_template/network/network_util.dart';
import 'package:http/http.dart';
import 'package:single_item_storage/storage.dart';

/// [RequestInterceptor] that adds the jwt token header on each request.
///
/// Mind to update the token value when it changes or expires.
/// Setting it to `null` disables this interceptor.
class RequestInterceptorJwt implements RequestInterceptor {
  final Storage<UserCredentials> userStore;

  RequestInterceptorJwt(this.userStore);

  @override
  Future<void> intercept(BaseRequest baseRequest) async {
    String? token = (await userStore.get())?.credentials?.token;
    if (token != null) {
      baseRequest.headers
          .putIfAbsent(authHeaderKey, () => authHeaderValue(token));
    }
  }
}
