% Author: HP Phan
%% Example 1 in Lecture 4: 3 Revolute joint manipulator
startup_rvc;

%%%% coordinate of the end-effector expressed in frame 3
p1=[0; 0; 0]; 

%%%% DH parameters (angle) in degree unit
angle= [25 40 0];

%%% Convert to radian
theta= deg2rad(angle);
alpha=[0 0 0]; % in radian
d = [0 0 0];
a = [3 4 0];
L(1) = Link('revolute', 'd', d(1), 'a', a(1), 'alpha', alpha(1), 'offset', 0); % Link 1. Offset of theta1
L(2) = Link('revolute', 'd', d(2), 'a', a(2), 'alpha', alpha(2), 'offset', 0); % Link 2. Offset of theta2
L(3) = Link('revolute', 'd', d(3), 'a', a(3), 'alpha', alpha(3), 'offset', 0); % Link 3. Offset of theta3

%%% Create the robot
robot = SerialLink(L, 'name', 'three revolute joints');

% Homogeneous transformation from frame 0 to frame 3 
f1=robot.fkine([theta])
% end effector coordinate expressed with respect to frame 0
p0=f1*p1

% f = example.fkine(q, 'deg') %% if evolute joint coordinates are in degrees not radians