import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String mobileNumber;

  @HiveField(3)
  final String profilePic;

  User({
    required this.email,
    required this.name,
    required this.mobileNumber,
    required this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      profilePic: json['profilePic'],
    );
  }
}
