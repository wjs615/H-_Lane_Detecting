function [c0_L, c0_R, c1_L, c1_R, detect_offset_l,detect_offset_r]  = fcn(u, u1, u2, u3)
% Simulink의 video viewer에서는 픽셀값으로만 출력됨.
% 픽셀간 거리와 view range 간 비례하게 조정했음
% 90/491의 90 : 앞 차와의 임의 거리, 491 : 카메라 위치 센터 픽셀 값(961,1080)과 앞 차 타이어와 지면이 닿는
% 픽셀 값의 차

%% Left side

dist_l = sqrt(complex(u(1)-u1(1))^2+complex(u(2)-u1(2))^2);
dist_y_l = complex(u3(1) - u1(1))/2;

detect_dist_l = sqrt(complex(dist_l)^2-complex(dist_y_l)^2)*90/491;        % x-axis detect range_left-side
detect_angle_l = acos(detect_dist_l/(dist_l*90/491));
c0_L = detect_dist_l;                                                      % c0 왼쪽 - detect_dist_l : 
c1_L = tan(detect_angle_l)-0.355;                                          % c0 왼쪽 - 카메라 주행차로 왼쪽 차선 tan(방향값) - tan(각도보정값)

% Y_offset
detect_offset_l = -(((1920/2)-u1(1))*90/491*0.45/10*0.8+0.3);              % 카메라 주행차로 왼쪽 차선 인식 횡방향 오프셋 보정 값 (-)

%% Right side
dist_r = sqrt(complex(u2(1)-u3(1))^2+complex(u2(2)-u3(2))^2);
dist_y_r = dist_y_l;                                                       % complex(u3(1) - u1(1))/2

detect_dist_r = sqrt(complex(dist_r)^2-complex(dist_y_r)^2)*90/491;        % x-axis detect range_right-side
detect_angle_r = acos(detect_dist_r/(dist_r*90/491));
c0_R = detect_dist_r;                                                      % view range 오른쪽 
c1_R = tan(detect_angle_r)-0.368;                                          % c0 오른쪽 - 카메라 주행차로 오른쪽 차선 tan(방향값) - tan(각도보정값)

% Y_offset
detect_offset_r = 3.3+detect_offset_l;                                     % 카메라 주행차로 오른쪽 차선 인식 횡방향 오프셋 보정 값 (도로 폭 3.3m)

end
