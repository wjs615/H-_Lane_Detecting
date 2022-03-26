# HMC_ComVeh_Lane_Detecting
현대자동차 상용전자제어시험팀 주행환경모델 개발 </br>
가상 주행환경 구축 프로그램인 PreScan과 연동한 MATLAB/Simulink 스크립트 (스크립트 파일 : *.m)

## Lane_Detecting_func

> 
> 
> > ### 1. Image Processing Subsystem (HMC_Lane_detect.slx)
> >
> > - #### Subsystem mask (mask.m)
> >   ![image](https://user-images.githubusercontent.com/36038244/147513933-03ec2a25-fe72-4565-abab-a85dd9e4752d.png) <br>
> >   (1) Image Processing Subsystem을 더블클릭하면 카메라 픽셀 입력할 수 있도록 설정 <br>
> >   (2) 픽셀 기본 값은 [800 * 600] 픽셀로 지정 <br>
> >   (3) 카메라 픽셀을 입력하면 기본 픽셀 값 환산하여 Image Processing Subsystem에서 계산 <br>
> >   (4) PreScan 차량 카메라 높이를 조절하는 경우 mask.m 파일의 2번 라인 numRows의 0.54 값을 조정하여 사용 가능 <br>
> > 
> > - #### Lane_offset_angle_distance.m <br>
> >   (1) 픽셀단위로 출력되는 PreScan 카메라 데이터를 거리 단위로 환산<br>
> >   (2) 거리 단위 환산 후 전방 인식 거리 (View Range), 차선 / 바퀴 사이의 거리 (Lane_offset), 차 중앙 / 차선 사이 각 (angle)을 DSA 제어기가 판단할 수 있도록 스크립트 작성 (인지 부분에 해당)<br>
> >   (3) HMC_Lane_detect - Subsystem1 – output – Subsystem – Draw Polygon – Line to Polygon Coordinates
> >   ![image](https://user-images.githubusercontent.com/36038244/160238851-6be2f542-7e04-4365-bd63-69c831b07ad9.png)
> >  
> > - #### DetectColorAndType.m <br>
> >   (1) 차선 색상 (흰색, 주황색, 파란색), 차선 종류 (실선, 점선)으로 구성 <br>
> >   (2) 차선 색상 : 카메라 이미지 RGB 색상에서 Y'Cb'Cr' 색차를 이용한 차선 색상 구분
> >   (3) 차선 종류 : 차선 색상 픽셀 정보를 이용하여 비율이 0.4 초과일 경우 실선, 아닐경우 점선으로 인식</br>
> >   ![image](https://user-images.githubusercontent.com/36038244/160238898-7a58f12e-affc-4559-8507-a8c14610f100.png)
>
> ### 2. Lane_Color_recognize_function<br>
> > - #### Lane_Color.m <br>
> >   (1) Image Processing Subsystem의 Lane_offset_angle_distance 스크립트의 output 변수를 바탕으로 인식 <br>
> >   (2) 왼쪽 차선, 오른쪽 차선 나누어 인식 <br>
> >   (3) CAN 신호 전송으로 DSA 제어기가 판단할 수 있도록 인지 부분에 해당하는 역할 수행 <br>
> 
> ### 3. Lane_Type_recognize_function<br>
> > - #### Lane_Type.m <br>
> >   (1) Image Processing Subsystem의 Lane_offset_angle_distance 스크립트의 output 변수를 바탕으로 인식 <br>
> >   (2) 왼쪽 차선, 오른쪽 차선 나누어 인식 <br>
> >   (3) CAN 신호 전송으로 DSA 제어기가 판단할 수 있도록 인지 부분에 해당하는 역할 수행 <br>

## automation (automation.m)
> 가상 주행환경 시나리오 자동화 MATLAB 스크립트
> 
> ![image](https://user-images.githubusercontent.com/36038244/147514704-497a5525-6f46-42df-81c7-640672a26b7c.png)
>
> (1) PreScan으로 생성한 여러개의 시나리오 폴더들이 있는 상위 폴더를 basepath로 입력 <br>
> (2) 5번 라인의 for iDir = 3:numel(DirList)의 3 - matlab에서 dir 명령어로 폴더 리스트 확인 시 ., .., SCC_Gen_01, SCC_Gen_02, ....,와 <br> 
> 같이 진행되므로 실제 폴더는 3번 행부터 시작 <br>
> (3) 10 ~ 16번 라인의 Battery_Ign_on.slx, Battery_Ign_off.slx를 이용해 시나리오 연속 실행 시 변수 값 초기화 <br><br>
> ![image](https://user-images.githubusercontent.com/36038244/147514886-0905b543-a404-400c-b9b3-971f0bb5925d.png) <br>
> ![image](https://user-images.githubusercontent.com/36038244/147514856-c9e5d80e-3e8e-456a-8677-5c4fe86d6416.png) <br>
> (4) 18 ~ 99번 라인의 PreScan CLI (Command Line Interface) 명령어를 이용해 automation.m 스크립트 실행 시 PreScan CLI로 해당 시나리오 생성 및 Simulink에서 시나리오 실행될 수 있도록 함 <br><br>
> (5) 100 ~ 643번 라인 : 시나리오 종료 후 Yaw rate, velocity, acceleration 등의 차량 정보를 저장하기 위해 To workspace Simulink 블럭을 사용해 matlab workspace에 저장 <br>
> (6) matlab workspace로 저장된 차량 정보 데이터들을 엑셀 데이터로 변환하여 데이터 가시성 확보

