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