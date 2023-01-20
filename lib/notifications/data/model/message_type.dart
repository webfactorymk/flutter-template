/// Enumeration that determines type of the incoming remote message
enum MessageType {
  A,
  B,
  UNKNOWN
}

extension ParseMessageType on String {
  /// Concerts raw [String] to [MessageType].
  MessageType toMessageType() {
    switch (this) {
      case 'A':
        return MessageType.A;
      case 'B':
        return MessageType.B;
      default:
        return MessageType.UNKNOWN;
    }
  }
}

extension MessageDetails on MessageType {
  /// Returns the remote key for the [MessageType]
  String getKey() {
    switch (this) {
      case MessageType.A:
        return 'A';
      case MessageType.B:
        return 'B';
      case MessageType.UNKNOWN:
        return 'n/a';
    }
  }

  bool shouldShowAlert() {
    switch (this) {
      case MessageType.A:
        return true;
      case MessageType.B:
        return true;
      default:
        return false;
    }
  }
}
