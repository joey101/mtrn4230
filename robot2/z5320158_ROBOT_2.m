%% ----- EXAMPLE 7: Drawing Letters -----
% Example of drawing a letter/digit from the rvc toolbox hershey library
clear all;
close ALL;

startup_rvc; % Startup the rvc toolbox

load hershey; % Load in the hershey fonts
word = 'oOoO';
paths = cell(1, length(word)); % Initialize paths as a cell array
spacing = 0.15;
current = 0;

for q = 1:length(word)
    character = hershey{word(q)}; % Select the letter that you want to draw (Letter or number works)
    scale = 0.1; % Select the scale of the digit. 1 = 100%, 0.1 = 10% scale
    char_width = max(character.stroke(1,:)) - min(character.stroke(1,:));
    
    path = [scale*character.stroke; zeros(1,numcols(character.stroke))]; % create the path 
     % Where ever there is an nan it indicates that we need to lift up.
    k = find(isnan(path(1,:)));
        
    % At these positions add in a z height
    path(:,k) = path(:,k-1); 
    path(3,k) = 0.3*scale; % Determine the hight of the lift up motions. 0.2 * scale is the height. 0.2 is in m
    traj = [path'*1000]; % convert to the mm units so that we can use the rtde toolbox
      
    traj(:, 1) = traj(:, 1) + current;
    current = current + (spacing + char_width) * 1000 * scale;
    disp(traj);   
    paths{q} = traj; % Assign traj to a cell of pathsi
end
% Create a new figure
figure;

% After all paths have been generated, create a new loop to plot them
for i = 1:length(paths)
    traj = paths{i}; % Get the i-th path
    % Plot the path
    plot3(traj(:,1), traj(:,2), traj(:,3));
    hold on; % Keep the current plot when adding new plots
end

hold off; % No longer keep the current plot when adding new plots

%% NOW USE THE RTDE TOOLBOX TO EXECUTE THIS PATH!
% % TCP Host and Port settings
%host = '127.0.0.1'; % THIS IP ADDRESS MUST BE USED FOR THE VIRTUAL BOX VM
% host = '192.168.230.128'; % THIS IP ADDRESS MUST BE USED FOR THE VMWARE
host = '192.168.0.100'; % THIS IP ADDRESS MUST BE USED FOR THE REAL ROBOT
port = 30003;

% Calling the constructor of rtde to setup tcp connction
rtde = rtde(host,port);
% Setting home
home = [-588.53, -133.30, 227.00, 2.221, 2.221, 0];
poses = rtde.movej(home);
% setting move parameters
v = 0.5;
a = 0.1;
blend = 0.00001;
% move j is path agnostic
% move c is smoother
tcp_poses = [];
for j = 1:length(paths)
    traj = paths{j};
    disp(traj);
    
    path = [];
    % Populate the path array
        for i = 1:length(traj)
            disp(traj(i,1:3) + [-588.53, -133.30 100]);
            point = [[(traj(i,1:3) + [-588.53, -133.30 30]),(home(4:6))],a,v,0,blend];
            if isempty(path)
                path = point;
            else
                path = cat(1,path,point);
            end
        end
    % Execute the movement!
    poses = rtde.movej(path);
    tcp_poses = [tcp_poses; poses];
end
rtde.movej(home);
rtde.drawPath(tcp_poses);
rtde.close;
