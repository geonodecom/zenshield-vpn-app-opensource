enum PaywallType {
  standard,
  connect,
}

extension PaywallTypeExtension on PaywallType {
  String get analyticsValue {
    switch (this) {
      case PaywallType.standard:
        return 'default';
      case PaywallType.connect:
        return 'connect';
    }
  }
}
