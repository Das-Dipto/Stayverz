import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<XFile?> compressImage(XFile xFile) async {
  try {
    final file = File(xFile.path);

    // Check if file exists
    if (!await file.exists()) {
      return null;
    }

    // Get file size before compression
    final originalSize = await file.length();

    // Create a temp directory for compressed images
    final tempDir = await getTemporaryDirectory();
    final fileName = path.basenameWithoutExtension(xFile.path);
    final targetPath = path.join(
      tempDir.path,
      '${fileName}_compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    int quality = 90;
    XFile? compressedFile;

    do {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        format: CompressFormat.jpeg,
        minWidth: 1080,
        minHeight: 1080,
        keepExif: false,
      );

      if (result == null) {
        break;
      }

      compressedFile = result;
      final compressedSize = await File(result.path).length();
      final sizeInKB = compressedSize / 1024;


      // Target is 500 KB
      if (sizeInKB <= 220) {
        break;
      }

      // Reduce quality for next iteration
      quality -= 10;

      // Stop if quality is too low
      if (quality < 20) {
        break;
      }

      // Delete the previous attempt to save space
      if (await File(targetPath).exists()) {
        await File(targetPath).delete();
      }

    } while (quality >= 20);

    return compressedFile;

  } catch (e) {
    return null;
  }
}

// Hello I am Tamim