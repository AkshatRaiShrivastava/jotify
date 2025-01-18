import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jotify/components/my_text_field.dart';
import 'package:jotify/services/auth%20service/auth_service.dart';
import 'package:permission_handler/permission_handler.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthService authService = AuthService();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool pickedImage = false;
  late File profile_path;
  void register() {
    try {
      authService.signupWithEmailPAssword(_nameController.text,
          _emailController.text, _passwordController.text, profile_path);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  Future<void> pickImage() async {
    try {
      // Request necessary permissions
      //await requestPermissions();

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }

      log('Image path: ${image?.path}');
      profile_path = File(image!.path);
      pickedImage = true;
      setState(() {});
      return;
    } catch (e) {
      log('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> requestPermissions() async {
    try {
      if (await Permission.camera.isDenied) {
        await Permission.camera.request();
      }
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }
    } catch (e) {
      log('Permission request error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => pickImage(),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: pickedImage
                      ? FileImage(profile_path) as ImageProvider
                      : null,
                  child: pickedImage
                      ? null
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(
                              height: 15,
                            ),
                            Text('Set profile picture')
                          ],
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  isPassword: false),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                  controller: _emailController,
                  label: 'Email',
                  isPassword: false),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                  controller: _passwordController,
                  label: 'Password',
                  isPassword: true),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm password',
                  isPassword: true),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  register();
                  setState(() {});
                },
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 30, vertical: 5)),
                ),
                child: Text(
                  'R E G I S T E R',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account ? '),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
