%%% HP PHAN
close all; clear variables; clc;
startup_rvc;
dbstop if error
mdl_puma560

T1 = transl(0.4, 0.2, 0) * trotx(pi);
T2 = transl(0.4, -0.2, 0) * trotx(pi/2);
pose1 = p560.ikine6s(T1);
pose2 = p560.ikine6s(T2);
t = [0:0.01:5];

%% Planning joint space trajectories with lspb
f2 = figure(1);
s = mtraj(@lspb, pose1, pose2, t);
sd = [zeros(1,6); diff(s)];
sdd = [zeros(1,6); diff(sd)];
sddd = [zeros(1,6); diff(sdd)];

subplot(4,1,1)
plot(t, s); grid on; xlim([min(t), max(t)]);
title('LSPB trajectory');
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

