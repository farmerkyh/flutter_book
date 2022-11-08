//Name source files using 'lowercase_with_underscores'.dartfile_names
//  - 소스파일명이 largeFileMain.dart와 같을 경우 위와 같은 warning 발생
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class LargeFileMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LargeFileMain();
}

/*
1. App실행시
   - initState
   - waiting
   - done
2. 다운로드 버튼 클릭시
   - onPressed
   - download Start
     : 이 중간에 다운로드 조각size만큼 onReceiveProgress callback이 호출됨
     : 이로 인해 build method가 계속 수행 됨
   - download end
   - Download completed
   - waiting
   - done
*/
class _LargeFileMain extends State<LargeFileMain> {
  bool downloading = false;
  var progressString = "";
  String? file = "";

  TextEditingController? _editingController;

  @override
  void initState() {
    debugPrint("initState");
    super.initState();
    //https://www.motherjones.com/wp-content/uploads/2019/12/Getty121719.jpg?w=1200&h=630&crop=1
    _editingController = TextEditingController(
        text:
            'https://www.motherjones.com/wp-content/uploads/2022/09/mojo_cover_novdec22.jpg?w=1200&h=630&crop=1');
  }

  //Future : 미래에 구체적인 결과물로 실제적인 객체로 반환된다는 의미
  Future<void> downloadFile() async {
    debugPrint('download Start');
    Dio dio = Dio();
    try {
      //getApplicationDocumentsDirectory
      //  - 앱에서만 엑세스 할 수 있는 지정된 경로(보통:/data/user/0/패키지 이름/app_flutter)
      //  - windows에서 수행시 : C:\Users\kyh\Documents
      var dir = await getApplicationDocumentsDirectory();

      //onReceiveProgress
      //   - 일정한 파일 size만큼씩 다운로드가 되는데, 이 특정 파일 size만큼 download가 될때 마다
      //     onReceiveProgress callback 이 수행된다.
      await dio
          .download(_editingController!.value.text, '${dir.path}/myimage.jpg',
              onReceiveProgress: (rec, total) {
        //debugPrint('Rec: $rec , Total: $total');
        file = '${dir.path}/myimage.jpg';

        //setState()에 의해서  특정size만큼 image가 받아지면
        //    build() method가 다시 수행되어 progressbar 및 진행률이 표시된다.
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
        });
      });
      debugPrint('download end');
      //download가 완료 되어야 위 객체가 종료되고, 다음script가 수행된다.
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      downloading = false;
      progressString = 'Completed';
    });
    debugPrint('Download completed');
  }

  //build() method는 downloadFile().dio.download(onReceiveProgress --> callback 이 수행되는 횟수만큼 수행 된다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _editingController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(hintText: 'url 입력하세요'),
        ),
      ),
      body: Center(
          child: downloading
              //--------------------------------------------------------
              // download 진행상황을 보여준다.
              //--------------------------------------------------------
              ? Container(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const CircularProgressIndicator(),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          //downloadFile() method의해서 변경된 진행율을 보여준다.
                          'Downloading File: $progressString',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                )

              //--------------------------------------------------------
              // download 가 완료 되었을 경우 수행됨
              //    - downloading = false상태
              //    - 이미지 파일이 이제 존재 함
              //--------------------------------------------------------
              : FutureBuilder(
                  //snapshot.data는 downloadWidget(file)함수가 반환하는 데이터이다.
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {

                      //none : FutureBuilder.future가 null일 때
                      case ConnectionState.none:
                        debugPrint('none');
                        return const Text('데이터 없음');

                      //waiting : 연결되기 전. FutureBuilder.future에서 데이터를 반환받지 않았을 때
                      case ConnectionState.waiting:
                        debugPrint('waiting');
                        return const CircularProgressIndicator();

                      //active : 하나 이상의 데이터를 반환받을 때
                      case ConnectionState.active:
                        debugPrint('active');
                        return const CircularProgressIndicator();

                      //done : 모든 데이터를 받아서 연결이 끝날 때
                      case ConnectionState.done:
                        debugPrint('done');
                        if (snapshot.hasData) {
                          return snapshot.data as Widget;
                        }
                    }
                    return const Text('데이터 없음');
                  },
                  future: downloadWidget(file!),
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('onPressed');
          downloadFile(); //download하는 method수행
        },
        child: const Icon(Icons.file_download),
      ),
    );
  }

  //downloadWidget : 이미지 파일이 있는지 확인해서 있으면 이미지를 화면에 보여주는  widget을 반환하고
  //                 없으면 "No Data"라는 텍스트 반환
  Future<Widget> downloadWidget(String filePath) async {
    File file = File(filePath);
    bool exist = await file.exists();
    FileImage(file).evict(); //evict : 캐시 초기화하기
    if (exist) {
      return Center(
        child: Column(
          children: <Widget>[Image.file(file)],
        ),
      );
    } else {
      return const Text('No Data');
    }
  }
}
