startup_rvc
A1 = [0; 0];
A2 = [220; 0];
A3 = [220; 100];
A4 = [0; 100];

B1 = [30; 60];
B2 = [300; 50];
B3 = [260; 230];
B4 = [60; 180];

C = [80; 160];

world_coordinates = [A1 A2 A3 A4];
img_coordinates = [B1 B2 B3 B4];

tform = fitgeotrans(img_coordinates', world_coordinates', 'projective');
H_matrix = tform.T;

transformPointsForward(tform,C')


disp(H_matrix);


theta_1 = 40; % degrees
theta_2 = 110; % degrees

% Convert angles to radians
theta_1_rad = deg2rad(theta_1);
theta_2_rad = deg2rad(theta_2);

% Position of the end effector (assuming it is given)
x = 38.5069; % Replace with the x-coordinate of the end effector
y = 74.8968 %Replace with the y-coordinate of the end effector

% Calculate link lengths
Lx = x - cos(theta_1_rad + theta_2_rad);
Ly = y - sin(theta_1_rad + theta_2_rad);

% Display link lengths
disp(['Lx = ', num2str(Lx), ' mm']);
disp(['Ly = ', num2str(Ly), ' mm']);



%%

% Given data
theta_1 = 40; % degrees
theta_2 = 110; % degrees
omega_1 = 0.4; % rad/s
omega_2 = 0.25; % rad/s
Lx = 39.3729; % Link length Lx in mm (placeholder value, replace with actual value)
Ly = 74.3968; % Link length Ly in mm (placeholder value, replace with actual value)

% Convert angles to radians
theta_1_rad = deg2rad(theta_1);
theta_2_rad = deg2rad(theta_2);

% Calculate the Jacobian matrix
J = [-Lx * sin(theta_1_rad) - Ly * sin(theta_1_rad + theta_2_rad), -Ly * sin(theta_1_rad + theta_2_rad);
     Lx * cos(theta_1_rad) + Ly * cos(theta_1_rad + theta_2_rad),  Ly * cos(theta_1_rad + theta_2_rad)];

% Calculate the end-effector velocity [Vx, Vy]
end_effector_velocity = J * [omega_1; omega_2];

% Display the end-effector velocity
disp('End-effector velocity [Vx, Vy] in mm/s:');
disp(end_effector_velocity);


%%

% Startup the RVC toolbox
startup_rvc;

% Step 1: Rotation by 105 degrees about the current x-axis
R1 = trotx(deg2rad(105));

% Step 2: Translation of 0.2 units along the current x-axis
T1 = transl(0.2, 0, 0);

% Step 3: Translation of 0.1 units along the current z-axis
T2 = transl(0, 0, 0.1);

% Step 4: Rotation by 50 degrees about the current z-axis
R2 = trotz(deg2rad(50));

% Combine the transformations
H = R1 * T1 * T2 * R2;

% Display the homogeneous transformation matrix
disp('Homogeneous transformation matrix H:');
disp(H);

%%
% Given data (in cm and degrees)
L1 = 14;
L2 = 11;
L3 = 14;
joint_1 = deg2rad(65); % Convert to radians
joint_2 = deg2rad(20); % Convert to radians
joint_3 = deg2rad(75); % Convert to radians

% Define DH parameters for each joint
% Format: [a_i, alpha_i (radians), d_i, theta_i (radians)]
dh_parameters = [
    0,    0,    L1, joint_1;  % Joint 1
    L2,   0,    0,  joint_2;  % Joint 2
    L3,   0,    0,  joint_3;  % Joint 3
];

% Display the DH table
disp('DH Table:');
disp('   a_i      alpha_i      d_i      theta_i');
disp(dh_parameters);

%%

% Load the Robotics Toolbox
startup_rvc;

% Given data (in cm and degrees)
L1 = 14;
L2 = 11;
L3 = 14;
joint_1 = 65; % Degrees
joint_2 = 20; % Degrees
joint_3 = 75; % Degrees

% Define each link as a Link object
% Link('d', value, 'a', value, 'alpha', value, 'offset', value, 'modified')
% We're using the 'modified' flag as this is the convention used in the toolbox.
link1 = Link('d', L1, 'a', 0, 'alpha', 0, 'offset', joint_1, 'modified');
link2 = Link('d', 0, 'a', L2, 'alpha', 0, 'offset', joint_2, 'modified');
link3 = Link('d', 0, 'a', L3, 'alpha', 0, 'offset', joint_3, 'modified');

% Create a SerialLink object which represents the robot
robot = SerialLink([link1 link2 link3]);

% Display the robot information
robot


