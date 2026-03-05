// // ignore_for_file: strict_top_level_inference

// import 'package:image_picker/image_picker.dart';

// // for picking up image from gallery
// pickImage(ImageSource source) async {
//   final ImagePicker imagePicker = ImagePicker();
//   XFile? file = await imagePicker.pickImage(source: source);
//   if (file != null) {
//     return await file.readAsBytes();
//   }
// }

import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  final XFile? file = await imagePicker.pickImage(
    source: source,
    imageQuality: 70, // ✅ compress image (VERY IMPORTANT)
  );

  if (file != null) {
    return await file.readAsBytes();
  }

  return null;
}