import 'package:equatable/equatable.dart';

/// Push notification base message. Extend to add more data.
class Message extends Equatable {
  final String type;

  Message(this.type);

  @override
  List<Object?> get props => [type];

  @override
  String toString() {
    return 'Message{type: $type}';
  }
}
