import 'package:flutter/services.dart';

class TestMethodChannel implements MethodChannel {
  Future Function(MethodCall call)? handler;

  TestMethodChannel(String name);

  @override
  void setMethodCallHandler(Future Function(MethodCall call)? handler) {
    this.handler = handler;
  }

  @override
  // TODO: implement binaryMessenger
  BinaryMessenger get binaryMessenger => throw UnimplementedError();

  @override
  bool checkMethodCallHandler(Future Function(MethodCall call)? handler) {
    // TODO: implement checkMethodCallHandler
    throw UnimplementedError();
  }

  @override
  bool checkMockMethodCallHandler(Future Function(MethodCall call)? handler) {
    // TODO: implement checkMockMethodCallHandler
    throw UnimplementedError();
  }

  @override
  // TODO: implement codec
  MethodCodec get codec => throw UnimplementedError();

  @override
  Future<List<T>?> invokeListMethod<T>(String method, [arguments]) {
    // TODO: implement invokeListMethod
    throw UnimplementedError();
  }

  @override
  Future<Map<K, V>?> invokeMapMethod<K, V>(String method, [arguments]) {
    // TODO: implement invokeMapMethod
    throw UnimplementedError();
  }

  @override
  Future<T?> invokeMethod<T>(String method, [arguments]) {
    // TODO: implement invokeMethod
    throw UnimplementedError();
  }

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  void setMockMethodCallHandler(Future? Function(MethodCall call)? handler) {
    // TODO: implement setMockMethodCallHandler
  }
}
