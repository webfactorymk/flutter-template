import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
@immutable
class User extends Equatable {
  @JsonKey(name: 'uuid')
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;

  User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [id, email, firstName, lastName, dateOfBirth];

  @override
  String toString() {
    return 'User{'
        'id: $id, '
        'email: $email, '
        'firstName: $firstName, '
        'lastName: $lastName, '
        'dateOfBirth: $dateOfBirth'
        '}';
  }
}
