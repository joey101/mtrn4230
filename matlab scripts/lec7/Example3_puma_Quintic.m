%%% HP PHAN
% MTRN4230 Trajectory control sample code
% Adapted from Corke ch 3.

%% Planning simple quintic polynomial trajectories
%% Ex 1
close all; clear variables; clc;
startup_rvc;
dbstop if error
mdl_puma560
T1 = transl(0.4, 0.2, 0) * trotx(pi)
T2 = transl(0.4, -0.2, 0) * trotx(pi/2)

pose1 = p560.ikine6s(T1);  %%inverse kinematics for 6-axis spherical wrist revolute robot
pose2 = p560.ikine6s(T2);


figure(1)
subplot(2,1,1)
p560.plot(pose1);

t = [0:0.01:5];
s = mtraj(@tpoly, pose1, pose2, t);
sd = [zeros(1,6); diff(s)];
sdd = [zeros(1,6); diff(sd)];
%sddd = [zeros(1,6); diff(sdd)];

%Show position, velocity and acceleration as a function of time
f1 = figure(2);
subplot(4,1,1)
plot(t, s); grid on; xlim([min(t), max(t)]);
title('Quintic polynomial trajectory');
xlabel('Time');
ylabel('Position [rad]')
legend('q1', 'q2', 'q3', 'q4', 'q5', 'q6');
subplot(4,1,2)
plot(t, sd); grid on; xlim([min(t), max(t)]);
xlabel('Time'); 
ylabel('Velocity [rad/s]')
subplot(4,1,3)
plot(t, sdd); grid on; xlim([min(t), max(t)]);
xlabel('Time');
ylabel('Acceleration [rad/s/s]')
% subplot(4,1,4)
% plot(t, sddd); grid on; xlim([min(t), max(t)]);
% xlabel('Time');
% ylabel('Jerk [rad/s/s/s]')


%Show position, velocity and acceleration of the first joint
f2 = figure(3);
subplot(4,1,1)
plot(t, s(:,1)); grid on; xlim([min(t), max(t)]);
title('Quintic polynomial trajectory of the JOINT 1');
xlabel('Time');
ylabel('Position [rad]')
subplot(4,1,2)
plot(t, sd(:,1)); grid on; xlim([min(t), max(t)]);
xlabel('Time'); 
ylabel('Velocity [rad/s]')
subplot(4,1,3)
plot(t, sdd(:,1)); grid on; xlim([min(t), max(t)]);
xlabel('Time');
ylabel('Acceleration [rad/s/s]')
% subplot(4,1,4)
% plot(t, sddd(:,1)); grid on; xlim([min(t), max(t)]);
% xlabel('Time');
% ylabel('Jerk [rad/s/s/s]')

f4 = figure(4);
T = p560.fkine(s);
p = transl(T) ; % Just translational components
plot(p(:, 1), p(:, 2)); axis equal; xlabel('X [m]'); ylabel('Y [m]'); grid on; title('Locus of joint space path');


