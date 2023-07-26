import 'package:flutter/services.dart';

class TestMethodChannel implements MethodChannel {
  Future Function(MethodCall call)? handler;

  TestMethodChannel(String name);

  @override
  void setMethodCallHandler(Future Function(MethodCall call)? handler) {
    this.handler = handler;
  }

  @override
  BinaryMessenger get binaryMessenger => throw UnimplementedError();

  @override
  MethodCodec get codec => throw UnimplementedError();

  @override
  Future<List<T>?> invokeListMethod<T>(String method, [arguments]) {
    throw UnimplementedError();
  }

  @override
  Future<Map<K, V>?> invokeMapMethod<K, V>(String method, [arguments]) {
    throw UnimplementedError();
  }

  @override
  Future<T?> invokeMethod<T>(String method, [arguments]) {
    throw UnimplementedError();
  }

  @override
  String get name => throw UnimplementedError();
}
