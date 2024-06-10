// profile_screen.dart
import 'dart:convert';
import 'dart:io';
import 'package:chat_app_ayna/bloc/auth_bloc.dart';
import 'package:chat_app_ayna/bloc/auth_event.dart';
import 'package:chat_app_ayna/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _selectProfilePic(context),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(state.user.profilePic),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Name: ${state.user.name}'),
                      Text('Email: ${state.user.email}'),
                      Text('Mobile Number: ${state.user.mobileNumber}'),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Handle other states or show loading indicator
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

void _selectProfilePic(BuildContext context) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    final profilePicBytes = await File(pickedFile.path);
    if (profilePicBytes != null) {
      final profilePicBase64 =  base64Encode(await profilePicBytes.readAsBytes()); // Convert bytes to base64 string
      context.read<AuthBloc>().add(ProfilePicChanged(profilePicUrl: profilePicBase64));
    } else {
      // Handle error reading profile pic file
    }
  }
}
}
