// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../utilities/colors.dart';

const parentDirectory = "0_konvege";
const mediaDirectory = "media";
const videoDirectory = "$parentDirectory/$mediaDirectory/videos";
const imageDirectory = "$parentDirectory/$mediaDirectory/image";
const uploadImageDirectory = "$imageDirectory/upload";

///this function upload file to firebase storage along with specified path
// Future<String?> uploadFileToFirebaseStorage({
//   required String storagePath,
//   required String filePath,
// }) async {
//   try {
//     final storageReference = FirebaseStorage.instance.ref().child(storagePath);
//     UploadTask uploadTask = storageReference.putFile(File(filePath));
//     await uploadTask.whenComplete(() => null);
//     String url = await storageReference.getDownloadURL();
//     print(url);
//     return url;
//   } catch (ex) {
//     print('fireStorage_upload_exception ${ex.toString()}');
//     return null;
//   }
// }

///this function will fetch image from Gallery or Camera
Future<String?> imagePicker({required ImageSource imageSource}) async {
  try {
    XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);
    print(pickedFile);
    if (pickedFile != null) {
      return pickedFile.path;
    }
    return null;
  } catch (e) {
    print("exception_pickUserProfileImage : $e");
    return null;
  }
}

///image cropper function
Future<CroppedFile?> imageCropper(
  BuildContext context, {
  required String filePath,
}) async {
  CroppedFile? croppedImage = await ImageCropper().cropImage(
    sourcePath: filePath,
    cropStyle: CropStyle.circle,
    aspectRatioPresets: Platform.isAndroid
        ? [CropAspectRatioPreset.square]
        : [CropAspectRatioPreset.square],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Image Cropper',
        toolbarColor: AppColors.kPrimaryColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
        title: 'Image Cropper',
      )
    ],
  );
  return croppedImage;
}

//function to get the directory path for saving image
Future<String> getMediaImageDirectoryPath() async {
  var pathInfo = await getApplicationDocumentsDirectory();
  final path = "${pathInfo.path}/$parentDirectory/$mediaDirectory";
  final directory = await Directory(path).create(recursive: true);
  // final isPathExists =
  await directory.exists();
  return directory.path;
}

//function to get the directory path for saving image @author:Jithin Gopal:21-Jun-2021
Future<String> getUploadMediaImageDirectoryPath() async {
  var pathInfo = await getApplicationDocumentsDirectory();
  final path = "${pathInfo.path}/$parentDirectory/$mediaDirectory";
  final directory = await Directory(path).create(recursive: true);
  // final isPathExists =
  await directory.exists();
  return directory.path;
}

Future<String> downloadFile(
  Dio dio,
  String url,
  String saveFilePath,
  Function progressCallBack,
) async {
  try {
    Response response = await dio.get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    File file = File(saveFilePath);
    var ref = file.openSync(mode: FileMode.write);
    ref.writeFromSync(response.data as List<int>);
    await ref.close();
    return saveFilePath;
  } on Exception catch (e) {
    print("error :$e");
    return "";
  }
}

double getFileSizeInMB(String filePath) {
  return File(filePath).lengthSync() / (1024 * 1024);
}
