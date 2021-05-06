import 'package:chopper/chopper.dart';
import 'package:flutter_template/network/util/http_util.dart';
import 'package:package_info/package_info.dart';

/// [RequestInterceptor] that adds the supported app version header on each request.
class VersionInterceptor implements RequestInterceptor {
  final PackageInfo? _packageInfo;

  VersionInterceptor([this._packageInfo]);

  @override
  Future<Request> onRequest(Request request) async {
    if (_packageInfo != null) {
      return applyHeader(
        request,
        versionHeaderKey,
        headerAppVersionValue(_packageInfo!),
      );
    } else {
      return request;
    }
  }
}
