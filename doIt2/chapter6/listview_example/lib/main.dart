import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),

      //iPhone Design 화면
      home: CupertinoMain(),

      //Android Design 화면
      //home: MyHomePage(title: "안드스타일"),
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  List<Animal> animalList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    // debugPrint("$Platform.isIOS");
    // if (Platform.isIOS) {
    //   //iOS

    // } else if (Platform.isAndroid) {
    //   //Android
    // }

    controller = TabController(length: 2, vsync: this);
    animalList.add(
        Animal(animalName: "벌", kind: "곤충", imagePath: "repo/images/bee.png"));
    animalList.add(Animal(
        animalName: "고양이", kind: "포유류", imagePath: "repo/images/cat.png"));
    animalList.add(Animal(
        animalName: "젖소", kind: "포유류", imagePath: "repo/images/cow.png"));
    animalList.add(Animal(
        animalName: "강아지", kind: "포유류", imagePath: "repo/images/dog.png"));
    animalList.add(Animal(
        animalName: "여우", kind: "포유류", imagePath: "repo/images/fox.png"));
    animalList.add(Animal(
        animalName: "원숭이", kind: "영장류", imagePath: "repo/images/monkey.png"));
    animalList.add(Animal(
        animalName: "돼지", kind: "포유류", imagePath: "repo/images/pig.png"));
    animalList.add(Animal(
        animalName: "늑대", kind: "포유류", imagePath: "repo/images/wolf.png"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Listview Example'),
        ),
        body: TabBarView(
          controller: controller,
          children: <Widget>[
            FirstApp(list: animalList),
            SecondApp(list: animalList)
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: const <Tab>[
            Tab(icon: Icon(Icons.home, color: Colors.blue)),
            Tab(icon: Icon(Icons.add, color: Colors.blue))
          ],
          controller: controller,
        ));
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
