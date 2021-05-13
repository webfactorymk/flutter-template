import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/network/chopper/generated/chopper_user_api_service.dart';
import 'package:flutter_template/network/chopper/converters/response_to_type_converter.dart';

/// User api service.
///
/// To obtain an instance use `serviceLocator.get<UserApiService>()`
class UserApiService {
  final ChopperUserApiService _chopper;

  UserApiService(this._chopper);

  /// Registers a user
  Future<void> signUp(User user) => _chopper.signUp(user).toType();

  /// Gets the logged in user
  Future<Credentials> login(String username, String password) =>
      _chopper.login(username, password).toType();

  /// Returns user profile details
  Future<User> getUserProfile({String? authHeader}) =>
      _chopper.getUserProfile(authHeader: authHeader).toType();

  /// Updates user profile details
  Future<User> updateUserProfile(User user) =>
      _chopper.updateUserProfile(user).toType();

  /// Sends a request for resetting the user's password
  Future<void> resetPassword(String email) =>
      _chopper.resetPassword(email).toType();

  /// Adds token needed for logged in user to receive push notifications
  Future<void> addNotificationsToken(String token) =>
      _chopper.addNotificationsToken(token).toType();

  /// Logs out the user from server
  Future<void> logout() => _chopper.logout().toType();

  /// Deactivates the user
  Future<void> deactivate() => _chopper.deactivate().toType();
}
