import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller/widgets/cus_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  XFile? imageXfile;

  final ImagePicker _picker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXfile == null
                    ? null
                    : FileImage(File(imageXfile!.path)),
                child: imageXfile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: MediaQuery.of(context).size.width * 0.20,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      isObsecre: false,
                      data: Icons.person,
                      controller: nameController,
                      hintText: "Name",
                    ),
                    CustomTextField(
                      isObsecre: false,
                      data: Icons.email,
                      controller: emailController,
                      hintText: "Email",
                    ),
                    CustomTextField(
                      isObsecre: true,
                      data: Icons.lock,
                      controller: passwordController,
                      hintText: "Password",
                    ),
                    CustomTextField(
                      isObsecre: true,
                      data: Icons.lock,
                      controller: confirmPasswordController,
                      hintText: "confirm password",
                    ),
                    CustomTextField(
                      isObsecre: false,
                      data: Icons.phone,
                      controller: phoneController,
                      hintText: "Phone",
                    ),
                    CustomTextField(
                      isObsecre: false,
                      data: Icons.location_city,
                      controller: locationController,
                      hintText: "Location",
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
