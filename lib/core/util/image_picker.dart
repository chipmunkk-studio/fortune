import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';


class FortuneImagePicker {
  static const String _tag = "[FortuneImagePicker]";
  static final FortuneImagePicker _instance = FortuneImagePicker._internal();

  // 프라이빗 생성자
  FortuneImagePicker._internal();

  // 싱글톤 인스턴스에 접근하기 위한 메소드
  static FortuneImagePicker get instance => _instance;

  // 이미지 가져오기
  void loadImagePicker(Function1 onLoad, {Function0? onError}) async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        String? path = await _cropImageAndGetFilePath(image.path);
        if (path != null) {
          onLoad(path);
        }
      } else {
        FortuneLogger.debug(tag: _tag, "프로필 이미지 불러오기 실패.");
      }
    } on PlatformException {
      PermissionStatus result;
      if (Platform.isAndroid) {
        result = await Permission.storage.request();
      } else {
        result = await Permission.photos.request();
      }
      if (!result.isGranted) {
        onError?.call();
      } else {
        loadImagePicker(onLoad, onError: onError);
      }
    }
  }

  // 이미지 자르기
  _cropImageAndGetFilePath(String imagePath) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imagePath,
      cropStyle: CropStyle.circle,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 10,
    );

    if (croppedImage != null) {
      String pathWithoutExtension = removeFileExtension(croppedImage.path);
      String targetPath = "$pathWithoutExtension.webp";
      XFile? compressedImage = await compressAndGetFile(
        File(croppedImage.path),
        targetPath,
      );

      return compressedImage?.path;
    }
    return null;
  }

  Future<XFile?> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      format: CompressFormat.webp,
      quality: 10, // 원하는 압축 품질로 조정
    );

    if (result != null) {
      return XFile(result.path);
    }

    return null;
  }

  String removeFileExtension(String path) {
    return path.replaceAllMapped(RegExp(r'\.[0-9a-z]+$', caseSensitive: false), (match) => '');
  }
}
