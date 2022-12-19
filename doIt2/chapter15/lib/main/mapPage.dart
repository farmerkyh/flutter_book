import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:modu_tour/data/tour.dart';
import 'package:modu_tour/data/listData.dart';
import 'package:sqflite/sqflite.dart';

import 'tourDetailPage.dart';

class MapPage extends StatefulWidget {
  final DatabaseReference databaseReference; // 실시간 데이터베이스 변수
  final Future<Database> db; // 내부에 저장되는 데이터베이스
  final String id; // 로그인한 아이디
  MapPage({this.databaseReference, this.db, this.id});

  @override
  State<StatefulWidget> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  List<DropdownMenuItem> list = List();
  List<DropdownMenuItem> sublist = List();
  List<TourData> tourData = List();
  ScrollController _scrollController;
  String authKey = '### 오픈 API 키(일반 인증키) ###';
  Item area;
  Item kind;
  int page = 1;

  @override
  void initState() {
    super.initState();
    list = Area().seoulArea;
    sublist = Kind().kinds;
    area = list[0].value;
    kind = sublist[0].value;
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        page++;
        getAreaList(area: area.value, contentTypeId: kind.value, page: page);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색하기'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  DropdownButton(
                    items: list,
                    onChanged: (value) {
                      Item selectedItem = value;
                      setState(() {
                        area = selectedItem;
                      });
                    },
                    value: area,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    items: sublist,
                    onChanged: (value) {
                      Item selectedItem = value;
                      setState(() {
                        kind = selectedItem;
                      });
                    },
                    value: kind,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      page = 1;
                      tourData.clear();
                      getAreaList(area: area.value, contentTypeId: kind.value, page: page);
                    },
                    child: Text(
                      '검색하기',
                      style: TextStyle(color: Colors.white),
                    ),
                    //color: Colors.blueAccent,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceAround,
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      child: Row(
                        children: <Widget>[
                          Hero(
                              tag: 'tourinfo$index',
                              child: Container(
                                  margin: EdgeInsets.all(10),
                                  width: 100.0,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black, width: 1),
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: tourData[index].imagePath != null
                                              ? NetworkImage(tourData[index].imagePath)
                                              : AssetImage('repo/images/map_location.png'))))),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  tourData[index].title,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text('주소 : ${tourData[index].address}'),
                                tourData[index].tel != null ? Text('전화 번호 : ${tourData[index].tel}') : Container(),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            ),
                            width: MediaQuery.of(context).size.width - 150,
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TourDetailPage(
                                  id: widget.id,
                                  tourData: tourData[index],
                                  index: index,
                                  databaseReference: widget.databaseReference,
                                )));
                      },
                      onDoubleTap: () {
                        insertTour(widget.db, tourData[index]);
                      },
                    ),
                  );
                },
                itemCount: tourData.length,
                controller: _scrollController,
              ))
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        ),
      ),
    );
  }

  void insertTour(Future<Database> db, TourData info) async {
    final Database database = await db;
    await database.insert('place', info.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      //Scaffold.of(context).showSnackBar(SnackBar(content: Text('즐겨찾기에 추가되었습니다')));
      SnackBarAction(label: '즐겨찾기에 추가되었습니다');
    });
  }

  void getAreaList({int area, int contentTypeId, int page}) async {
    var url =
        'http://api.visitkorea.or.kr/openapi/service/rest/KorService/areaBasedList?ServiceKey =$authKey & MobileOS = AND & MobileApp = ModuTour &_type = json & areaCode = 1 & sigunguCode = $area & pageNo = $page';
    if (contentTypeId != 0) {
      url = url + '&contentTypeId=$contentTypeId';
    }
    var response = await http.get(url);
    String body = utf8.decode(response.bodyBytes);
    print(body);
    var json = jsonDecode(body);
    if (json['response']['header']['resultCode'] == "0000") {
      if (json['response']['body']['items'] == '') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('마지막 데이터 입니다'),
              );
            });
      } else {
        List jsonArray = json['response']['body']['items']['item'];
        for (var s in jsonArray) {
          setState(() {
            tourData.add(TourData.fromJson(s));
          });
        }
      }
    } else {
      print('error');
    }
  }
}
