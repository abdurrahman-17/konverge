class UploadImageModel {
  final String imagePath;
  final bool uploadStatus;
  final String uploadMessage;

  UploadImageModel(
    this.imagePath,
    this.uploadStatus,
    this.uploadMessage,
  );

  UploadImageModel.fromJson(Map<String, dynamic> json)
      : imagePath = json['imagePath'].toString(),
        uploadStatus = json['uploadStatus'] as bool,
        uploadMessage = json['uploadMessage'].toString();

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'uploadStatus': uploadStatus,
        'uploadMessage': uploadMessage,
      };
}
