import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:http/http.dart';

/// Abstraction over the communication with a remote server.
abstract class ApiService {
  /* USER PROFILE AND AUTHENTICATION */

  /// Registers a user
  Future<void> signUp(User user);

  /// Gets the logged in user.
  Future<Credentials> login(String username, String password);

  /// Logs out the user from server.
  Future<Response> logout();

  /// Deactivates the user
  Future<void> deactivate();

  /// Sends a request for resetting the user's password
  Future<Response> resetPassword(String email);

  /// Returns user profile details
  Future<User> getUserProfile({String? token});

  /// Updates user profile details
  Future<Response> updateUserProfile(User user);

  /* PUSH NOTIFICATIONS */

  /// Adds token needed for logged in user to receive push notifications
  Future<void> addNotificationsToken(String token);
}
