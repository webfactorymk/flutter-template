import 'package:connectivity/connectivity.dart';
import 'package:flutter_template/network/util/network_utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'network_utils_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  late MockConnectivity mockConnectivity;
  late NetworkUtils networkUtils;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkUtils = NetworkUtils(mockConnectivity);
  });

  test('isConnected, called once', () async {
    // arrange
    final connectivityResult = Future.value(ConnectivityResult.mobile);
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => connectivityResult);
    // act
    final actualStatus = await networkUtils.isConnected();

    // assert
    verify(mockConnectivity.checkConnectivity()).called(1);
    expect(actualStatus, true);
  });
}
