import 'package:equatable/equatable.dart';
import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'user_credentials.g.dart';

/// Wrapper class for [User] with [Credentials].
@JsonSerializable()
class UserCredentials extends Equatable {
  final User user;
  final Credentials? credentials;

  UserCredentials(this.user, this.credentials);

  factory UserCredentials.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$UserCredentialsToJson(this);

  @override
  List<Object?> get props => [user, credentials];

  @override
  String toString() {
    return 'UserCredentials{'
        'user: $user, '
        'credentials: $credentials'
        '}';
  }
}

// Extension methods that we can safely use on a null instances.
// Example:
//     UserCredentials? instance = null;
//     // This is safe and will return false even though instance is `null`
//     instance.isLoggedIn();
extension NullSafeCalls on UserCredentials? {
  /// Checks if the user is logged in.
  ///
  /// Will return true if all of the following are true:
  /// - this instance is not null
  /// - user's credentials are not null
  /// - the token is not expired OR the refresh token is not expired
  bool isLoggedIn() =>
      this != null &&
      this!.credentials != null &&
      (!this!.credentials!.isTokenExpired() ||
          !this!.credentials!.isRefreshTokenExpired());
}
