import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

// package 拆分业务模块
import 'package:engine_module/package_accounts.dart';
import 'package:engine_module/package_mine.dart';
  
// navigator 能力下沉
import 'package:engine_module/navigator_imp.dart';
import 'dart:ui' as ui;

 /// wait
  Future<void> waitForStart() async {
    final last = DateTime.now().millisecondsSinceEpoch;
    final stream = Stream<double>.periodic(
        const Duration(milliseconds: 10), (x) => ui.window.physicalSize.width);
    // wait for
    await for (double value in stream) {
      final current = DateTime.now().millisecondsSinceEpoch;
      final timeout = (current - last) >= 100;
      if (value > 0) {
        final current = DateTime.now().millisecondsSinceEpoch;
        print(
            "guangShopFlutter global: coast time == ${current - last}");
        return;
      } else if (timeout) {
        print(
            "guangShopFlutter waitForStart timeout, window size is 0");
        return;
      }
    }
    return;
  }
  
@pragma('vm:entry-point')
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await waitForStart();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      
    );
    // return MaterialApp(
      
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     // This is the theme of your application.
    //     //
    //     // Try running your application with "flutter run". You'll see the
    //     // application has a blue toolbar. Then, without quitting the app, try
    //     // changing the primarySwatch below to Colors.green and then invoke
    //     // "hot reload" (press "r" in the console where you ran "flutter run",
    //     // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
    //     // counter didn't reset back to zero; the application is not restarted.
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: const MyHomePage(title: 'Flutter Demo Home Page'),
    // );
  }
}

final _router = GoRouter(
  navigatorKey:  YCNavigator().navigatorKey,
  initialLocation: YCNavigator().appInitialRoute, // 获取原生传递的路由 (initRoute)
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(title: '直视我栽种',),
    ),
     GoRoute(
      path: '/accounts',
      builder: (context, state) => const PackageAccounts(),
    ),
      GoRoute(
      path: '/mine',
      builder: (context, state) => const PackageMine(),
    ),
  ],
);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _toNative = true;

  late MethodChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = const MethodChannel('multiple-flutters');
    _channel.setMethodCallHandler((call) async {
      if (call.method == "setCount") {
        // A notification that the host platform's data model has been updated.
        setState(() {
          _counter = call.arguments as int? ?? 0;
        });
      } else {
        throw Exception('not implemented ${call.method}');
      }
    });
  }

  void _incrementCounter() {
    // Mutations to the data model are forwarded to the host platform.
    _channel.invokeMethod<void>("incrementCount", _counter);
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              YCNavigator().pop();
            },
        )
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Switch(value: _toNative, onChanged: (state){
                  setState(() {
                    _toNative = state;
                  });
            }),
            TextButton(onPressed: (){
              // context.go('/users/123');
              YCNavigator().push( '/accounts', toNative: _toNative);
            }, child:  Text('跳转到账户模块 toNative $_toNative')),

            TextButton(onPressed: (){
              // context.go('/users/123');
              YCNavigator().push( '/mine', toNative: _toNative);
            }, child:  Text('跳转到账户模块 toNative $_toNative'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
