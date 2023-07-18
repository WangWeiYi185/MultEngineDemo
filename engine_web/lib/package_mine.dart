import 'package:flutter/material.dart';
import 'package:engine_web/navigator_imp.dart';
import 'package:flutter/services.dart';

class PackageMine extends StatefulWidget {
  const PackageMine({Key? key}) : super(key: key);

  @override
  PackageMineState createState() => PackageMineState();
}

class PackageMineState extends State<PackageMine> {
  String? text;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            title: const Text('我的'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                YCNavigator().pop();
              },
            ),
            actions: [
              TextButton(
                child: const Text("快乐星球"),
                onPressed: () {
                  const bkupChannel = MethodChannel('disaster-backUp');
                  bkupChannel.invokeMethod<void>("disasterBackUp", {});
                },
              )
            ]),
        body: const Center(
          child: Text('我的'),
        ),
      ),
    );
  }
}
