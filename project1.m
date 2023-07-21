% % % TCP Host and Port settings
% clear all;
% host = '127.0.0.1'; % THIS IP ADDRESS MUST BE USED FOR THE VIRTUAL BOX VM
% % host = '192.168.230.128'; % THIS IP ADDRESS MUST BE USED FOR THE VMWARE
% % host = '192.168.0.100'; % THIS IP ADDRESS MUST BE USED FOR THE REAL ROBOT
% port = 30003;
% % 
% 
% % Calling the constructor of rtde to setup tcp connction
% rtde = rtde(host,port);
% 
% % Setting home
% home = [-588.53, -133.30, 371.91, 2.2214, -2.2214, 0.00];
% 
% jointPosA = deg2rad([106.12, -162.47, 135.49, 205.71, 15.19, 0.01]);
% jointPosB = deg2rad([45.48, -183.35,120.62, 238.42, -69.27, 0.01]);
% 
% disp("Part A: ")
% rtde.movel(home);pause(4)
% disp("Move second")
% % rtde.movel(jointPosA, "joint");pause(4);
% disp("Move third")
% rtde.movel(jointPosB, "joint");pause(4);
% rtde.drawPath(tcp_pose);
% 
% 
% rtde.close;

%% Fixed Code with a Via point.
clear all;

host = '127.0.0.1'; % THIS IP ADDRESS MUST BE USED FOR THE VIRTUAL BOX VM
% host = '192.168.230.128'; % THIS IP ADDRESS MUST BE USED FOR THE VMWARE
% host = '192.168.0.100'; % THIS IP ADDRESS MUST BE USED FOR THE REAL ROBOT
port = 30003;

% Calling the constructor of rtde to setup tcp connection
rtde = rtde(host,port);

% Setting home
home = [-588.53, -133.30, 371.91, 2.2214, -2.2214, 0.00];

jointPosA = deg2rad([106.12, -162.47, 135.49, 205.71, 15.19, 0.01]);
jointPosB = deg2rad([45.48, -183.35,120.62, 238.42, -69.27, 0.01]);

% Define via point as halfway between jointPosA and jointPosB
viaPoint = deg2rad([-85,-155,82,150,15,0.01]);
% Move to home position

[pose2,a2,b2,c2,d2] = rtde.movel(jointPosA, "joint"); 
[pose3,a3,b3,c3,d4] = rtde.movel(viaPoint, "joint"); 
[pose4,a4,b4,c4,d4] = rtde.movel(jointPosB, "joint");
[pose5,a5,b5,c5,d5] = rtde.movel(viaPoint, "joint"); 
[pose6,a6,b6,c6,d6] =  rtde.movel(jointPosA, "joint");
% pose7 = rtde.movej(home); 

tcp_poses = [pose2;pose3;pose4;pose5;pose6];
rtde.drawPath(tcp_poses);
rtde.close;
