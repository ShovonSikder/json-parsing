import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsonpersing/models/android_version.dart';

//widget to show each item
class DisplayItems extends StatelessWidget {
  final List<AndroidVerison> children;
  const DisplayItems({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: children
          .map((version) => Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(1),
                padding: const EdgeInsets.all(10),
                color: Colors.black,
                height: 50,
                width: 100,
                child: Text(
                  version.title ?? '',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ))
          .toList(),
    );
  }
}
