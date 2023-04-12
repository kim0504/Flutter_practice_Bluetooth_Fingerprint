## 블루투스를 사용한 실내 측위 앱
- **기간**  : 2021.09 ~ 2021.11
- **주제**  : flutter_blue 패키지를 사용해 블루투스를 이용한 핑거프린트 기법으로 실내 측위 구현를 위한 테스트 앱
- **유형**  : 앱 개발
- **개발**  : Android Studio, Flutter, Dart

## 메인화면 (구성 수정 필요)
### - scan
사용할 값들만 스캔해서 리스트에 저장하는 기능<br>
(매우 필요) 8~10번 연속적으로 받을 수 있게 수정 필요
### - info
scan에서 받은 값의 정보를 print
### - text 입력란
저장할 rssi 값의 공간의 명칭 설정 
### - save rssi
지금까지 측정한 rssi값을 내부 파일에 저장<br>
포맷: []{location name}:{rssi};{rssi};{rssi}
### - listview
내부 파일의 값을 리스트뷰로 출력<br>
(덜 필요) 내부 파일을 수정, 삭제할 수 있게 수정 필요
### - predict
내부 파일의 값과 현재 rssi값의 MSE 계산 후 예측값 출력<br>
(매우 필요) 실시간으로 받을 수 있게 수정 필요
### - example (이름 수정 필요)
기기로 들어오는 모든 디바이스들 값을 리스트뷰로 출력<br>
(매우 필요) 체크박스로 원하는 디바이스 선택 후 scan 기능 사용하게 수정 필요
## 소개
![슬라이드1](https://user-images.githubusercontent.com/81956540/230839970-d603abf2-e5dd-46e6-abd0-a9bc8c72ef1f.PNG)
![슬라이드2](https://user-images.githubusercontent.com/81956540/230839992-2843415b-c939-494d-9c6a-7304d0ab6551.PNG)
![슬라이드3](https://user-images.githubusercontent.com/81956540/230840004-dec5c541-f0af-400c-a2b4-2a179197b6d8.PNG)
