% Author: HP Phan
%% Example 3 in Lecture 4
startup_rvc;
%%%%% Articulated robot
clear all

%%%% DH parameters (angle) in degree unit


%%% Convert to radian
theta= deg2rad([50 75]);
%theta= deg2rad([0 0 0]);
alpha=deg2rad([90 0 0]); % in radian
d = [0 0 0];
a = [0.5 0.2 0.3 0.3];

L(1) = Link('revolute', 'd', d(1), 'a', a(1), 'alpha', alpha(1), 'offset', 0); % Link 1. Offset of theta1
L(2) = Link('revolute', 'd', d(2), 'a', a(2), 'alpha', alpha(2), 'offset', 0); % Link 2. Offset of theta2
L(3) = Link('revolute', 'd', d(3), 'a', a(3), 'alpha', alpha(3), 'offset', 0); % Link 3. Offset of theta3

%%% Create the robot
robot = SerialLink(L, 'name', 'Articulated');
robot.plot([theta]);




% Prints out the DH Matrix on the console!
Method1=robot.fkine([theta])

Method2 = frameTransformationMatrix(theta(1),d(1),a(1),alpha(1))*frameTransformationMatrix(theta(2),d(2),a(2),alpha(2))*frameTransformationMatrix(theta(3),d(3),a(3),alpha(3))

% %% Functions!a

% % Function to calculate the frame transformation matrix

% %% Functions!

% % Function to calculate the frame transformation matrix
 function T = frameTransformationMatrix(theta,d,a,alpha)
% 
T = SE3([[cos(theta), -sin(theta)*cos(alpha), sin(theta)*sin(alpha), a*cos(theta)];
    [sin(theta), cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta)];
    [0, sin(alpha), cos(alpha), d];
    [0, 0, 0, 1]]);

end

