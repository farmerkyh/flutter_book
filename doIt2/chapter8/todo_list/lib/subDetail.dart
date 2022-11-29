import 'package:flutter/material.dart';

class SubDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SubDetail();
}

class _SubDetail extends State<SubDetail> {
  List<String> todoList = new List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    todoList.add('당근 사오기');
    todoList.add('약 사오기');
    todoList.add('청소하기');
    todoList.add('부모님께 전화드리기');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub Detail - To.do list'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            //InkWell
            //  - 탭, 더블탭, 롱탭 등 다양한 터치 이벤트를 처리 할 수 있는 Widget이다.
            child: InkWell(
              child: Text(
                todoList[index],
                style: TextStyle(fontSize: 30),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/third', arguments: todoList[index]);
              },
            ),
          );
        },
        itemCount: todoList.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNavigation(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNavigation(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed('/second');
    //if (result != null && result != '') {
      
    setState(() {
      todoList.add(result as String);
    });
    //}
  }
}
