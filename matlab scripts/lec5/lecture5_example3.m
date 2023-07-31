%%%%%%%%%%%%%
% MTRN4230 Jacobian sample code
% Construct a 2-link simple planar manipulator, using section 7.2.1 of
% Corke. See 'Tutorial problem 1' in the lecture notes for Kinematics - Jacobian.
startup_rvc
dbstop if error
clear all syms
%% Setting up our 2-link manipulator

L(1) = Link([0 0 0.5 0]);
L(2) = Link([0 0 0.5 0]);

two_link = SerialLink(L, 'name', 'two link');

qi = deg2rad([45,170]);
T = two_link.fkine(qi)
two_link.plot([qi]);

% Checking some of the  inverse kinematics
%qi = two_link.ikine(T, 'q0', [1 3], 'mask', [1 1 0 0 0 0]);
%disp(qi*180/pi)

% Show how Jacobians work see Example 3 in Jacobian lecture notes
% This makes the assumption v = 0.1 m/s, a symbolic solution is shown below
J = two_link.jacob0(qi) % Calculate Jacobian at configuration qi
 
Jxy = J(1:2, :);% Take subset of Jacobian for just x-y position as we can ignore the rest in this problem.
q_dot = inv(Jxy) * [0.1 0]' % Desired velocity of 0.1m/s in the +ve x-direction
%x_dot = J*q_dot % Confirm the actual velocities.