import 'package:flutter/material.dart';
import 'package:seller/auth/auth_screen.dart';
import 'package:seller/global/global.dart';
import 'package:seller/uploadScreens/menus_upload_screens.dart';
import 'package:seller/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
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
        title: Text(
          sharedPreferences!.getString("name")!,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => MenuUploadScreen()));
              },
              icon: const Icon(
                Icons.post_add,
                size: 30,
                color: Color.fromARGB(255, 255, 255, 255),
              ),),
        ],
      ),
      body: Center(
          child: ElevatedButton(
        child: const Text("logout"),
        style: ElevatedButton.styleFrom(
          primary: Colors.cyan,
        ),
        onPressed: () {
          firebaseAuth.signOut().then((value) {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => const AuthScreen()));
          });
        },
      )),
    );
  }
}
