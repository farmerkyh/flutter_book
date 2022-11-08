import 'package:flutter/material.dart';

import 'imageWidget.dart';

void main() => runApp(MyApp());

/* Run:실행시키면 아래와 같은 오류 발생. 
   플젝을 신규 생성 후 소스만 copy해서 정상 수행 시킴
Your Flutter application is created using an older version of the Android
embedding. It is being deprecated in favor of Android embedding v2. Follow the
steps at
https://flutter.dev/go/android-project-migration
to migrate your project. You may also pass the --ignore-deprecation flag to
ignore this check and continue with the deprecated v1 embedding. However,
the v1 Android embedding will be removed in future versions of Flutter.
*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageWidgetApp(),
    );
  }
}

class MaterialFlutterApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MaterialFlutterApp();
  }
}

class _MaterialFlutterApp extends State<MaterialFlutterApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Design App'),
      ),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: () {}),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[Icon(Icons.android), Text('android')],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
