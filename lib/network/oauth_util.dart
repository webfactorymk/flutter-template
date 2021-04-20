import 'dart:io';

const String oauth2HeaderKey = HttpHeaders.authorizationHeader;
const String oauth2Prefix = "Bearer ";

String createOAuthHeaderValue(String token) {
  if (token == null) {
    throw ArgumentError("token must not be null");
  }
  return oauth2Prefix + token;
}
