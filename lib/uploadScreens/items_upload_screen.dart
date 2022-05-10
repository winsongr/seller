import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageref;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller/global/global.dart';
import 'package:seller/mainSceens/home_screen.dart';
import 'package:seller/model/menus.dart';
import 'package:seller/widgets/error_dialog.dart';
import 'package:seller/widgets/progress_bar.dart';

class ItemsUploadScreen extends StatefulWidget {
  const ItemsUploadScreen({Key? key, this.model}) : super(key: key);
  final Menus? model;
  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();

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
          title: const Text("Add New Item"),
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
                "Add Item",
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
              "Item Image",
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

  itemsUploadFormScreen() {
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
        title: const Text("Uploading New item"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            clearitemUploadForm();
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
                  hintText: "item Info",
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
            Icons.title,
            color: Colors.cyan,
          ),
          title: SizedBox(
            width: 250,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: shortInfoController,
              decoration: const InputDecoration(
                  hintText: "item Title",
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
            Icons.description,
            color: Colors.cyan,
          ),
          title: SizedBox(
            width: 250,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: descController,
              decoration: const InputDecoration(
                  hintText: "Desc",
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
            Icons.price_check,
            color: Colors.cyan,
          ),
          title: SizedBox(
            width: 250,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Price",
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

  clearitemUploadForm() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      priceController.clear();
      descController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          descController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
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
        .collection("menus")
        .doc(widget.model!.menuID)
        .collection("items");
    ref.doc(uniqueIdName).set({
      "itemID": uniqueIdName,
      "menuID": widget.model!.menuID,
      "sellerUID": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "shortInfo": shortInfoController.text.toString(),
      "descInfo": descController.text.toString(),
      "price": int.parse(priceController.text),
      "title": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    }).then((value) {
      final itemsRef = FirebaseFirestore.instance.collection("items");

      itemsRef.doc(uniqueIdName).set({
        "itemID": uniqueIdName,
        "menuID": widget.model!.menuID,
        "sellerUID": sharedPreferences!.getString("uid"),
        "sellerName": sharedPreferences!.getString("name"),
        "shortInfo": shortInfoController.text.toString(),
        "descInfo": descController.text.toString(),
        "price": int.parse(priceController.text),
        "title": titleController.text.toString(),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
      });
    }).then((value) {
      clearitemUploadForm();
      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });
    });
  }

  uploadImage(mImageFile) async {
    storageref.Reference reference =
        storageref.FirebaseStorage.instance.ref().child("items");

    storageref.UploadTask uploadTask =
        reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageref.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : itemsUploadFormScreen();
  }
}
