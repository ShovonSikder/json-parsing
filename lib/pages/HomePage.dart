import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jsonpersing/customewidget/display_items.dart';

import '../data/json_data.dart';
import '../models/android_version.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AndroidVerison> androidVersionsList = [];

  final _searchIdController = TextEditingController();
  String? title = '';
  @override
  void didChangeDependencies() {
    parseJson(jsonData1);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DisplayItems(
            children: androidVersionsList,
          ),

          //buttons to switch json
          buildSwitchButtons(),

          buildSearchBar(),

          //display searched data
          Text(
            _searchIdController.text.isNotEmpty
                ? 'Data\nFor ID: ${_searchIdController.text}\nTitle: ${title ?? 'Not found'}'
                : '',
          ),
        ],
      ),
    );
  }

  Padding buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchIdController,
              decoration: const InputDecoration(
                labelText: 'Enter Search ID',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_searchIdController.text.isNotEmpty) {
                final id = int.parse(_searchIdController.text);
                title = findVersion(id);
              }
              setState(() {});
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  Row buildSwitchButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            androidVersionsList = [];
            setState(() {
              parseJson(jsonData1);
            });
          },
          child: const Text(
            'Input-1',
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {
            androidVersionsList = [];
            setState(() {
              parseJson(jsonData2);
            });
          },
          child: const Text(
            'Input-2',
          ),
        )
      ],
    );
  }

  //method to parseJSON data
  void parseJson(List<dynamic> json) {
    // print(json.runtimeType);

    for (var data in json) {
      if (data.runtimeType == List<Object>) {
        //for nested list of object+list
        parseJson(data);
      }
      //for clean list of map {'id': , 'title': }
      else if (data.runtimeType == List<Map<String, Object>>) {
        for (var version in data) {
          androidVersionsList.add(
            AndroidVerison(
              id: version['id'],
              title: version['title'],
            ),
          );
        }
      } else {
        //for object in list
        final keys = data.keys.toList();
        int endKey = int.parse(keys[keys.length - 1]);

        for (var i = 0; i <= endKey; i++) {
          (data[i.toString()] != null)
              ? androidVersionsList.add(
                  AndroidVerison(
                    id: data[i.toString()]['id'],
                    title: data[i.toString()]['title'],
                  ),
                )
              : androidVersionsList.add(AndroidVerison(id: null, title: null));
        }
      }
    }
  }

  String? findVersion(int id) {
    for (var version in androidVersionsList) {
      if (version.id == id) return version.title;
    }
    return null;
  }
}
