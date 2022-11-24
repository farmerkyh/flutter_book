import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ffi';
import 'animalItem.dart';
import 'cupertinoMain.dart';
import 'sub/firstPage.dart';
import 'sub/secondPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),

      //iPhone Design 화면
      //home: CupertinoMain(),

      //Android Design 화면
      home: MyHomePage(title: "안드스타일"),
    );
  }
}

//------------------------------------------------------
// android용 Design
//------------------------------------------------------
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  TabController? controller;
  List<Animal> animalList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listview Example'),
      ),
      body: PlatformWidget(
        //cupertino: (context, platform) => const Icon(CupertinoIcons.flag),
        //material: (_, __) => const Text("Flag (PlatformWidget)"),

        material: (_, __) => Text('material'),
        cupertino: (context, platform) => Text('cupertino'),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
