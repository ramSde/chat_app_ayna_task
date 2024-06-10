import 'package:chat_app_ayna/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_ayna/bloc/auth_bloc.dart';
import 'package:chat_app_ayna/repository/user_repository.dart';
import 'package:chat_app_ayna/screens/auth/login.dart';
import 'package:chat_app_ayna/screens/auth/first_screen.dart';
import 'package:chat_app_ayna/screens/chat_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('chatBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userRepository.isLoggedIn(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.data == true) {
            return BlocProvider(
              create: (context) => AuthBloc(authRepository: userRepository, context: context),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Chat App',
                theme: ThemeData(primarySwatch: Colors.blue),
                home: ChatScreen(),
                routes: {
                  FirstScreen.routeName: (context) =>  FirstScreen(),
                  '/login': (context) => const Login(),
                  "/chatscreen": (context) => ChatScreen(),
                },
              ),
            );
          } else {
            return BlocProvider(
              create: (context) => AuthBloc(authRepository: userRepository, context: context),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Chat App',
                theme: ThemeData(primarySwatch: Colors.blue),
                home: Login(),
                routes: {
                  FirstScreen.routeName: (context) =>  FirstScreen(),
                  '/login': (context) => const Login(),
                  "/chatscreen": (context) => ChatScreen(),
                },
              ),
            );
          }
        }
      },
    );
  }
}
