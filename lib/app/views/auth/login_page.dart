import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paltel/app/constants.dart';

import '../../controllers/auth_controller.dart';
import 'widgets/show_forgotPassword_dialog.dart';
import 'widgets/validate_and_login.dart';

class LoginPage extends StatelessWidget {
  final AuthController controller = Get.find();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Image(
                          image: AssetImage('assets/images/jawwalLogo.png'),
                          width: 350,
                          height: 250,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ShaderMask(
                        shaderCallback:
                            (bounds) => LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 34, 34, 34),
                                primaryColr,
                              ],
                              tileMode: TileMode.clamp,
                            ).createShader(bounds),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      TextField(
                        onChanged: (value) => controller.email.value = value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(232, 240, 254, 1),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      TextField(
                        onChanged: (value) => controller.password.value = value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(232, 240, 254, 1),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => showForgotPasswordDialog(),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: primaryColr),
                          ),
                        ),
                      ),

                      // Forgot password dialog
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: const ButtonStyle(
                          shape: WidgetStatePropertyAll<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            primaryColr,
                          ),
                        ),
                        onPressed: validateAndLogin,
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            controller.loginIndicator.value
                ? Container(
                  color: Colors.white.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                )
                : Container(),
          ],
        ),
      );
    });
  }
}
