import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../controllers/auth_controller.dart';

class ChangePasswordTab extends StatefulWidget {
  const ChangePasswordTab({super.key});

  @override
  _ChangePasswordTabState createState() => _ChangePasswordTabState();
}

class _ChangePasswordTabState extends State<ChangePasswordTab> {
  final _formKey = GlobalKey<FormState>();
  String? _oldPassword = '';
  String? _newPassword = '';
  String? _confirmNewPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Change Your Password', style: TextStyle(fontSize: 25)),
            SizedBox(height: 5),
            Text(
              'Here you can change your old password by writing a new one.',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Old Password',
                        filled: true,
                        fillColor: Color.fromRGBO(232, 240, 254, 1),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your old password';
                        }
                        return null;
                      },
                      onSaved: (value) => _oldPassword = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'New Password',
                        filled: true,
                        fillColor: Color.fromRGBO(232, 240, 254, 1),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your new password';
                        }
                        return null;
                      },
                      onChanged: (value) => _newPassword = value,
                      onSaved: (value) => _newPassword = value,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Confirm New Password',
                        filled: true,
                        fillColor: Color.fromRGBO(232, 240, 254, 1),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your new password';
                        } else if (value != _newPassword) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onChanged: (value) => _confirmNewPassword = value,
                      onSaved: (value) => _confirmNewPassword = value!,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: primaryColr,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          AuthController().changePassword(
                            _oldPassword!,
                            _newPassword!,
                          );
                        }
                      },
                      child: const Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
