import 'package:equatable/equatable.dart';
import 'package:flutter_template/model/user/refresh_token.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'credentials.g.dart';

@JsonSerializable()
class Credentials extends Equatable {
  final String token;
  final RefreshToken refreshToken;

  Credentials(this.token, this.refreshToken);

  factory Credentials.fromJson(Map<String, dynamic> json) =>
      _$CredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$CredentialsToJson(this);

  @override
  List<Object?> get props => [token, refreshToken];

  bool isTokenExpired() => JwtDecoder.isExpired(token);

  bool isRefreshTokenExpired() =>
      refreshToken.expiresAt < DateTime.now().millisecondsSinceEpoch;

  @override
  String toString() {
    return 'Credentials{token: $token, refreshToken: $refreshToken}';
  }
}
