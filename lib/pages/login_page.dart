import 'package:flutter/material.dart';
import 'package:jotify/services/auth%20service/auth_service.dart';

import '../components/my_text_field.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    AuthService authService = AuthService();
    void login(){
      try{
        authService.signInWithEmailPassword(emailController.text, passwordController.text);
      }catch(e){
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text(e.toString()),
        ));
      }

    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                child: ClipOval(
                  child: Image.asset(
                    'assets/jotify.png',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                  controller: emailController,
                  label: 'Email',
                  isPassword: false),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                  controller: passwordController,
                  label: 'Password',
                  isPassword: true),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: ()=> login(),
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 30, vertical: 5)),
                  ),
                  child: Text(
                    'L O G I N',
                    style: TextStyle(color: Colors.black),
                  )),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(child: Divider(height: 1,)),
                  SizedBox(width: 10,),
                  Text('OR'),
                  SizedBox(width: 10,),
                  Expanded(child: Divider(height: 1,)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  'Create new account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
