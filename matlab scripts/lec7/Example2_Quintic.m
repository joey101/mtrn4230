%%% HP PHAN
close all; clear variables; clc;
startup_rvc;
dbstop if error
time = 0:0.1:5;%%% 5 sec

figure
[S,SD,SDD] = tpoly(0, 1, time,5,0);
%%%%% [S,SD,SDD] = tpoly(0, 1, time); by default the boundaries conditions for velocities are V_i = V_f=0
subplot(3,1,1)

plot(time,S)  %% position trajectory
subplot(3,1,2)
plot(time,SD) %% Velocity
subplot(3,1,3)
plot(time,SDD) %Acceleration
