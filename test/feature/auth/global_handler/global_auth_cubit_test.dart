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
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:single_item_storage/memory_storage.dart';
import 'package:single_item_storage/observed_storage.dart';

import '../../../network/network_test_helper.dart';
import 'global_auth_cubit_test.mocks.dart';

final user = User(id: "id", email: "email");

/// Bloc tests for [GlobalAuthCubit]
@GenerateMocks([UserApiService])
void main() {
  late UserManager userManager;
  late UserApiService apiService;

  setUp(() {
    apiService = MockUserApiService();
    userManager = UserManager(apiService, ObservedStorage(MemoryStorage()));

    when(apiService.login('username', 'password')).thenAnswer((_) =>
        Future.value(
            Credentials(NetworkTestHelper.validToken, RefreshToken('rt', 0))));
    when(apiService.getUserProfile(authHeader: anyNamed('authHeader')))
        .thenAnswer((_) => Future.value(user));
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
