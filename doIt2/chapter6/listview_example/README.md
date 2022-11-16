# 6장. Cupertino

## 1. Cupertino 명명
<img src="./README_images/cupertino_100.png">

## 2. Cupertino 정의
#### 1. Material
 - Material 디자인은 Android에 적용하기 위해 Google이 만든 디자인 규칙이다
#### 2. Cupertino 
 - iPhone스러운 디자인을 적용하기 위해 Cupertino 디자인을 Google에서 만들었다.

#### 3. 왜?
## 3. Cupertino 분류
 - 1. Cupertino icon
 - 2. Cupertino widget

## 4. Cupertino icon
#### 1. Material icons
```dart
 - https://fonts.google.com/icons?selected=Material+Icons
   . style적용 후
   . download 2가지 (svg, png) type 으로 download가능
   . svg : SVG는 Scalable Vector Graphics라는 뜻인데, 번역하자면 확장가능한 벡터 그래픽이다. 
           픽셀을 이용하여 그림을 그리는 png jpg 파일들과 다르게 벡터를 기반으로 이미지를 표현한다. 
           그러다보니 크기를 조절함에 따라 깨지는 것이 없고, 
           용량이 작기 때문에 웹에서 자주 사용하는 이미지 형식이다.
   . png : Portable Network Graphics의 약자로 무손실압축 방식에 32비트 트루컬러 처리가 가능한 그래픽 형식이다.
 - flutter에서 바로 사용가능 
```
#### 2. Cupertino icons
   - https://pub.dev/packages/cupertino_icons
   - https://api.flutter.dev/flutter/cupertino/CupertinoIcons-class.html#constants

#### 3. Cupertino icon Library 사용하기
```dart
 - pubspec.yaml
   cupertino_icons: ^1.0.2   : default로 추가되어져 있음 
```

#### 3. Cupertino/Material icons 비교
<img src="./README_images/cupertino_110.png">

## 5. Cupertino Widget
#### 1. Widget 목록
 - 현재 약 183개 존재 (Widget + Api)
<img src="./README_images/cupertino_120.png">

<img src="./README_images/cupertino_130.png">

#### 2. Widget 화면
 - Material Widget
 . https://docs.flutter.dev/development/ui/widgets/material

 - Cupertino Widget
  . https://docs.flutter.dev/development/ui/widgets/cupertino

## 7. 

skia 엔진?????

os 비교