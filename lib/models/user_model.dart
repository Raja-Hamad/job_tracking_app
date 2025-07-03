import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName;
  final String email;
  final String phone;
  final String gender;
  final String dob;
  final String imageUrl;
  final String address;
  final Timestamp ? createdAt;
  final String id;
  final String userDeviceToken;

  UserModel({
    required this.address,
    required this.dob,
    required this.email,
    required this.gender,
    required this.imageUrl,
    required this.userDeviceToken,
    required this.phone,
     this.createdAt,
    required this.userName,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final createdAt1 = json["createdAt"];
    return UserModel(
      userDeviceToken: json['userDeviceToken'],
      id: json['id'],
      address: json['address'],
      dob: json['dob'],
      email: json['email'],
      gender: json['gender'],
      imageUrl: json['imageUrl'],
      phone: json['phone'],
      createdAt: createdAt1 is Timestamp ? json['createdAt'] : null,
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userDeviceToken": userDeviceToken,
      "userName": userName,
      "gender": gender,
      "phone": phone,
      'email': email,
      "dob": dob,
      "imageUrl": imageUrl,
      "createdAt": FieldValue.serverTimestamp(),
      "address": address,
    };
  }

  @override
  String toString() {
    return 'UserModel('
        'userDeviceToken:$userDeviceToken, '
        'id:$id, '
        'userName:$userName, '
        'gender:$gender, '
        'phone:$phone, '
        'email:$email, '
        'dob:$dob, '
        'createdAt:$createdAt, '
        'address:$address, '
        'imageUrl:$imageUrl,'
        ')';
  }
}
