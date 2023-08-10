% Define the initial and final positions and the acceleration
q0 = 7; % degrees
qt = 110; % degrees
a = 4; % deg/s^2

% Calculate the switch time
ts = sqrt((qt - q0) / a);

% Display the switch time with 4 decimal places
fprintf('The switch time is %.4f seconds\n', ts);

%%
% Define the acceleration and the switch time
a = 4; % deg/s^2
ts = sqrt((110 - 7) / a); % seconds

% Calculate the switch velocity
vs = a * ts;

% Display the switch velocity with 4 decimal places
fprintf('The switch velocity is %.4f deg/s\n', vs);
%%
% Define the origin and axis of rotation for the base frame
O0 = [0; 0; 0];
Z0 = [0; 0; 1];

% Define the origin of the end-effector frame
O1 = [35.0; 14.8; 0];

% Calculate the translational velocity Jacobian
Jv = cross(Z0, (O1 - O0));

% Display the translational velocity Jacobian
fprintf('The translational velocity Jacobian is:\n');
disp(Jv);
%%
% Define the position of the end-effector and the z-axis of the end-effector frame
P = [18; 2; 11];
z6 = [0; -1; 0];

% Calculate the coordinate of the origin of the spherical joint
Pc = P - 10 * z6;

% Display the coordinate of the origin of the spherical joint
fprintf('The coordinate of the origin of the spherical joint is:\n');
disp(Pc);

%%
% Define the current position and the final position
syms x y
Oi_q = x;  % current position
Oi_qf = y;  % final position

% Calculate the absolute value of the attractive force
F = 7.5 * abs(Oi_q - Oi_qf)

% Display the absolute value of the attractive force
% fprintf('The absolute value of the attractive force is: %.4f N\n', F);
%%
% Define the link lengths and joint angles
a1 = 1.0; % m
a2 = 0.6; % m
theta1 = 1.5; % rad
theta2 = 0.5; % rad

% Calculate the elements of the Jacobian matrix
J11 = -a1*sin(theta1) - a2*sin(theta1 + theta2);
J12 = -a2*sin(theta1 + theta2);
J21 = a1*cos(theta1) + a2*cos(theta1 + theta2);
J22 = a2*cos(theta1 + theta2);

% Create the Jacobian matrix
J = [J11, J12; J21, J22];

% Calculate the manipulability
manipulability = abs(det(J))

