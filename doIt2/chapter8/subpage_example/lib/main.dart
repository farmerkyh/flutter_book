import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Widget Example';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),

      /* 
        MaterialApp(..initialRoute,..)   MaterialApp(..MaterialApp(routes,..)  (https://flutter-ko.dev/docs/cookbook/navigation/named-routes)
          - initialRoute 프로퍼티는 앱의 시작점을 나타내는 route를 정의하고, 
            routes 프로퍼티는 이용가능한 named route와 해당 route로 이동했을 때 빌드될 위젯을 정의함.
          - 전환방법은 : Navigator.pushNamed(context, '/routes에 정의한 이름');
      */
      initialRoute: '/',
      routes: {
        '/': (context) => FirstPage(),
        '/second': (context) => SecondPage()
      },
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sub Page Main'),
      ),
      body: Container(
        child: const Center(
          child: Text('첫 번째 페이지'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Named route를 사용하여 두 번째 화면으로 전환한다.
          Navigator.of(context).pushNamed('/second');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              // 현재 route를 스택에서 제거함
              Navigator.of(context).pop();
            },
            child: Text('돌아가기'),
          ),
        ),
      ),
    );
  }
}
