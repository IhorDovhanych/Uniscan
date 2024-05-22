extension StringX on String {
  bool containsWithLowerCase(final String value) => toLowerCase().contains(value.toLowerCase());

  bool equalsWithLowerCase(final String value) => toLowerCase() == value.toLowerCase();

  bool startsWithLowerCase(final String value) => toLowerCase().startsWith(value.toLowerCase());

  String toSentenceCase() => isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : this;

  String toCamelCase() => split(' ').map((final e) => e.toSentenceCase()).join(' ');

  String? get notEmptyValueOrNull => isNotEmpty ? this : null;
}

extension StringNullX on String? {
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
