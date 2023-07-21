% Define the symbolic variables
clear all
syms theta1 theta2 d3 L1 L2 d1 d4 real

% DH parameters
theta = [theta1, theta2, 0]; % theta values in radians
a = [L1, L2, 0]; % a values in meters
d = [d1, 0, (-d3-d4)]; % d values in meters
alpha = [0, 0, 0]; % alpha values in radians

% Initialize transformation matrix
T = eye(4);

for i = 1:3
    % Calculate the individual transformation matrix
    A = [cos(theta(i)), -sin(theta(i))*cos(alpha(i)), sin(theta(i))*sin(alpha(i)), a(i)*cos(theta(i));
         sin(theta(i)), cos(theta(i))*cos(alpha(i)), -cos(theta(i))*sin(alpha(i)), a(i)*sin(theta(i));
         0, sin(alpha(i)), cos(alpha(i)), d(i);
         0, 0, 0, 1];
    disp("A" + i)
    disp(A)
    % Multiply the overall transformation matrix by the individual transformation matrix
    T = T * A;
end
disp("Transformation: ")
T = simplify(T);
disp(T)

% Calculate the Jacobian
jacob0

% 

% 
% % Define the DH parameters
% % [ theta    d    a   alpha]
% L(1) = Link([ 0    0.1625  0   pi/2], 'standard');
% L(2) = Link([ 0    0      -0.425  0], 'standard');
% L(3) = Link([ 0    0      -0.3922 0], 'standard');
% 
% 
% % Create the robot
% robot = SerialLink(L, 'name', 'UR5e');
% 
% % Display the robot model
% robot.display();
% robot.plot([theta]);