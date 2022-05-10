import 'package:flutter/material.dart';
import 'package:seller/mainSceens/itemsScreen.dart';
import 'package:seller/model/items.dart';
import 'package:seller/model/menus.dart';
import 'package:seller/uploadScreens/menus_upload_screens.dart';

class InfoDesignWidget extends StatefulWidget {
  InfoDesignWidget({Key? key, this.model, this.context}) : super(key: key);
  Menus? model;
  
  BuildContext? context;
  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              const Padding(padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0)),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 150.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 2.0,
              ),
              Text(
                widget.model!.menuTitle!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                ),
              ),
              Divider(
                height: 4,
                thickness: 1,
                color: Colors.grey[300],
              ),
              Text(widget.model!.menuInfo!,
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 15,
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
