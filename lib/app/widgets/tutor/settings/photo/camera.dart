import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_selector/file_selector.dart';

class CameraServices {
  static final picker = ImagePicker();

  static Future<void> showImagePicker(
      BuildContext context, Function(File) onImageSelected) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) ...[
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Tomar foto'),
                  onTap: () {
                    _getImageFromCamera(context, onImageSelected);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Seleccionar de la galería'),
                  onTap: () {
                    _getImageFromGallery(context, onImageSelected);
                    Navigator.pop(context);
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Seleccionar archivo'),
                  onTap: () {
                    _getFile(context, onImageSelected);
                    Navigator.pop(context);
                  },
                ),
              ]
            ],
          ),
        );
      },
    );
  }

  static Future<void> _getImageFromCamera(
      BuildContext context, Function(File) onImageSelected) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      onImageSelected(File(pickedFile.path));
    }
  }

  static Future<void> _getImageFromGallery(
      BuildContext context, Function(File) onImageSelected) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      onImageSelected(File(pickedFile.path));
    }
  }

  static Future<void> _getFile(
      BuildContext context, Function(File) onFileSelected) async {
    final XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: ['jpg', 'png', 'gif', 'bmp', 'jpeg'],
    );
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file != null) {
      onFileSelected(File(file.path));
    }
  }
}
