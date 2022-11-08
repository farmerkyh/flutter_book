//as 사용시 해당api들은 모두 convert.api 형식으로 사용해야 된다.
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HttpApp();
}

/* 수행순서
	//1. 시작시
  initState
	build
	
	//2. 값이 없을 경우
	onPressed
	build
	
	//3. 값이 존재 시
	onPressed
	build
	(10회)ListView.builder   (화면 height따라 횟수가 틀림)
	
	//4. scroll수행시
	bottom
	build
	(10회)ListView.builder   (화면 height따라 횟수가 틀림)
*/
class _HttpApp extends State<HttpApp> {
  String result = '';
  TextEditingController? _editingController;
  ScrollController? _scrollController;
  List? data;
  int page = 1;

  @override
  void initState() {
    debugPrint("initState");
    super.initState();
    //List.empty()에 method에 의해서 [] 와 같은 빈 객체를 넘겨준다.
    //  이로 인해 data! 와 같이 null이 아니다 라고 명시할 수 있게 된다.
    data = new List.empty(growable: true);
    debugPrint("init data = ${data}");
    _editingController = new TextEditingController();
    _scrollController = new ScrollController();

/*
   - position.offset          : 스크롤 위치 감지
   - position.pixels          : 축 방향의 반대 방향으로 움직일 수 있는 픽셀 수 이다.
   - position.minScrollExtent : 스크롤 맨 위
   - position.maxScrollExtent : 픽셀의 최대값이다 (스크롤 할 수 있는 최대 픽셀).
                                스크롤 맨 밑
   - position.userScrollDirection: 사용자가 변경하려고 하는 방향이다.
   - position.outOfRange        :  정의된 부위를 넘어갔는지 확인한다
*/

    //화면을 사용자가 scroll할 때 하단에 도달 했지만 아래 event가 수행 안될 수 도 있다.
    //그 이유는 : ListView.builder 가 아직 화면에 그리지 않은 List가 남아 있다면
    //           그리지 않은 List의 값을 먼저 그리기 때문이다.
    _scrollController!.addListener(() {
      if (_scrollController!.offset >=
              _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        debugPrint('bottom');
        page++;
        getJSONData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build");
    // ignore: todo
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _editingController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(hintText: '검색어를 입력하세요'),
        ),
      ),
      body: Container(
        child: Center(
          child: data!.length == 0
              ? const Text(
                  '데이터가 존재하지 않습니다.\n검색해주세요',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )
              //ListView.builder는 화면 height에 맞게 ListView갯수를 그린다.
              //  - 즉, 자료가 100건이 존재 해도 화면height의 해서 5건만 조회할 수 있다면
              //        약 7건정도 그린다. 화면 height보다 약 2~3건 더 미리 그린다.
              : ListView.builder(
                  itemBuilder: (context, index) {
                    debugPrint("ListView.builder");
                    //debugPrint(data![index]['thumbnail']);
                    return Card(
                      child: Container(
                        child: Row(
                          // https://it-jm.tistory.com/121
                          // 아래 - [mainAxisAlignment: MainAxisAlignment.start,] 이 문장을 이동시키면 ignore 살아짐
                          // ignore: sort_child_properties_last
                          children: <Widget>[
                            if (data?[index]['thumbnail'] != '')
                              Image.network(
                                data![index]['thumbnail'],
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                              )
                            else
                              Container(
                                height: 100,
                                width: 100,
                              ),
                            Column(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    data![index]['title'].toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Text(
                                    '저자 : ${data![index]['authors'].toString()}'),
                                Text(
                                    '가격 : ${data![index]['sale_price'].toString()}'),
                                Text(
                                    '판매중 : ${data![index]['status'].toString()}'),
                              ],
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                      ),
                    );
                  },
                  itemCount: data!.length,
                  controller: _scrollController,
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("onPressed");
          page = 1;
          data!.clear();
          getJSONData();
        },
        child: Icon(Icons.search),
      ),
    );
  }

  Future<String> getJSONData() async {
    var url =
        'https://dapi.kakao.com/v3/search/book?target=title&page=$page&query=${_editingController!.value.text}';

    var response = await http.get(Uri.parse(url),
        headers: {"Authorization": "KakaoAK 0e02d12ca8a37f52b08cc82358074bbc"});

    //debugPrint(response.body); // 검색 결과 로그창으로 확인

    setState(() {
      debugPrint("getJSONData");
      //- 검색어가 null일 경우 아래 값이 return됨
      //    response.body=={"errorType":"MissingParameter","message":"query parameter required"}
      //- 결과가 0 건이면 아래와 같은 값이 return됨
      //    response.body=={"documents":[],"meta":{"is_end":true,"pageable_count":0,"total_count":0}}
      //
      //- convert.json.decode(null) 일 경우 아래와 같은 오류 발생
      //    Unhandled Exception: type 'Null' is not a subtype of type 'List<dynamic>'
      //debugPrint("response.body==${response.body}");
      var dataConvertedToJSON = convert.json.decode(response.body);

      List result = dataConvertedToJSON['documents'];
      //debugPrint("result==${result}");
      data!.addAll(result);
    });
    return response.body;
  }
}
