import 'package:chat_app_ayna/constats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app_ayna/bloc/auth_bloc.dart';
import 'package:chat_app_ayna/bloc/auth_event.dart';
import 'package:chat_app_ayna/bloc/auth_state.dart';
import 'package:chat_app_ayna/screens/auth/signup_screen.dart';
import 'package:chat_app_ayna/widgets/custom_button.dart';
import 'package:chat_app_ayna/widgets/custom_textfield.dart';
import 'package:hive/hive.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Color.fromARGB(236, 62, 126, 119),
      body: BlocProvider(
        create: (context) => AuthBloc(authRepository: userrepo, context: context),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacementNamed(context, "/chatscreen");
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Welcome To Chat App",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Form(
                      key: _loginKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: "Email",
                            controller: _emailController,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            hintText: "Password",
                            controller: _passwordController,
                            isPass: true,
                          ),
                          const SizedBox(height: 20),
                          state is AuthLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : CustomButton(
                                  widget: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_loginKey.currentState!.validate()) {
                                      BlocProvider.of<AuthBloc>(context).add(
                                        SignInEvent(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an Account?",
                          style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
