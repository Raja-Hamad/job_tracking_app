import 'package:cloud_firestore/cloud_firestore.dart';

class ResumesModel {
  final String id;
  final String userId;
  final String downloadUrl;
  final String fileName;
  final Timestamp ? timestamp;
  ResumesModel({
    required this.downloadUrl,
    required this.fileName,
    required this.id,
     this.timestamp,
    required this.userId,
  });
  factory ResumesModel.fromMap(Map<String, dynamic> json) {
    final createdAt = json['timeStamp'];
    return ResumesModel(
      downloadUrl: json['downloadUrl'],
      fileName: json['fileName'],
      id: json['id'],
      timestamp: createdAt is Timestamp ? json['timestamp'] : null,
      userId: json['userId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'userId': userId,
      "fileName": fileName,
      "downloadUrl": downloadUrl,
      "timeStamp": FieldValue.serverTimestamp(),
    };
  }

  @override
  String toString() {
    return 'ResumesModel('
        'id:$id, '
        'userId:$userId, '
        'fileName:$fileName, '
        'downloadUrl:$downloadUrl, '
        'timeStamp:$timestamp, '
        ')';
  }
}
