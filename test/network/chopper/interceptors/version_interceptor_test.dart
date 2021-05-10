import 'package:chopper/chopper.dart';
import 'package:flutter_template/network/chopper/interceptors/version_interceptor.dart';
import 'package:flutter_template/network/util/http_util.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info/package_info.dart';

import '../../network_test_helper.dart';
import 'version_interceptor_test.mocks.dart';

@GenerateMocks([PackageInfo])
void main() {
  late VersionInterceptor versionInterceptor;

  group('onRequest', () {
    test('onRequest, no packageInfo', () async {
      // assert
      versionInterceptor = VersionInterceptor();
      Request expected = Request('GET', 'task/2', 'http://example.com',
          headers: {authHeaderKey: 'Bearer ' + NetworkTestHelper.validToken});

      // act
      Request actual = await versionInterceptor.onRequest(expected);

      // assert
      expect(actual, equals(expected));
      expect(actual.headers[versionHeaderKey], null);
    });

    test('onRequest, no locale stored', () async {
      // assert
      MockPackageInfo mockPackageInfo = MockPackageInfo();
      versionInterceptor = VersionInterceptor(mockPackageInfo);
      when(mockPackageInfo.version).thenReturn('1-2');
      Request expected = Request('GET', 'task/2', 'http://example.com',
          headers: {authHeaderKey: 'Bearer ' + NetworkTestHelper.validToken});

      // act
      Request actual = await versionInterceptor.onRequest(expected);

      // assert
      expect(actual, isNot(equals(expected)));
      expect(actual.headers[versionHeaderKey], '1');
    });
  });
}
