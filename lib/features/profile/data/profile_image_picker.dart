import 'package:image_picker/image_picker.dart';

import 'package:address/features/profile/domain/entities/selected_profile_image.dart';

class ProfileImagePicker {
  ProfileImagePicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  static const int maximumBytes = 2 * 1024 * 1024;
  static const Set<String> supportedMimeTypes = <String>{
    'image/jpeg',
    'image/png',
    'image/webp',
  };

  final ImagePicker _picker;

  Future<SelectedProfileImage?> pick(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 82,
      requestFullMetadata: false,
    );

    if (file == null) {
      return null;
    }

    final bytes = await file.readAsBytes();

    if (bytes.length > maximumBytes) {
      throw const ProfileImageTooLargeException();
    }

    final mimeType = _mimeType(file);

    if (!supportedMimeTypes.contains(mimeType)) {
      throw const UnsupportedProfileImageException();
    }

    return SelectedProfileImage(
      bytes: bytes,
      fileName: _normalizedFileName(file.name, mimeType),
      mimeType: mimeType,
    );
  }

  String _mimeType(XFile file) {
    final provided = file.mimeType?.trim().toLowerCase();

    if (provided != null && provided.isNotEmpty) {
      return provided == 'image/jpg' ? 'image/jpeg' : provided;
    }

    final lowerName = file.name.toLowerCase();

    if (lowerName.endsWith('.png')) {
      return 'image/png';
    }

    if (lowerName.endsWith('.webp')) {
      return 'image/webp';
    }

    if (lowerName.endsWith('.jpg') || lowerName.endsWith('.jpeg')) {
      return 'image/jpeg';
    }

    return 'application/octet-stream';
  }

  String _normalizedFileName(String rawName, String mimeType) {
    final normalized = rawName.trim();

    if (normalized.isNotEmpty && normalized.contains('.')) {
      return normalized;
    }

    final extension = switch (mimeType) {
      'image/png' => 'png',
      'image/webp' => 'webp',
      _ => 'jpg',
    };

    return 'address-profile.$extension';
  }
}
