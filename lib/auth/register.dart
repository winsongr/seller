import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller/mainSceens/home_screen.dart';
import 'package:seller/widgets/cus_textfield.dart';
import 'package:seller/widgets/error_dialog.dart';
import 'package:seller/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  XFile? imageXfile;

  final ImagePicker _picker = ImagePicker();
  _getImage() async {
    imageXfile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXfile;
    });
  }

  Position? position;
  List<Placemark>? placemarks;

  String sellerImageUrl = "";
  String completeAddress = "";
  getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placemarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pMark = placemarks![0];
    completeAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare},${pMark.subLocality} ${pMark.locality},${pMark.subAdministrativeArea},${pMark.administrativeArea},${pMark.postalCode},${pMark.country} ';

    locationController.text = completeAddress;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  formValidation() async {
    if (imageXfile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: "select an image",
            );
          });
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            locationController.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (c) {
                return const LoadingDialog(message: "Registering Account");
              });
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fstorage.Reference reference = fstorage.FirebaseStorage.instance
              .ref()
              .child("sellers")
              .child(fileName);
          fstorage.UploadTask uploadTask =
              reference.putFile(File(imageXfile!.path));
          fstorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() => {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;

            //save to firebase
            authenticateSellerAndSignUp();
          });
        } else {
          showDialog(
              context: context,
              builder: (c) {
                return const ErrorDialog(
                  message: "fill required fields",
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                message: "Password not matching",
              );
            });
      }
    }
  }

  void authenticateSellerAndSignUp() async {
    User? currentUser;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        Route newRoute =
            MaterialPageRoute(builder: ((context) => HomeScreen()));
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      "sellerUid": currentUser.uid,
      "sellerEmail": currentUser.email,
      "sellerName": nameController.text.trim(),
      "sellerAvatarUrl": sellerImageUrl,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "status": "approved",
      "earnings": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });
    //save locally
    SharedPreferences? sharedpreferences =
        await SharedPreferences.getInstance();
    await sharedpreferences.setString("uid", currentUser.uid);
    await sharedpreferences.setString("name", nameController.text.trim());
    await sharedpreferences.setString("email", currentUser.email.toString());
    await sharedpreferences.setString("photoUrl", sellerImageUrl);
  }

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
              onTap: () {
                _getImage();
              },
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
                      data: Icons.my_location,
                      controller: locationController,
                      hintText: "Location",
                    ),
                    Container(
                      width: 400,
                      height: 40,
                      alignment: Alignment.center,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          getCurrentLocation();
                        },
                        label: const Text(
                          "Get My Current Location",
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                formValidation();
              },
              child: const Text(
                "Sign Up ",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
