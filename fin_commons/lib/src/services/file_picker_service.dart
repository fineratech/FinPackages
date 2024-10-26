import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerService {
  File? selectedImage;
  static final _imagePicker = ImagePicker();

  static Future<File?> pickImage() async {
    return await pickImageWithoutCompression();
  }

  ///picks an image from gallery and returns a compressed [File]
  static Future<File?> pickImageWithCompression({int imageQuality = 50}) async {
    File? selectedImage;
    final image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: imageQuality);
    if (image != null) selectedImage = File(image.path);

    return selectedImage;
  }

  ///picks an image from gallery and returns a [File] without compression
  static Future<File?> pickImageWithoutCompression() async {
    File? selectedImage;
    final filePicker = FilePicker.platform;
    FilePickerResult? result = await filePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      selectedImage = File(result.paths.first!);

      // if (extension == '.heic') {
      //   String? jpegPath = await HeicToJpg.convert(selectedImage.path);
      //   if (jpegPath != null) selectedImage = File(jpegPath);
      // }
    }
    return selectedImage;
  }

  // Private method
  static Future<File?> _pickImageAndCrop(
      {required Future<File?> Function(File file)? cropImage}) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    if (cropImage == null) {
      return File(pickedFile.path);
    } else {
      final file = File(pickedFile.path);
      return cropImage(file);
    }
  }

  /// Picks an image from gallery and returns a [File] after cropping.
  /// [isCircle] is used to crop the image in circle shape.
  /// [height] is the height os the cropping area.
  /// Add the following to AndroidManifest.xml:
  /// <activity
  ///  android:name="com.yalantis.ucrop.UCropActivity"
  ///  android:screenOrientation="portrait"
  ///  android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
  static Future<File?> selectAndCropImage(
      {bool isCircle = true, double height = 1.4}) async {
    File? file = await _pickImageAndCrop(cropImage: (File ss) {
      return _onShowcaseImageCrop(ss, isCircle, height);
    });

    return file;
  }

  // Private method
  static Future<File?> _onShowcaseImageCrop(
      File file, bool isCircle, double height) async {
    var croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      // cropStyle: isCircle ? CropStyle.circle : CropStyle.rectangle,
      compressQuality: 15,
      //aspectRatio: CropAspectRatio(ratioX: 2, ratioY: isCircle ? 2 : height),
      //aspectRatioPresets: [CropAspectRatioPreset.original],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedImage != null) {
      return File(croppedImage.path);
    } else {
      return null;
    }
  }

  /// Generates a thumbnail from the given [videoPath] and returns a [File]
  // static Future<File> generateThumbnail(String videoPath) async {
  //   var tempPath = (await getTemporaryDirectory()).path;
  //   final thumbnailPath = await VideoThumbnail.thumbnailFile(
  //     video: videoPath,
  //     thumbnailPath: tempPath,
  //     imageFormat: ImageFormat.JPEG,
  //     maxHeight: 200,
  //     quality: 75,
  //   );
  //   return File(thumbnailPath!);
  // }

  static Future<File?> pickFile({
    FileType? fileType,
    List<String>? allowedExtensions,
  }) async {
    File? selectedFile;
    final filePicker = FilePicker.platform;
    FilePickerResult? result = await filePicker.pickFiles(
      type: fileType ?? FileType.any,
      allowedExtensions: allowedExtensions,
      allowMultiple: false,
    );

    if (result != null) {
      selectedFile = File(result.paths.first!);
    }
    return selectedFile;
  }
}
