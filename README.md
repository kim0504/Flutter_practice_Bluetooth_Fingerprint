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
