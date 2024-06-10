import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:chat_app_ayna/screens/auth/login.dart';

class FirstScreen extends StatelessWidget {
  static const routeName = '/first';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Gap(size.height * 0.17),
            const Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(
                  "assets/images/logo.jpeg",
                ),
              ),
            ),
            Gap(size.height * 0.25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  const Gap(10),
                  const Gap(10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width * 0.87,
                          height: 45,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 31, 64, 60),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Text(
                            "Continue to App",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      ),
                      const Gap(25),
                    ],
                  ),
                ],
              ),
            ),
            Gap(size.height * 0.125),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Please check out ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 31, 64, 60),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Terms and Conditions!",
                    style: TextStyle(
                      color: Color.fromARGB(255, 31, 64, 60),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
