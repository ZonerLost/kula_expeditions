import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum PermitDocumentType { passport, visa }

class PermitStorageService {
  PermitStorageService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadDocument({
    required PlatformFile file,
    required String permitId,
    required PermitDocumentType type,
  }) async {
    final Uint8List? bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      throw StateError('Selected file has no readable bytes.');
    }

    final extension = _extractExtension(file.name);
    final safePermitId = permitId.trim();
    if (safePermitId.isEmpty) {
      throw ArgumentError.value(permitId, 'permitId', 'must not be empty');
    }
    final fileName = '${type.name}${extension.isEmpty ? '' : '.$extension'}';
    final storagePath = 'permits/$safePermitId/${type.name}/$fileName';

    final reference = _storage.ref().child(storagePath);
    final metadata = SettableMetadata(
      contentType: _resolveMimeType(extension),
      customMetadata: <String, String>{
        'permitId': safePermitId,
        'documentType': type.name,
      },
    );

    await reference.putData(bytes, metadata);
    return reference.getDownloadURL();
  }

  String _extractExtension(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex <= 0 || dotIndex == fileName.length - 1) {
      return '';
    }
    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  String _resolveMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'application/octet-stream';
    }
  }
}
