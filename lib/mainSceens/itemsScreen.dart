import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seller/global/global.dart';
import 'package:seller/model/items.dart';
import 'package:seller/model/menus.dart';
import 'package:seller/uploadScreens/items_upload_screen.dart';
import 'package:seller/widgets/app_drawer.dart';
import 'package:seller/widgets/info_design.dart';
import 'package:seller/widgets/item_design.dart';
import 'package:seller/widgets/progress_bar.dart';

import '../uploadScreens/menus_upload_screens.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;

  const ItemsScreen({Key? key, this.model}) : super(key: key);

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
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
        title: Text(
          sharedPreferences!.getString("name")!,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            ItemsUploadScreen(model: widget.model)));
              },
              icon: const Icon(
                Icons.library_add,
                color: Color.fromARGB(255, 255, 255, 255),
              ))
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "My " + widget.model!.menuTitle.toString() + "'s items",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20.0),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("sellers")
                    .doc(sharedPreferences!.getString("uid"))
                    .collection("menus")
                    .doc(widget.model!.menuID)
                    .collection("items").orderBy("publishedDate",descending: true)
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
                          itemCount: snapshot.data?.size,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            Items model = Items.fromJson(
                                snapshot.data?.docs[index].data()
                                    as Map<String, dynamic>);

                            return ItemDesignWidget(
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
