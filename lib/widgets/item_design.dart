import 'package:flutter/material.dart';
import 'package:seller/model/items.dart';

class ItemDesignWidget extends StatefulWidget {
    Items? model;

  ItemDesignWidget({Key? key, this.model, this.context}) : super(key: key);

  BuildContext? context;
  @override
  State<ItemDesignWidget> createState() => _ItemDesignWidgetState();
}

class _ItemDesignWidgetState extends State<ItemDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (c) => ItemsScreen(model: widget.model)));
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
              Text(
                " ${widget.model?.title}",
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                ),
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 150.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 2.0,
              ),
              Divider(
                height: 4,
                thickness: 1,
                color: Colors.grey[300],
              ),
              Text( " ${widget.model?.shortInfo}",
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
