import 'package:chat_app_ayna/repository/user_repository.dart';
import 'package:flutter/material.dart';

const primaryColor = Color.fromRGBO(122, 120, 219, 1);
const themeColor = Color.fromARGB(255, 63, 154, 146);
const white = Colors.white;
const black = Colors.black;
const backgroudColor = Color.fromARGB(255, 244, 244, 244);

var userrepo = UserRepository();


class GlobalSnackbar {
  static GlobalKey<ScaffoldMessengerState> key =
      GlobalKey<ScaffoldMessengerState>();
  showSnackbar(String data) {
    key.currentState!
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(data)));
  }
}