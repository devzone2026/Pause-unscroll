
import 'dart:convert';
import 'dart:io';

class Validations {

  static bool isEmailValid(String email) {
    // Regular expression for email validation
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  static bool isPhoneNumberValid(String phoneNumber) {
    // Regular expression for phone number validation
    final phoneRegex = RegExp(r'^(?:[+0]9)?[0-9]{10,12}$');
    return phoneRegex.hasMatch(phoneNumber);
  }
}

extension FileTypeDetector on File {
  Future<bool> get isSvg async {
    final bytes = await readAsBytes();

    const pngMagic = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    if (bytes.length >= 8 &&
        List.generate(8, (i) => bytes[i] == pngMagic[i]).every((m) => m)) {
      return false;
    }

    final preview = utf8.decode(
      bytes.sublist(0, bytes.length.clamp(0, 512)),
      allowMalformed: true,
    );
    final trimmed = preview.trimLeft();

    if (trimmed.startsWith('<?xml') || trimmed.contains('<svg')) {
      return true;
    }

    throw ArgumentError('File is neither PNG nor SVG: $path');
  }
}