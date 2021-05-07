import 'package:chopper/chopper.dart';
import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/refresh_token.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:http/http.dart' as http;

const String mockToken =
    "eyJhbGciOiJIUzI1NiJ9.eyJJc3N1ZXIiOiJJc3N1ZXIiLCJVc2VybmFtZSI6IkphdmFJblVzZSIsImV4cCI6MTcxNDIyMDYwMSwiaWF0IjoxNjE5NTI2MjAxfQ.yjTgXqiqGH3F-ycq2I3Ec-v3l0mzVV8Rg_RijsR50do";

@ChopperApi()
class MockUserApiService implements UserApiService {
  /// Registers a user
  @Post(path: '/user/register')
  Future<Response> signUp(@Body() User user) {
    return Future.value(Response(MockResponse(200), null));
  }

  /// Gets the logged in user
  @Post(path: '/user/login')
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<Response<Credentials>> login(
    @Field() String username,
    @Field() String password,
  ) {
    return Future.value(Response(
        MockResponse(200),
        Credentials(
            mockToken,
            RefreshToken(
                mockToken,
                DateTime.now()
                    .add(Duration(days: 1500))
                    .millisecondsSinceEpoch))));
  }

  @override
  Future<Response<User>> getUserProfile({String? authHeader}) {
    return Future.value(Response(
        MockResponse(200),
        User(
            id: "1",
            email: "user@email.com",
            firstName: "First",
            lastName: "Last",
            dateOfBirth: DateTime.now())));
  }

  @override
  late ChopperClient client;

  @override
  // TODO: implement definitionType
  Type get definitionType => throw UnimplementedError();

  @override
  Future<Response> addNotificationsToken(String token) {
    // TODO: implement addNotificationsToken
    throw UnimplementedError();
  }

  @override
  Future<Response<void>> deactivate() {
    // TODO: implement deactivate
    throw UnimplementedError();
  }

  @override
  Future<Response<void>> logout() {
    return Future.value(Response(MockResponse(200), null));
  }

  @override
  Future<Response<void>> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<Response<User>> updateUserProfile(User user) {
    // TODO: implement updateUserProfile
    throw UnimplementedError();
  }
}

class MockResponse extends http.BaseResponse {
  MockResponse(int statusCode) : super(statusCode);
}
