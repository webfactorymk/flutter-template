import 'package:flutter_template/notifications/data/message.dart';
import 'package:flutter_template/notifications/data/message_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'notification_multi_parser_test.mocks.dart';

class TestMultiMessageParser extends MultiMessageParser {
  @override
  String getTypeFromRawMessage(remoteData) => remoteData;
}

@GenerateMocks([MessageParser])
void main() {
  late MultiMessageParser parser;

  setUp(() {
    parser = TestMultiMessageParser();
  });

  test('No parser for message', () {
    expect(() => parser.parseMessage('unknown'), throwsA(isA<Exception>()));
  });

  test('Multiple parsers for message types', () {
    MockMessageParser parserA = MockMessageParser();
    MockMessageParser parserB = MockMessageParser();
    MockMessageParser parserCD = MockMessageParser();

    when(parserA.parseMessage('A')).thenReturn(Message('A'));
    when(parserB.parseMessage('B')).thenReturn(Message('B'));
    when(parserCD.parseMessage('C')).thenReturn(Message('C'));
    when(parserCD.parseMessage('D')).thenReturn(Message('D'));

    parser
      ..registerMessageParser(parser: parserA, forMessageTypes: ['A'])
      ..registerMessageParser(parser: parserB, forMessageTypes: ['B'])
      ..registerMessageParser(parser: parserCD, forMessageTypes: ['C', 'D']);

    parser.parseMessage('A');
    parser.parseMessage('B');
    parser.parseMessage('C');
    parser.parseMessage('D');

    verifyInOrder([
      parserA.parseMessage('A'),
      parserB.parseMessage('B'),
      parserCD.parseMessage('C'),
      parserCD.parseMessage('D'),
    ]);
  });
}
