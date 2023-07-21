% Import the Robotics Toolbox
clear all
%% Part 1 =================================================================

% Define the joint positions in radians
joint_positions = deg2rad([-106.12, -162.47, 135.49, 205.71, 15.19, 0.01]);

% Initialize the overall transformation matrix
T = eye(4);

% Calculate the transformation matrix for each joint
for i = 1:6
    % Calculate the individual transformation matrix
    A = [cos(theta(i)+joint_positions(i)), -sin(theta(i)+joint_positions(i))*cos(alpha(i)), sin(theta(i)+joint_positions(i))*sin(alpha(i)), a(i)*cos(theta(i)+joint_positions(i));
         sin(theta(i)+joint_positions(i)), cos(theta(i)+joint_positions(i))*cos(alpha(i)), -cos(theta(i)+joint_positions(i))*sin(alpha(i)), a(i)*sin(theta(i)+joint_positions(i));
         0, sin(alpha(i)), cos(alpha(i)), d(i);
         0, 0, 0, 1];
    A 
    disp(i)
    % Multiply the overall transformation matrix by the individual transformation matrix
    T = T * A;
end

% Display the overall transformation matrix
disp("NEW LINE: ")
disp(T);
position = T(1:3, 4)
orientation = T(1:3, 1:3)

%% Part 2 =================================================================
startup_rvc;

% Define the DH parameters
% [ theta    d    a   alpha]
L(1) = Link([ 0    0.1625  0   pi/2], 'standard');
L(2) = Link([ 0    0      -0.425  0], 'standard');
L(3) = Link([ 0    0      -0.3922 0], 'standard');
L(4) = Link([ 0    0.1333  0   pi/2], 'standard');
L(5) = Link([ 0    0.0997  0   -pi/2], 'standard');
L(6) = Link([ 0    0.0996  0   0], 'standard');

% Create the robot
robot = SerialLink(L, 'name', 'UR5e');

% Display the robot model
robot.display();
robot.plot([theta]);
%% Part 3 =================================================================
% Define the joint angles for Joint Variable A
% Convert the joint angles from degrees to radians
jointAnglesA = deg2rad([-106.12, -162.47, 135.49, 205.71, 15.19, 0.01]);

% Compute the forward kinematics
F = robot.fkine(jointAnglesA);

% Compare the matrices
isEqual = isequal(T, F);

% Display the result
disp(isEqual);
