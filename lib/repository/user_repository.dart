import 'dart:convert';
import 'package:chat_app_ayna/screens/auth/first_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app_ayna/constats.dart'; // Import your state classes

class User {
  final String email;
  final String name;
  final String mobileNumber;
  final String profilePic;

  User({
    required this.email,
    required this.name,
    required this.mobileNumber,
    required this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      mobileNumber: json['mobile_no'] ?? '',
      profilePic: json['profilePic'] ?? '',
    );
  }
}

class UserRepository {
  String url = "https://fcb-donation.onrender.com";

  Future<User?> signUpuser({
    required String email,
    required String password,
    required String name,
    required BuildContext context,
  }) async {
    try {
      final http.Response res = await http.post(
        Uri.parse('$url/api/auth/signUp'),
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
      );

      if (res.statusCode == 200) {
        return User.fromJson(jsonDecode(res.body));
      }
    } catch (e) {
      print("Error: $e");
    }

    return null;
  }

  Future<User?> signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final http.Response res = await http.post(
        Uri.parse("$url/api/auth/SignIn"),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (res.statusCode == 200) {
        final jsonDecoded = jsonDecode(res.body);
        final SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('x-auth-token', jsonDecoded['token']);
        return User.fromJson(jsonDecoded);
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }
Future<bool> isLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('x-auth-token');
    return token != null && token.isNotEmpty;
  }
  Future<void> getUserData({required BuildContext context}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('x-auth-token');

      if (token == null || token.isEmpty) {
        pref.setString('x-auth-token', "");
        return;
      }

      final http.Response res = await http.get(
        Uri.parse("$url/api/isValidToken"),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'x-auth-token': token,
        },
      );

      if (jsonDecode(res.body) == true) {
        final http.Response userRes = await http.get(
          Uri.parse('$url/api/getUserData'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        print(jsonDecode(userRes.body)['token']);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> logOut(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final chatbox = await Hive.box("chatBox");
    chatbox.clear();
    pref.setString('x-auth-token', "");
    Navigator.pushNamedAndRemoveUntil(
      context,
      FirstScreen.routeName,
      (route) => false,
    );
  }

  void httpErrorHandling({
    required http.Response res,
    required VoidCallback onSuccess,
  }) {
    switch (res.statusCode) {
      case 200:
        onSuccess();
        break;
      case 400:
        GlobalSnackbar().showSnackbar('Bad request');
        break;
      case 401:
        GlobalSnackbar().showSnackbar('Unauthorized');
        break;
      case 500:
        GlobalSnackbar().showSnackbar('Server error');
        break;
      default:
        GlobalSnackbar().showSnackbar('Unexpected error');
    }
  }
}
