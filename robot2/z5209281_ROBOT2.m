% Author: James Yuan
% For MTRN4230 2023
clc;
clear;
close all;

startup_rvc; % Startup the rvc toolbox
load hershey; % Load in the hershey fonts

%  ========== adjustable values ========== 
scale = 0.04; % Select the scale of the digit. 1 = 100%, 0.1 = 10% scale
z_offset = 4;
x_displacement = 0;
y_displacement = 0;
angular_displacement = 0;

% PartA and B (comment out the parts that is not currently using)
% in_chars = '69abcd78XY'; 

% Part C
in_chars = solve_operation('14*2');

% ========================================= 

fprintf('The printing sequence is: \n%s\n',in_chars)
n = length(in_chars);

% PARTA - specify the default paper location
default_bottom_left_corner_x = -588.53; 
default_bottom_left_corner_y = -133.30; 
default_rotation = 90;

% % PARTB - translation and rotation
bottom_left_corner_x = default_bottom_left_corner_x + x_displacement; % positive x = right side ; negative x = left side
bottom_left_corner_y = default_bottom_left_corner_y + y_displacement; 
rotation = default_rotation + angular_displacement;

% Create an empty array to store the trajectory for all characters
traj = [];

x_offset = 0;
y_offset = 0;

for j = 1:n
    in_char = in_chars(j);

    if in_char == '*'
        in_char = 'X';  % Replace '*' with 'X'
    end

    if in_char == newline % char(10) is the newline character '\n'
        % Handle newline: move to the next line and continue to the next iteration
        x_offset = 0;
        y_offset = y_offset + (max(path(2,:)) - min(path(2,:)) + 0.01);  % add extra spacing; % lineHeight is the vertical spacing between lines
%         y_offset = y_offset + 0.01;  % add extra spacing; % lineHeight is the vertical spacing between lines
        continue;
    end
    
    character = hershey{in_char};

    % create the path for the current character
    path = [scale*character.stroke; zeros(1,numcols(character.stroke))];

    % lifting within one character
    k = find(isnan(path(1,:))); % Where ever there is an nan it indicates that we need to lift up.
    path(:,k) = path(:,k-1); % At these positions add in a z height
    path(3,k) = 0.01; % Determine the height of the lift up motions 

    % Shift the x-coordinates of the path to position the character correctly
    path(1,:) = path(1,:) + x_offset;
    path(2,:) = path(2,:) - y_offset;

    % Add the current character's path to the trajectory
    traj = [traj, path];

    % Update x_offset for next character. add width of the character + extra specing
    x_offset = x_offset + max(path(1,:)) - min(path(1,:)) + 0.01;

    % Lift and move to starting position of next character
    if j < n
        lift = [path(1,end), path(2,end), 0.01]; % lift 0.01 m
        move = [x_offset, path(2,end), 0.2*scale]; % y_offset is subtracted when moving to a new line
        traj = [traj, lift', move'];
    end
end

traj = [traj'*1000]; % convert to the mm units so that we can use the rtde toolbox

% Generate a plot of what we are expecting
scatter3(traj(:,1), traj(:,2), traj(:,3));
plot3(traj(:,1), traj(:,2), traj(:,3));

%% NOW USE THE RTDE TOOLBOX TO EXECUTE THIS PATH!

% TCP Host and Port settings
host = '127.0.0.1'; % THIS IP ADDRESS MUST BE USED FOR THE VIRTUAL BOX VM
% host = '192.168.230.128'; % THIS IP ADDRESS MUST BE USED FOR THE VMWARE
% host = '192.168.0.100'; % THIS IP ADDRESS MUST BE USED FOR THE REAL ROBOT
port = 30003;

% Calling the constructor of rtde to setup tcp connction
rtde = rtde(host,port);

% Setting home
home = [-588.53, -133.30, 371.91, 2.2214, -2.2214, 0.00];
poses = rtde.movej(home);

% Set the starting position relative to paper frame
start_pos = [bottom_left_corner_x, bottom_left_corner_y, z_offset]; % Start position of first stroke

% Creating a path array
path = [];

% setting move parameters
v = 0.5; % velocity
a = 1.2; % acceleration
blend = 0; % blend radius

% rotation
R = rot2(rotation, 'deg'); % rotation matrix
for i = 1:length(traj)
    traj(i,1:2) = (R * traj(i,1:2)')';% Apply rotation matrix to trajectory points
end

% Populate the path array
for i = 1:length(traj)
    disp(i);
    disp(traj(i,1:3) + start_pos);
    point = [[(traj(i,1:3) + start_pos),(home(4:6))],a,v,0,blend];
    if isempty(path)
        path = point;
    else
        path = cat(1,path,point);
    end
end

point = [home,a,v,0,blend]; % Add home position to the end of the path
path = cat(1,path,point);

% Execute the movement!
poses = rtde.movej(path);
rtde.drawPath(poses);
rtde.movej(home); % Move robot back to home position after drawing path

hold on
% plot A4 page
x1 = bottom_left_corner_x/1000;
x2 = (bottom_left_corner_x+210)/1000;
y1 = bottom_left_corner_y/1000;
y2 = (bottom_left_corner_y+297)/1000;

plot([x1,x1],[y1,y2],'blue');
plot([x1,x2],[y2,y2],'blue');
plot([x2,x2],[y2,y1],'blue');
plot([x1,x2],[y1,y1],'blue');

disp('Program Complete'); % Indicate program completion to user

rtde.close;

function res = solve_operation(operation)
    % Parse the operation
    %operation = strrep(operation, ' ', ''); % Remove spaces
    operation_parts = split(operation, {'+', '-', '*'}); % Split the operation into parts
    operator = operation(length(operation_parts{1})+1); % Identify the operator
    operand1 = operation_parts{1}; % First operand
    operand2 = operation_parts{2}; % Second operand
    
    if operator == '+'
        res = num2str(str2num(operand1) + str2num(operand2));
    elseif operator == '-'
        res = num2str(str2num(operand1) - str2num(operand2));
    elseif operator == '*'
        res = num2str(str2num(operand1) * str2num(operand2));
    end
    
    % Return as long operation format
    res = strjoin({operand1, [operand2, operator], res}, '\n');
end
