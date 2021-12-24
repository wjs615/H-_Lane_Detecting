function [c0_L, c0_R, c1_L, c1_R, detect_offset_l,detect_offset_r]  = fcn(u, u1, u2, u3)
% Simulink�� video viewer������ �ȼ������θ� ��µ�.
% �ȼ��� �Ÿ��� view range �� ����ϰ� ��������
% 90/491�� 90 : �� ������ ���� �Ÿ�, 491 : ī�޶� ��ġ ���� �ȼ� ��(961,1080)�� �� �� Ÿ�̾�� ������ ���
% �ȼ� ���� ��

%% Left side

dist_l = sqrt(complex(u(1)-u1(1))^2+complex(u(2)-u1(2))^2);
dist_y_l = complex(u3(1) - u1(1))/2;

detect_dist_l = sqrt(complex(dist_l)^2-complex(dist_y_l)^2)*90/491;        % x-axis detect range_left-side
detect_angle_l = acos(detect_dist_l/(dist_l*90/491));
c0_L = detect_dist_l;                                                      % c0 ���� - detect_dist_l : 
c1_L = tan(detect_angle_l)-0.355;                                          % c0 ���� - ī�޶� �������� ���� ���� tan(���Ⱚ) - tan(����������)

% Y_offset
detect_offset_l = -(((1920/2)-u1(1))*90/491*0.45/10*0.8+0.3);              % ī�޶� �������� ���� ���� �ν� Ⱦ���� ������ ���� �� (-)

%% Right side
dist_r = sqrt(complex(u2(1)-u3(1))^2+complex(u2(2)-u3(2))^2);
dist_y_r = dist_y_l;                                                       % complex(u3(1) - u1(1))/2

detect_dist_r = sqrt(complex(dist_r)^2-complex(dist_y_r)^2)*90/491;        % x-axis detect range_right-side
detect_angle_r = acos(detect_dist_r/(dist_r*90/491));
c0_R = detect_dist_r;                                                      % view range ������ 
c1_R = tan(detect_angle_r)-0.368;                                          % c0 ������ - ī�޶� �������� ������ ���� tan(���Ⱚ) - tan(����������)

% Y_offset
detect_offset_r = 3.3+detect_offset_l;                                     % ī�޶� �������� ������ ���� �ν� Ⱦ���� ������ ���� �� (���� �� 3.3m)

end
