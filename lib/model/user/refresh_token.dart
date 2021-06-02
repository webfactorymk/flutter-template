import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/util/string_util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token.g.dart';

@JsonSerializable()
@immutable
class RefreshToken extends Equatable {
  final String token;
  final int expiresAt;

  @JsonKey(ignore: true)
  final String _displayToken;

  RefreshToken(this.token, this.expiresAt)
      : _displayToken = token.shortenForPrint();

  factory RefreshToken.fromJson(Map<String, dynamic> map) =>
      _$RefreshTokenFromJson(map);

  Map<String, dynamic> toJson() => _$RefreshTokenToJson(this);

  @override
  String toString() {
    return 'RefreshToken{token: $_displayToken, expiresAt: $expiresAt}';
  }

  @override
  List<Object?> get props => [token, expiresAt];
}
