import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/src/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Pink Floyd', votes: 0),
    Band(id: '2', name: 'Pearl Jam', votes: 0),
    Band(id: '3', name: 'The Beatles', votes: 0),
    Band(id: '4', name: 'KISS', votes: 0),
    Band(id: '5', name: 'Alice in Chains', votes: 0),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Band Names',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, index) => _bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      background: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          'Delete band',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Colors.red,
        padding: EdgeInsets.only(left: 20),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 1)),
        ),
        onTap: () => print(band.name),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
      ),
      direction: DismissDirection.startToEnd,
      key: Key(band.id),
      onDismissed: (direction) {
        // TODO: Delete in backend
        print('Direction: $direction');
      },
    );
  }

  addNewBand() {
    final controller = TextEditingController();
    if (Platform.isIOS) {
      return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('New band name: '),
            content: CupertinoTextField(
              controller: controller,
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('Add'),
                isDefaultAction: true,
                onPressed: () => addBandToList(controller.text),
              ),
              CupertinoDialogAction(
                child: Text('Dismiss'),
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New band name: '),
            content: TextField(
              controller: controller,
            ),
            actions: [
              MaterialButton(
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.blue),
                ),
                elevation: 5,
                onPressed: () => addBandToList(controller.text),
              )
            ],
          );
        },
      );
    }
  }

  addBandToList(String name) {
    if (name.isNotEmpty) {
      bands.add(Band(id: DateTime.now().toString(), name: name));
    }
    setState(() {});
    Navigator.pop(context);
  }
}
