% Given values
m = 30; % mass in kg
q1 = 0.3; % displacement in m
v = 0.04; % velocity in m/s
g = 9.8; % gravitational acceleration in m/s^2

% Inertia matrix (scalar for a single joint robot)
D11 = m

% Kinetic energy
K = 0.5 * m * v^2;

% Potential energy
P = m * g * q1;

% Lagrangian
L = K - P

% Gravity loading
dP_dq = m * g
%%
% Given values
q1_start = 2; % start position of joint 1 in degrees
q1_end = 144; % end position of joint 1 in degrees
Tf = 15; % total time in seconds
V1_percentage = 0.72; % V1 as a percentage of maximum velocity

% Calculate maximum velocity and V1
Vmax = (q1_end - q1_start) / Tf;
V1 = V1_percentage * Vmax

% Solve for blend time Tb
a = Vmax; % acceleration is equal to Vmax
Tb = V1 / a

% Calculate angle of joint 1 at 12.71 s
t = 12.71; % time in seconds
if t < Tb
    q1_t = 0.5 * a * t^2
elseif t < Tf - Tb
    q1_t = V1 * (t - Tb/2)
else
    q1_t = V1 * (Tf - Tb) + 0.5 * a * (Tf - t)^2
end

% Given values for joint 2
q2_start = 18; % start position of joint 2 in degrees
q2_end = 62; % end position of joint 2 in degrees

% Calculate V2
Vmax2 = (q2_end - q2_start) / Tf;
V2 = V1_percentage * Vmax2
%%
% Define the link lengths
L1 = 0.8; % m
L2 = 0.1; % m

% Define the joint angles in degrees
theta1_deg = 70; % degrees
theta2_deg = 80; % degrees

% Convert the joint angles to radians
theta1_rad = deg2rad(theta1_deg);
theta2_rad = deg2rad(theta2_deg);

% Calculate the Jacobian
Jv = [-L1*sin(theta1_rad) - L2*sin(theta1_rad + theta2_rad), -L2*sin(theta1_rad + theta2_rad);
      L1*cos(theta1_rad) + L2*cos(theta1_rad + theta2_rad), L2*cos(theta1_rad + theta2_rad);
      0, 0];
  
% Display the Jacobian
disp(Jv)
%%
% Define the initial and final positions for each joint in degrees
q1_i_deg = 0;
q1_f_deg = 140;
q2_i_deg = 0;
q2_f_deg = 160;

% Convert the positions to radians
q1_i_rad = deg2rad(q1_i_deg);
q1_f_rad = deg2rad(q1_f_deg);
q2_i_rad = deg2rad(q2_i_deg);
q2_f_rad = deg2rad(q2_f_deg);

% Define the maximum angular acceleration for each joint in rad/s^2
a1_max = 0.25;

% Calculate the switch time for each joint
Ts1 = sqrt((q1_f_rad - q1_i_rad) / a1_max);
Ts2 = sqrt((q2_f_rad - q2_i_rad) / a1_max);

% Calculate the velocity at the switch time for each joint
Vs1 = a1_max * Ts1;
Vs2 = a1_max * Ts2;

% Define the link lengths
L1 = 0.8; % m
L2 = 0.1; % m

% Calculate the Jacobian at the switch time
Jv = [-L1*sin(Ts1) - L2*sin(Ts1 + Ts2), -L2*sin(Ts1 + Ts2);
      L1*cos(Ts1) + L2*cos(Ts1 + Ts2), L2*cos(Ts1 + Ts2);
      0, 0];

% Calculate the translational velocity of the end effector at the switch time
V = Jv * [Vs1; Vs2];

% Calculate the magnitude of the translational velocity
V_mag = sqrt(sum(V.^2));

% Display the translational velocity
disp(V_mag)
%%
% Define the scale factor for the attractive force at O1
zeta_1 = 2;

% Define the start and finish positions in degrees
theta_s_deg = [0, 90];
theta_f_deg = [90, 90];

% Convert the positions to radians
theta_s_rad = deg2rad(theta_s_deg);
theta_f_rad = deg2rad(theta_f_deg);

% Define the length of the first link
L1 = 5; % m

% Calculate the current position of O1
O1_s_x = L1 * cos(theta_s_rad(1));
O1_s_y = L1 * sin(theta_s_rad(1));

% Calculate the final position of O1
O1_f_x = L1 * cos(theta_f_rad(1));
O1_f_y = L1 * sin(theta_f_rad(1));

% Calculate the attractive forces at O1
F_att1_x = -zeta_1 * (O1_s_x - O1_f_x) / abs(O1_s_x - O1_f_x);
F_att1_y = -zeta_1 * (O1_s_y - O1_f_y) / abs(O1_s_y - O1_f_y);

% Display the attractive forces
disp([F_att1_x, F_att1_y])
%%
% Define the scale factor for the attractive force at O2
zeta_2 = 4;

% Define the length of the second link
L2 = 5; % m

% Calculate the current position of O2
O2_s_x = L1 * cos(theta_s_rad(1)) + L2 * cos(theta_s_rad(1) + theta_s_rad(2));
O2_s_y = L1 * sin(theta_s_rad(1)) + L2 * sin(theta_s_rad(1) + theta_s_rad(2));

% Calculate the final position of O2
O2_f_x = L1 * cos(theta_f_rad(1)) + L2 * cos(theta_f_rad(1) + theta_f_rad(2));
O2_f_y = L1 * sin(theta_f_rad(1)) + L2 * sin(theta_f_rad(1) + theta_f_rad(2));

% Calculate the attractive forces at O2
F_att2_x = -zeta_2 * (O2_s_x - O2_f_x) / abs(O2_s_x - O2_f_x);
F_att2_y = -zeta_2 * (O2_s_y - O2_f_y) / abs(O2_s_y - O2_f_y);

% Display the attractive forces
disp([F_att2_x, F_att2_y])
%%
% Define the scale factor for the repulsive force
n = 10;

% Define the threshold distance for the repulsive force
p_0 = 1; % m

% Define the coordinates of the obstacle B
B_x = 5.2; % m
B_y = 5; % m

% Calculate the distance from O2 to the obstacle
p_O2 = sqrt((O2_s_x - B_x)^2 + (O2_s_y - B_y)^2);

% Calculate the derivative of p_O2 with respect to q
delta_p_O2_x = (O2_s_x - B_x) / p_O2;
delta_p_O2_y = (O2_s_y - B_y) / p_O2;

% Calculate the repulsive forces at O2
F_rep2_x = n * (1/p_O2 - 1/p_0) * 1/p_O2^2 * delta_p_O2_x
F_rep2_y = n * (1/p_O2 - 1/p_0) * 1/p_O2^2 * delta_p_O2_y

% Display the repulsive forces

%%
% Define the masses
m1 = 10; % kg
m2 = 3; % kg

% Define the Jacobians
Jvc1 = [1 0; 0 0; 0 0];
Jvc2 = [0 0; 0 0; 1 1];

% Calculate the elements of the inertia matrix
D11 = m1 * (Jvc1(1,:)' * Jvc1(1,:)) + m2 * (Jvc2(1,:)' * Jvc2(1,:))
D12 = m1 * (Jvc1(1,:)' * Jvc1(2,:)) + m2 * (Jvc2(1,:)' * Jvc2(2,:));
D21 = D12
D22 = m1 * (Jvc1(2,:)' * Jvc1(2,:)) + m2 * (Jvc2(2,:)' * Jvc2(2,:))

% Display the inertia matrix
D = [D11 D12; D21 D22];
disp('D = ')
disp(D)











