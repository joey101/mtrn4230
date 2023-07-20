% Import the Robotics Toolbox
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
