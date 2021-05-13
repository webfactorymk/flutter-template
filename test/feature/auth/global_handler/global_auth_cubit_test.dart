import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_cubit.dart';
import 'package:flutter_template/feature/auth/global_handler/global_auth_state.dart';
import 'package:flutter_template/model/user/credentials.dart';
import 'package:flutter_template/model/user/refresh_token.dart';
import 'package:flutter_template/model/user/user.dart';
import 'package:flutter_template/model/user/user_credentials.dart';
import 'package:flutter_template/network/user_api_service.dart';
import 'package:flutter_template/user/user_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:single_item_storage/memory_storage.dart';
import 'package:single_item_storage/observed_storage.dart';

class MockApiService extends Mock implements UserApiService {}

final user = User(id: "id", email: "email");

/// Bloc tests for [GlobalAuthCubit]
void main() {
  late UserManager userManager;
  late UserApiService apiService;

  setUp(() {
    apiService = MockApiService();
    userManager = UserManager(apiService, ObservedStorage(MemoryStorage()));

    when(apiService.login('username', 'password')).thenAnswer(
        (_) => Future.value(Credentials('token', RefreshToken('rt', 0))));
    when(apiService.getUserProfile()).thenAnswer((_) => Future.value(user));
    when(apiService.logout()).thenAnswer((_) => Future.value());
  });

  tearDown(() {
    userManager.teardown();
  });

  blocTest<GlobalAuthCubit, GlobalAuthState>(
    'Single event',
    build: () => GlobalAuthCubit(userManager),
    expect: () => [AuthenticationFailure()],
  );

  blocTest<GlobalAuthCubit, GlobalAuthState>(
    'Subsequent equal events',
    build: () => GlobalAuthCubit(userManager),
    act: (cubit) => cubit
      ..onUserAuthenticationUpdate(UserCredentials(user, null))
      ..onUserAuthenticationUpdate(UserCredentials(user, null)),
    expect: () => [
      AuthenticationFailure(),
    ],
  );

  blocTest<GlobalAuthCubit, GlobalAuthState>(
    'User manager updates trigger',
    build: () => GlobalAuthCubit(userManager),
    act: (bloc) => userManager.login('username', 'password'),
    expect: () => [
      AuthenticationFailure(),
      AuthenticationSuccess(),
    ],
  );
}
