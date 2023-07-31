%%%%%%%%%%%%%
% MTRN4230 Tutorial Week 8 Solution
% Adapted from Corke ch 5.
startup_rvc;
close all; clear variables; clc;
%dbstop if error
scrsz = get(groot,'ScreenSize'); % Get screen size for plotting

% Construct a 2-link simple planar manipulator, using section 7.2.1 of
% Corke. See 'Tutorial problem 1' in the lecture notes for Kinematics 3.
L(1) = Link([0 0 0.5 0]);
L(2) = Link([0 0 0.5 0]);
one_link = SerialLink(L(1), 'name', 'one link');
two_link = SerialLink(L, 'name', 'two link');
q1 = [0, 0];
q2 = [45, 170]/180*pi;
q3 = [45, -170]/180*pi;
q4 = [-45, -170]/180*pi;

% Define matrix over which configuration space will be sampled
n1 = 100;
min1 = -pi;
max1 = pi
n2 = 100;
min2 = -150/180*pi;
max2 = 150/180*pi;
a = (max1 - min1)/(n1 - 1)
angles1 = min1:(max1 - min1)/(n1 - 1):max1;
size(angles1)
angles2 = min2:(max2 - min2)/(n2 - 1):max2;
config_space_binary = zeros(n1, n2);

% Limits on range of motion in Cartesian plan
y_top = 0.6;
y_bottom = 0;


%% Generate discretised plot of joint space 
for i = angles1
    % Check position at end of first link
    [x1, y1, z1] = transl(one_link.fkine(i));
    for j = angles2
        % If position of first link invalid, flag it.
        if(y1 < y_bottom || y1 > y_top) 
            index_x = angle2cell(i, min1, max1, n1);
            index_y = angle2cell(j, min2, max2, n2);
            config_space_binary(index_x, index_y) = 1;
            continue;
        end
        % Check position at end of second link
        [x2, y2, z2] = transl(two_link.fkine([i, j]));
        if(y2 < y_bottom || y2 > y_top) % If invalid, flag it.
            index_x = angle2cell(i, min1, max1, n1);
            index_y = angle2cell(j, min2, max2, n2);
            config_space_binary(index_x, index_y) = 1;
        end
    end
end
%% Plot this 
% f1 = figure(1);
% set(gcf, 'OuterPosition',[100 100 scrsz(3)/2-100 scrsz(4)/2]);
% imagesc(config_space_binary'); % Note the transpose of the joint space for convenience
% axis xy; % Sets axis with x and y positive directions as expected, not as image coordinates
% xlabel('Joint 1 [index in cell array], corresponding to 0 degrees in the middle')
% ylabel('Joint 2 [index in cell array], corresponding to 0 degrees in the middle')

%% Now try path planning in this configuration space
% First set the goal point, then start point, then the cost map
goal_cell = [70, 90];
start_cell = [52, 52];


%% Probabilistic Roadmap Planner
f3 = figure(1);
%set(gcf, 'OuterPosition',[100 100 scrsz(3)/2-100 scrsz(4)/2]);
prm = PRM(config_space_binary', 'npoints', 200); %%% number of sampling points
prm.plan();
prm_path = prm.query(start_cell, goal_cell);

prm.plot();
hold on
plot(prm_path(:, 1), prm_path(:, 2), 'LineWidth', 4, 'Color', 'g');



% function i = angle2cell(angle, min, max, n)
% Converts an angle into a cell value, given the minimum, maximum angles
% and number of cells.
function i = angle2cell(angle, min, max, n)
    if(angle < min || angle > max), error('angle2cell: angle out of range'); end
    i = round((angle - min) / (max - min) * (n - 1) + 1);  
end


% function angle = cell2angle(i, min, max, n)
% Converts a cell value into an angle, given the minimum, maximum angles
% and number of cells.
function angle = cell2angle(i, min, max, n)
    if(i < 1 || i > n), error('cell2angle: cell out of range'); end
    angle = (i - 1) / (n- 1) * (max - min) + min;
end








