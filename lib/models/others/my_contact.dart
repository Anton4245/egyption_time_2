import 'dart:typed_data';

class MyContact {
  /// The unique identifier of the contact.
  String id;

  /// The contact display name.
  String displayName;

  /// Returns the full-resolution photo if available, the thumbnail otherwise.
  Uint8List? photoOrThumbnail;

  /// Structured name.
  String name;

  /// Phone numbers.
  List<String> phones;

  MyContact({
    required this.id,
    this.displayName = '',
    String? name,
    List<String>? phones,
  })  : name = name ?? '',
        phones = phones ?? <String>[];

  phonesToString() {
    return phones.fold<String>(
        '',
        (previousValue, element) =>
            previousValue + (previousValue.isNotEmpty ? ', ' : '') + element);
  }
}
