import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImageSource source;

  ImagePickerService({required ImageSource this.source});

  Future piclImage() async {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;

      final tempImage = File(image.path);
      return tempImage;
  }
}
