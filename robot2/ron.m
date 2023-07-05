% Author: Ronan Och
% For MTRN4230 2023

% addpath 'H:\MTRN4230\rvctools\rvctools'
% addpath 'H:\MTRN4230\MATLAB_UR5e_RTDE-main\MATLAB_UR5e_RTDE-main\rtde'

clear all;
close ALL;
startup_rvc; % Startup the rvc toolbox
load hershey; % Load in the hershey fonts

% PART B Variables

x_pos = -588.53; % Default
y_pos = -133.30; % Default
%x_pos = -300;
%y_pos = -300;
z_pos = 4.3;
rotation_offset = 0;


validInput = false;
while ~validInput
    fprintf('\n');
    inputString = input('Enter input in the format [integer] [operation] [integer] = ', 's');
    parts = strsplit(inputString, ' ');
    
    % Extract input parts
    num1 = str2double(parts{1});
    operation = parts{2};
    num2 = str2double(parts{3});
    
    % Perform input differentiation
    if ~isnan(num1) && ~isnan(num2) && ismember(operation, {'+', '-', '*'})
        switch operation
            case '+'
                result = num1 + num2;
            case '-'
                result = num1 - num2;
            case '*'
                operation = 'x';
                result = num1 * num2;
        end
        disp(['Result: ' num2str(result)]);
        validInput = true;
    else
        disp('Invalid input. Please enter in the format [integer] [operation] [integer].');
    end
end

% Lines to write in long operations form
allstrings = {};
allstrings{1} = num2str(num1);
allstrings{2} = [num2str(num2) operation];
allstrings{3} = num2str(result);

scale = 0.04; % Select the scale of the digit. 1 = 100%, 0.1 = 10% scale
spacing = 0.04;
current = 0.5;

allpaths = {};
for n = 1:3
    write = allstrings{n};
    paths = {};
    for q = 1:length(write)
        character = hershey{write(q)}; % Select the letter that you want to draw (Letter or number works)
        %char_width = max(character.stroke(1,:)) - min(character.stroke(1,:));

        path = [scale*character.stroke; zeros(1,numcols(character.stroke))]; % create the path 
        % Where ever there is an nan it indicates that we need to lift up.
        k = find(isnan(path(1,:)));

        % At these positions add in a z height
        path(:,k) = path(:,k-1); 
        path(3,k) = 0.2*scale; % Determine the hight of the lift up motions. 0.2 * scale is the height. 0.2 is in m
        path(:,end+1) = [path(1,end); path(2,end); 0.2*scale]; % Add lift up after last stroke

        traj = [path'*1000]; % convert to the mm units so that we can use the rtde toolbox
       
        traj(:, 1) = traj(:, 1) + current;
        current = max(traj(:, 1)) + (spacing) * 1000 * scale;

        rotation = rot2(rotation_offset, 'deg');
        traj(:,1:2) = (rotation * traj(:,1:2)')';
        paths{q} = traj; % Assign traj to a cell of pathsi
    end
    current = 0;
    allpaths{n} = paths;
end


% % After all paths have been generated, create a new loop to plot them
% for i = 1:length(allpaths)
%     traj = allpaths{i}; % Get the i-th path
%     % Plot the path
%     plot3(traj(:,1), traj(:,2), traj(:,3));
%     hold on; % Keep the current plot when adding new plots
% end
% 
% hold off; % No longer keep the current plot when adding new plots
%%
% % TCP Host and Port settings
%host = '127.0.0.1'; % THIS IP ADDRESS MUST BE USED FOR THE VIRTUAL BOX VM
% host = '192.168.230.128'; % THIS IP ADDRESS MUST BE USED FOR THE VMWARE
host = '192.168.0.100'; % THIS IP ADDRESS MUST BE USED FOR THE REAL ROBOT
port = 30003;
% 

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
y_off_curr = 0;
for o = 1:3
    y_pos = y_pos - y_off_curr - (spacing * 1000 * scale);
    paths = allpaths{o};
    for j = 1:length(paths)
        traj = paths{j};
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
        if (max(traj(:,2)) > y_off_curr)
            y_off_curr = max(traj(:,2));
        end

        %  if j < length(paths)
        %     % Get the first pose of the next path
        %     nextTraj = paths{j+1};
        %     nextPose = [(nextTraj(1,1:3) + [x_pos, y_pos, z_pos]),(home(4:6))];
        %     % Now you have lastPose and nextPose
        %     % Execute movec here
        %     rtde.movec(lastPose, nextPose);
        % end
        
    end
end

rtde.drawPath(tcp_poses);
rtde.movej(home);

rtde.close;