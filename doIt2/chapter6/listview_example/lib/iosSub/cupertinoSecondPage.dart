import 'dart:ffi';

import 'package:flutter/cupertino.dart';

import '../animalItem.dart';

class CupertinoSecondPage extends StatefulWidget {
  final List<Animal> animalList;

  const CupertinoSecondPage({Key? key, required this.animalList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CupertinoSecondPage();
  }
}

class _CupertinoSecondPage extends State<CupertinoSecondPage> {
  TextEditingController? _textController;
  int _kindChoice = 0;
  bool _flyExist = false;
  String? _imagePath;
  bool _changeFlag = false;
  int? _changeIndex;

  Map<int, Widget> segmentWidgets = {
    0: const SizedBox(width: 80, child: Text('양서류', textAlign: TextAlign.center)),
    1: const SizedBox(width: 80, child: Text('포유류', textAlign: TextAlign.center)),
    2: const SizedBox(width: 80, child: Text('파충류', textAlign: TextAlign.center))
  };

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    //farmer
    //아래 if문장이 여기에 있는이유
    // 1. 사실 아래if문장은 confirm method를 sync로 만들거나, callback함수를 이용해서
    //    아래 script를 그곳에 위치시켜야 한다.
    // 2. confirm창에서 결과를 받아 sync로 개발해야 되는데 아직skil이 부족해
    //    그곳에서 하지 못하고 아래 script부분에서 처리 했음
    if (_changeFlag == true) {
      debugPrint("변경되었당...$_imagePath::$_changeIndex");
      widget.animalList[_changeIndex!].kind = getKind(_kindChoice);
      widget.animalList[_changeIndex!].imagePath = _imagePath!;
      widget.animalList[_changeIndex!].flyExist = _flyExist;
      _changeFlag = false;
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('동물 추가'),
      ),
      child: Container(
        child: Center(
          child: Column(
            // ignore: sort_child_properties_last
            children: <Widget>[
              const Text("동물이름"),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CupertinoTextField(
                  controller: _textController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              CupertinoSegmentedControl(
                  padding: const EdgeInsets.only(bottom: 20, top: 20),
                  groupValue: _kindChoice,
                  children: segmentWidgets,
                  onValueChanged: (int? value) {
                    setState(() {
                      _kindChoice = value!;
                    });
                  }),
              Row(
                // ignore: sort_child_properties_last
                children: <Widget>[
                  const Text('날개가 존재합니까?'),
                  CupertinoSwitch(
                      value: _flyExist,
                      onChanged: (value) {
                        setState(() {
                          _flyExist = value;
                        });
                      })
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Container(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      child: Image.asset('repo/images/cow.png', width: 80),
                      onTap: () {
                        _imagePath = 'repo/images/cow.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset('repo/images/pig.png', width: 80),
                      onTap: () {
                        _imagePath = 'repo/images/pig.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset('repo/images/bee.png', width: 80),
                      onTap: () {
                        _imagePath = 'repo/images/bee.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset('repo/images/cat.png', width: 80),
                      onTap: () {
                        _imagePath = 'repo/images/cat.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset('repo/images/fox.png', width: 80),
                      onTap: () {
                        _imagePath = 'repo/images/fox.png';
                      },
                    ),
                    GestureDetector(
                      child: Image.asset('repo/images/monkey.png', width: 80),
                      onTap: () {
                        _imagePath = 'repo/images/monkey.png';
                      },
                    ),
                  ],
                ),
              ),
              CupertinoButton(
                  child: const Text('동물 추가하기'),
                  onPressed: () {
                    //farmer
                    addAnimalList();
                    // widget.animalList.add(Animal(
                    //     animalName: _textController!.value.text,
                    //     kind: getKind(_kindChoice),
                    //     imagePath: _imagePath!,
                    //     flyExist: _flyExist));
                  })
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  getKind(int kindChoice) {
    switch (kindChoice) {
      case 0:
        return "양서류";
      case 1:
        return "파충류";
      case 2:
        return "포유류";
    }
  }

  //farmer
  //동물추가하기
  void addAnimalList() {
    //1. 기존에 존재 하는 지 검사
    String addAnimalName = _textController!.value.text;
    bool isExist = false;
    int idx = 0;

    if (addAnimalName == null || addAnimalName == "") {
      cupertinoDialog("동물이름을 입력하십시오.");
      return;
    }
    if (_imagePath == null || _imagePath == "") {
      cupertinoDialog("동물이미지를 선택하십시오.");
      return;
    }

    for (var one in widget.animalList) {
      if (one.animalName == addAnimalName) {
        isExist = true;
        //showAlertDialog("해당 동물($addAnimalName)은 이미 존재 합니다.");
        showAlertDialog(title: '확인', content: "해당 동물은 이미 존재 합니다.\n변경하시겠습니까?", idx: idx);
        debugPrint("dialog end");
        // _changeIndex = idx;
        return;
      }
      idx++;
    }

    //farmer
    //2. 동물 추가
    if (isExist == false) {
      widget.animalList.add(Animal(
          animalName: _textController!.value.text,
          kind: getKind(_kindChoice),
          imagePath: _imagePath!,
          flyExist: _flyExist));
    }
  }

  //farmer
  //기존동물 내용 변경 Confirm
  void showAlertDialog(
      {
      //required BuildContext context,
      required String title,
      required String content,
      required int idx}) async {
    var rtn = await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          //if (cancelActionText != null)
          CupertinoDialogAction(
            child: const Text("취소"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            child: const Text("변경"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    //    debugPrint("rtn=$rtn");

    //farmer
    //[변경]선택 시 -> 동물내용 변경
    setState(() {
      _changeFlag = rtn;
      _changeIndex = idx;
    });
  }

  void cupertinoDialog(String msg) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(msg),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}
