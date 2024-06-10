import 'package:chat_app_ayna/bloc/auth_event.dart';
import 'package:chat_app_ayna/bloc/auth_state.dart';
import 'package:chat_app_ayna/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository authRepository;
  final BuildContext context;

  AuthBloc({required this.authRepository, required this.context})
      : super(AuthInitial()) {
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signInUser(
          email: event.email,
          password: event.password,
          context: context,
        );
        if (user != null) {
          emit(AuthAuthenticated(user: user));
          Navigator.pushReplacementNamed(context, "/chatscreen");
        } else {
          emit(AuthError('Failed to sign in'));
        }
      } catch (e) {
        print("errorroorrroror ======>>>>>> $e");
        emit(AuthError('Failed to sign in'));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signUpuser(
          name: event.name,
          email: event.email,
          password: event.password,
          context: context,
        );
        if (user != null) {
          emit(AuthAuthenticated(user: user));
          Navigator.pushReplacementNamed(context, "/chatscreen");
        } else {
          emit(AuthError('Failed to sign up'));
        }
      } catch (e) {
        print("errorroorrroror ======>>>>>> $e");
        emit(AuthError('Failed to sign up'));
      }
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthUnauthenticated());
    });

  
  }
}
