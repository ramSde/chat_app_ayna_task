import 'package:chat_app_ayna/bloc/auth_bloc.dart';
import 'package:chat_app_ayna/bloc/auth_event.dart';
import 'package:chat_app_ayna/bloc/auth_state.dart';
import 'package:chat_app_ayna/constats.dart';
import 'package:chat_app_ayna/screens/auth/login.dart';
import 'package:chat_app_ayna/widgets/custom_button.dart';
import 'package:chat_app_ayna/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  static const routeName = "/signup";

  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
    final authbloc = AuthBloc(authRepository: userrepo, context: context);

    return Scaffold(
      backgroundColor: Color.fromARGB(236, 62, 126, 119),
      body: BlocProvider(
        create: (context) => AuthBloc(authRepository: userrepo, context: context),
        child: BlocConsumer<AuthBloc, AuthState>(
          bloc: authbloc,
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
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Register Here",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: _signUpKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              hintText: "Name",
                              controller: _nameController,
                            ),
                            const SizedBox(height: 20),
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
                            CustomButton(
                              widget: state is AuthLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              onPressed: () {
                                if (_signUpKey.currentState!.validate()) {
                                  print("name ------>>>>>>>${_nameController.text}");
                                   print("name ------>>>>>>>${_nameController.text}");
 print("name ------>>>>>>>${_nameController.text}");
                                  authbloc.add(
                                    SignUpEvent(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "Already have an Account?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
