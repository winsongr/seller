import 'package:flutter/material.dart';
import 'package:seller/widgets/cus_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                "images/seller.png",
                height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  isObsecre: false,
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                ),
                CustomTextField(
                    isObsecre: true,
                    hintText: "Password",
                    controller: passwordController,
                    data: Icons.password),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => print("sign in"),
            child: const Text(
              "Login",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
                primary: Colors.cyanAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
          ),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
