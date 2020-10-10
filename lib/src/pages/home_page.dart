import 'dart:io';

import 'package:band_names/src/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/src/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: provider.socketStatus == SocketStatus.Online
                ? Icon(Icons.check_circle, color: Colors.greenAccent)
                : Icon(Icons.remove_circle, color: Colors.redAccent),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Band Names',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Column(
        children: [
          BandVotesChart(),
          Expanded(
            child: ListView.builder(
                itemCount: provider.bands.length,
                itemBuilder: (context, index) =>
                    _bandTile(provider, provider.bands[index])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: () => addNewBand(provider),
      ),
    );
  }

  Widget _bandTile(SocketService provider, Band band) {
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
        onTap: () {
          print(band.id);
          provider.addVote(band.id);
        },
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
      ),
      direction: DismissDirection.startToEnd,
      key: Key(band.id),
      onDismissed: (direction) {
        provider.deleteBand(band.id);
        print('Direction: $direction');
      },
    );
  }

  addNewBand(SocketService provider) {
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
                onPressed: () {
                  provider.addBand(controller.text);
                  Navigator.pop(context);
                },
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
                onPressed: () {
                  provider.addBand(controller.text);
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  }
}

class BandVotesChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocketService>(context);
    if (provider.bands.isEmpty) return Container();
    return Container(
      child: PieChart(
        chartType: ChartType.ring,
        chartValuesOptions: ChartValuesOptions(decimalPlaces: 0),
        dataMap: Map.fromIterable(provider.bands,
            key: (b) => b.name, value: (b) => b.votes.toDouble()),
      ),
      padding: EdgeInsets.all(10),
    );
  }
}
