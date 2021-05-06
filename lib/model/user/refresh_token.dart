import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token.g.dart';

@JsonSerializable()
@immutable
class RefreshToken extends Equatable {
  final String token;
  final int expiresAt;

  RefreshToken(this.token, this.expiresAt);

  factory RefreshToken.fromJson(Map<String, dynamic> map) =>
      _$RefreshTokenFromJson(map);

  Map<String, dynamic> toJson() => _$RefreshTokenToJson(this);

  @override
  String toString() {
    return 'RefreshToken{token: $token, expiresAt: $expiresAt}';
  }

  @override
  List<Object?> get props => [token, expiresAt];
}
