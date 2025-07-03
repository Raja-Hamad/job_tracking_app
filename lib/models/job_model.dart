import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String userId;
  final String userDeviceToken;
  final String id;
  final String jobTitle;
  final String companyName;
  final Timestamp? createdAt;
  final String applicationDate;
  final String applicationStatus;
  final String interviewDate;
  final String notes;

  JobModel({
    required this.applicationDate,
    required this.applicationStatus,
    required this.companyName,
     this.createdAt,
    required this.id,
    required this.interviewDate,
    required this.jobTitle,
    required this.notes,
    required this.userDeviceToken,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "userDeviceToken": userDeviceToken,
      "jobTitle": jobTitle,
      "companyName": companyName,
      "createdAt": FieldValue.serverTimestamp(),
      'applicationDate': applicationDate,
      "applicationStatus": applicationStatus,
      "interviewDate": interviewDate,
      "notes": notes,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> json) {
    final createdAt1 = json['createdAt'];
    return JobModel(
      applicationDate: json['applicationDate'],
      applicationStatus: json['applicationStatus'],
      companyName: json['companyName'],
      createdAt: createdAt1 is Timestamp ? json['createdAt'] : null,
      id: json['id'],
      interviewDate: json['interviewDate'],
      jobTitle: json['jobTitle'],
      notes: json['notes'],
      userDeviceToken: json["userDeviceToken"],
      userId: json['userId'],
    );
  }

  @override
  String toString() {
    return 'JobModel('
        'id: $id, '
        'userId: $userId, '
        'userDeviceToken: $userDeviceToken, '
        'jobTitle: $jobTitle, '
        'companyName: $companyName, '
        'createdAt: $createdAt, '
        'applicationDate: $applicationDate, '
        'applicationStatus: $applicationStatus, '
        'interviewDate: $interviewDate, '
        'notes: $notes'
        ')';
  }
}
