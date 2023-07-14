import 'package:flutter/material.dart';
import 'package:engine_module/navigator_imp.dart';

class PackageMine extends StatefulWidget {
  const PackageMine({ Key? key }) : super(key: key);

  @override
  PackageMineState createState() => PackageMineState();
}

class PackageMineState extends State<PackageMine> {
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
        )
        ),
        body: const Center(
          child: Text('我的'),
        ),
      ),
    );
  }
}