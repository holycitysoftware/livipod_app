class Country {
  final String name;
  final String dialCode;
  final String code;
  const Country({
    required this.name,
    required this.dialCode,
    required this.code,
  });

  @override
  bool operator ==(Object other) {
    return other is Country && other.code == code;
  }

  @override
  int get hashCode {
    return code.hashCode;
  }
}
