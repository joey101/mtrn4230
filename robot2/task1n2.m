clear all;
close ALL;
startup_rvc; % Startup the rvc toolbox
load hershey; % Load in the hershey fonts

% PART B Variables

x_pos = -706; % Default
% y_pos = -133.30; % Default
%x_pos = -300;
y_pos = -408;
z_pos = 5.03;
rotation_offset = 30;

write = 'jkqpx7983m'
allpaths = cell(1, length(write)); % Initialize paths as a cell array

scale = 0.04; % Select the scale of the digit. 1 = 100%, 0.1 = 10% scale
spacing = 0.03;
current = 0.5;

for q = 1:length(write)
    character = hershey{write(q)}; % Select the letter that you want to draw (Letter or number works)
    %char_width = max(character.stroke(1,:)) - min(character.stroke(1,:));
    
    path = [scale*character.stroke; zeros(1,numcols(character.stroke))]; % create the path 
    k = find(isnan(path(1,:)));
        
    % At these positions add in a z height
    path(:,k) = path(:,k-1); 
    path(3,k) = 0.2*scale; % Determine the hight of the lift up motions. 0.2 * scale is the height. 0.2 is in m
    path(:,end+1) = [path(1,end); path(2,end); 0.3*scale]; % Add lift up after last stroke
    
    traj = [path'*1000]; % convert to the mm units so that we can use the rtde toolbox
  
    
    traj(:, 1) = traj(:, 1) + current;
    current = max(traj(:, 1)) + (spacing) * 1000 * scale;
    
    rotation = rot2(rotation_offset, 'deg');
    traj(:,1:2) = (rotation * traj(:,1:2)')';
    allpaths{q} = traj; % Assign traj to a cell of pathsi
end

% % Create a new figure
% figure;
% % After all paths have been generated, create a new loop to plot them
% for i = 1:length(allpaths)
%     traj = allpaths{i}; % Get the i-th path
%     % Plot the path
%     plot3(traj(:,1), traj(:,2), traj(:,3));
%     hold on; % Keep the current plot when adding new plots
% end

hold off; % No longer keep the current plot when adding new plots
%%
% % TCP Host and Port settings
%%host = '127.0.0.1'; % THIS IP ADDRESS MUST BE USED FOR THE VIRTUAL BOX VM
% host = '192.168.230.128'; % THIS IP ADDRESS MUST BE USED FOR THE VMWARE
host = '192.168.0.100'; % THIS IP ADDRESS MUST BE USED FOR THE REAL ROBOT
port = 30003;
% 

% Calling the constructor of rtde to setup tcp connction
rtde = rtde(host,port);

% Setting home
home = [-588.53, -350, 227.00, 2.221, 2.221, 0.00];
poses = rtde.movej(home);
% setting move parameters
v = 0.9;
a = 1.0;
blend = 0.002;

tcp_poses = [];

for j = 1:length(allpaths)
    traj = allpaths{j};
    % Creating a path array
    path = [];
    % Populate the path array
        for i = 1:length(traj)
            point = [[(traj(i,1:3) + [x_pos, y_pos, z_pos]),(home(4:6))],a,v,0,blend];
            if isempty(path)
                path = point;
            else
                path = cat(1,path,point);
            end
        end
    pause(0.5);
    % Execute the movement!
    poses = rtde.movej(path);
    tcp_poses = [tcp_poses; poses];
    
    %pause(0.1);
    % if j < length(path)
    %     % Get the first pose of the next path
    %     nextTraj = path{j+1};
    %     nextPose = [(nextTraj(1,1:3) + [x_pos, y_pos, z_pos]),(home(4:6))];
    %     % Now you have lastPose and nextPose
    %     % Execute movec here
    %     rtde.movec(lastPose, nextPose,'joint',a,v,0,blend);
    % end
end

rtde.drawPath(tcp_poses);
rtde.movej(home);

rtde.close;




%%========================================================================
% Task 3 was in another file but you guys want one file.
% Author: Jawad Tanana
% For MTRN4230 2023
clear all;
close ALL;
startup_rvc; % Startup the rvc toolbox
load hershey; % Load in the hershey fonts

% PART B Variables
x_pos = -588.53; % Default
y_pos = -133.30; % Default
%x_pos = -300;
%y_pos = -300;
z_pos = 0;
r_off = 0;

scale = 0.04; % Select the scale of the digit. 1 = 100%, 0.1 = 10% scale
spacing = 0.04;

write = '1 * 2';
parts = strsplit(write, ' ');

% Extract input parts
num1 = str2double(parts{1});
operation = part{2};
num2 = str2double(parts{3});

% Perform input differentiation
if ~isnan(num1) && ~isnan(num2) && ismember(operation, {'+', '-', '*'})
    switch operation
        case '+'
            result = num1 + num2;
        case '-'
            result = num1 - num2;
        case '*'
            operation = 'X'
            result = num1 * num2;
    end
    disp(['Result: ' num2str(result)]);
end

% String and operation definitions
string1 = num2str(num1);
string2 = [num2str(num2), ' ', operation];
string3 = num2str(result);

% Length of the string to write
numCharacters = length(write);

% Initialize cell array for paths
paths = cell(1, numCharacters);

% Current position initialization
current = 0.5; % Use previously set value

% Loop over each character in the string
for q = 1:numCharacters

    % Select the character that you want to draw
    character = hershey{write(q)};
    % Calculate character width
    char_width = max(character.stroke(1,:)) - min(character.stroke(1,:));
    % Create the path for the character
    path = [scale * character.stroke; zeros(1, size(character.stroke, 2))];
    % Get indices where there is a NaN
    k = find(isnan(path(1,:)));
    % Assign z height at these positions
    path(:,k) = path(:,k-1);
    path(3,k) = 0.2 * scale; % Height for lift up

    % Add lift up after last stroke
    path(:,end+1) = [path(1,end); path(2,end); 0.2*scale];
    
    % Convert to millimeters
    traj = path' * 1000;

    % Adjust x position based on current x position
    traj(:,1) = traj(:,1) + current;
    current = max(traj(:,1)) + spacing * 1000 * scale;

    % Apply rotation if defined
    % rotation = rot2(r_off, 'deg');
    % traj(:,1:2) = (rotation * traj(:,1:2)')';
    
    % Store trajectory in paths
    paths{q} = traj;
end


% After all paths have been generated, create a new loop to plot them
for i = 1:length(paths)
    traj = paths{i}; % Get the i-th path
    % Plot the path
    plot3(traj(:,1), traj(:,2), traj(:,3));
    hold on; % Keep the current plot when adding new plots
end

hold off; % No longer keep the current plot when adding new plots

%==========================================================================
% % TCP Host and Port settings
%host = '127.0.0.1'; % THIS IP ADDRESS MUST BE USED FOR THE VIRTUAL BOX VM
%host = '192.168.230.128'; % THIS IP ADDRESS MUST BE USED FOR THE VMWARE
host = '192.168.0.100'; % THIS IP ADDRESS MUST BE USED FOR THE REAL ROBOT
port = 30003;

% Calling the constructor of rtde to setup tcp connction
rtde = rtde(host,port);
% Setting home
home = [-588.53, -133.30, 227.00, 2.221, 2.221, 0.00];
poses = rtde.movej(home);

% setting move parameters
v = 0.8;
a = 1.2;
blend = 0.001;

tcp_poses = [];

for j = 1:length(allpaths)
    traj = allpaths{j};
    % Creating a path array
    path = [];
    % Populate the path array
        for i = 1:length(traj)
            point = [[(traj(i,1:3) + [x_pos, y_pos, z_pos]),(home(4:6))],a,v,0,blend];
            if isempty(path)
                path = point;
            else
                path = cat(1,path,point);
            end
        end
    pause(0.01);
    % Execute the movement!
    poses = rtde.movej(path);
    tcp_poses = [tcp_poses; poses];
    %pause(0.1);
end

rtde.drawPath(tcp_poses);
rtde.movej(home);

rtde.close;







