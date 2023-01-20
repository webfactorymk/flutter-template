import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AppNavState extends Equatable {
  const AppNavState._();

  const factory AppNavState.auth() = AuthNavState;

  const factory AppNavState.home() = HomeNavState;

  const factory AppNavState.forceUpdate() = ForceUpdateNavState;

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return this.runtimeType.toString();
  }
}

@immutable
class AuthNavState extends AppNavState {
  const AuthNavState() : super._();
}

@immutable
class HomeNavState extends AppNavState {
  const HomeNavState() : super._();
}

@immutable
class ForceUpdateNavState extends AppNavState {
  const ForceUpdateNavState() : super._();
}
