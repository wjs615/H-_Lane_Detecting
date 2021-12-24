function [y, y1] = fcn(u)

y = u(1);                                                                  % 왼쪽 차선 종류
    
y1 = u(2);                                                                 % 오른쪽 차선 종류

% 현재 인식 가능한 차선 종류
% 실선 - 1 / 점선 - 3
% 화면 출력 시, 실선 - solid, 점선 - broken

end
