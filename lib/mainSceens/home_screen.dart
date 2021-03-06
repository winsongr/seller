import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller/auth/auth_screen.dart';
import 'package:seller/global/global.dart';
import 'package:seller/model/menus.dart';
import 'package:seller/uploadScreens/menus_upload_screens.dart';
import 'package:seller/widgets/app_drawer.dart';
import 'package:seller/widgets/info_design.dart';
import 'package:seller/widgets/progress_bar.dart';

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
                  MaterialPageRoute(builder: (c) => const MenuUploadScreen()));
            },
            icon: const Icon(
              Icons.post_add,
              size: 30,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "My Menus",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("sellers")
                    .doc(sharedPreferences!.getString("uid"))
                    .collection("menus")
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(
                          child: circularProgress(),
                        )
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: snapshot.data!.size,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            Menus model = Menus.fromJson(
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>);

                            return InfoDesignWidget(
                                model: model, context: context);
                          },
                        );
                }),
          ],
        ),
      ),
    );
  }
}
