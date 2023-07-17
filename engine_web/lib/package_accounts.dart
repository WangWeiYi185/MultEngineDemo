import 'package:flutter/material.dart';
import 'package:engine_web/navigator_imp.dart';


class PackageAccounts extends StatefulWidget {
  const PackageAccounts({ Key? key }) : super(key: key);

  @override
  PackageAccountsState createState() => PackageAccountsState();
}

class PackageAccountsState extends State<PackageAccounts> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('账号'),
           leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              YCNavigator().pop();
            },
        )
        ),
        body:  Center(
          child:   TextButton(onPressed: (){
            YCNavigator().push( '/accounts', toNative: true);
          }, child:  const Text('跳转到账户模块 toNative ')),
        
        ),
      ),
    );
  }
}