import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/model/user/refresh_token.dart';
import 'package:flutter_template/util/string_util.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'credentials.g.dart';

@JsonSerializable()
@immutable
class Credentials extends Equatable {
  final String token;
  final RefreshToken refreshToken;

  @JsonKey(ignore: true)
  final String _displayToken;

  Credentials(this.token, this.refreshToken)
      : _displayToken = token.shortenForPrint();

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
    return 'Credentials{token: $_displayToken, refreshToken: $refreshToken}';
  }
}
