import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller/global/global.dart';
import 'package:seller/mainSceens/home_screen.dart';
import 'package:seller/widgets/error_dialog.dart';
import 'package:seller/widgets/progress_bar.dart';

class MenuUploadScreen extends StatefulWidget {
  const MenuUploadScreen({Key? key}) : super(key: key);

  @override
  State<MenuUploadScreen> createState() => _MenuUploadScreenState();
}

class _MenuUploadScreenState extends State<MenuUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.amber, Colors.cyan],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )),
          ),
          title: const Text("Add New Menu"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const HomeScreen(),
                  ));
            },
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shop_two,
              color: Colors.grey,
              size: 200.0,
            ),
            ElevatedButton(
              onPressed: () {
                takeImage(context);
              },
              child: const Text(
                "Add Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.cyan),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Menu Image",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                child: const Text(
                  "Capture with Camera",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Select from Gallery",
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.red, fontSize: 20)),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );  
    setState(() {
      imageXFile;
    });
  }

  menusUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.amber, Colors.cyan],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: const Text("Uploading New Menu"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            clearMenuUploadForm();
          },
        ),
        actions: [
          TextButton(
            onPressed: uploading ? null : () => validateUploadForm(),
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 3,
              ),
            ),
          ),
        ],
      ),
      body: ListView(children: [
        uploading == true ? linearProgress() : const Text(""),
        SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                          File(imageXFile!.path),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
            )),
        ListTile(
          leading: const Icon(
            Icons.perm_device_information,
            color: Colors.cyan,
          ),
          title: SizedBox(
            width: 250,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: titleController,
              decoration: const InputDecoration(
                  hintText: "Menu Info",
                  hintStyle: TextStyle(color: Colors.green),
                  border: InputBorder.none),
            ),
          ),
        ),
        const Divider(
          color: Colors.red,
          thickness: 2,
        ),
        ListTile(
          leading: const Icon(
            Icons.perm_device_information,
            color: Colors.cyan,
          ),
          title: SizedBox(
            width: 250,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: shortInfoController,
              decoration: const InputDecoration(
                  hintText: "Menu Title",
                  hintStyle: TextStyle(color: Colors.green),
                  border: InputBorder.none),
            ),
          ),
        ),
        const Divider(
          color: Colors.red,
          thickness: 2,
        ),
      ]),
    );
  }

  clearMenuUploadForm() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });

        String downloadUrl = await uploadImage(File(imageXFile!.path));

        saveInfo(downloadUrl);
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                message: "Please Fill the text fields",
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: "Please pick an image",
            );
          });
    }
  }

  saveInfo(String downloadUrl) {
    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus");
    ref.doc(uniqueIdName).set({
      "menuID": uniqueIdName,
      "sellerUID": sharedPreferences!.getString("uid"),
      "menuInfo": shortInfoController.text.toString(),
      "menuTitle": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    });
    clearMenuUploadForm();
    setState(() {
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("menus");

    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }
}
