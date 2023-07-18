% % TCP Host and Port settings
% host = '127.0.0.1'; % THIS IP ADDRESS MUST BE USED FOR THE VIRTUAL BOX VM
% host = '192.168.230.128'; % THIS IP ADDRESS MUST BE USED FOR THE VMWARE
clear all;
host = '192.168.0.100'; % THIS IP ADDRESS MUST BE USED FOR THE REAL ROBOT
port = 30003;
% 

% Calling the constructor of rtde to setup tcp connction
rtde = rtde(host,port);

% Setting home
home = [-588.53, -133.30, 371.91, 2.2214, -2.2214, 0.00];

jointPosA = deg2rad([106.12, -162.47, 135.49, 205.71, 15.19, 0.01]);
jointPosB = deg2rad([45.48, -183.35,120.62, 238.42, -69.27, 0.01]);

disp("Part A: ")
rtde.movel(home);pause(4)
disp("Move second")
% rtde.movel(jointPosA, "joint");pause(4);
disp("Move third")
rtde.movel(jointPosB, "joint");pause(4);
rtde.drawPath(tcp_pose);


rtde.close;