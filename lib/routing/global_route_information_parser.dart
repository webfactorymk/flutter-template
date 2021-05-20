import 'package:flutter/cupertino.dart';
import 'package:flutter_template/routing/app_route_path.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    return LoginPath();
  }
}
