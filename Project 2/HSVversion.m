clear all

% cam = webcam(1)
% img2 = snapshot(cam);

% % ++++++++++++++ MINE +++++++++++++++++++
load('imgdata.mat');
img2 = imcrop(img1, [345.510	7.510	1065.980	834.980]);
hsv_image = rgb2hsv(img2);
figure; imshow(img2);
% +++++++++++++++++++++Theres++++++++++++++++
% img2 = imread('2.jpg');
% hsv_image = rgb2hsv(img2);

[orange_centroids] = orangeDots(hsv_image);
[purple_centroids] = purpleDots(hsv_image);


hold on;
scatter(orange_centroids(:,1), orange_centroids(:,2), 'y', 'filled');
scatter(purple_centroids(:,1), purple_centroids(:,2), 'g', 'filled');

% Annotate the corners with labels
corner_labels = {'Corner 1', 'Corner 2', 'Corner 3', 'Corner 4'};
for i = 1:size(purple_centroids, 1)
    text(purple_centroids(i, 1), purple_centroids(i, 2), corner_labels{i}, 'Color', 'g', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end
for i = 1:size(orange_centroids, 1)
    text(orange_centroids(i, 1), orange_centroids(i, 2), corner_labels{i}, 'Color', 'y', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
end

hold off

% Point | Coordinates   |   Position
%   1   |   -250, 75    |   Top Left
%   2   |   -250, -525  |   Top Right
%   3   |   -900, 75    |   Bottom Left
%   4   |   -900, -525  |   Bottom Right
world_coordinates_purple = [-250 75; -250 -525; -900 75; -900 -525];
% orange_centroids = orange_centroids([2,1,4,3], :)
% purple_centroids = purple_centroids([2,1,4,3], :);

[transformation_purple, world_coordinates_orange] = computeHomography(orange_centroids, purple_centroids, world_coordinates_purple); 

img_3 = imwarp(img2, transformation_purple);
hsv_image = rgb2hsv(img_3);
[orange_centroids] = orangeDots(hsv_image);

transformed_orange_centroids = transformPointsForward(transformation_purple, orange_centroids(:, 1), orange_centroids(:, 2));
transformed_orange_centroids_IKD  = transformed_orange_centroids

% Compute the bounding box
min_x = min(orange_centroids(:, 1));
max_x = max(orange_centroids(:, 1));
min_y = min(orange_centroids(:, 2));
max_y = max(orange_centroids(:, 2));
% boardCord = [min_x; max_x;min_y;max_y];
% occGrid = makeGrid(boardCord)

% Define the rectangle for cropping [xmin ymin width height]
rect = [min_x, min_y, max_x-min_x, max_y-min_y];

% Crop the image
cropped_img = imcrop(img2, rect);
hsv_image2 = rgb2hsv(cropped_img);
% figure; imshow(cropped_img);

[green_centroids, red_centroids, blue_centroids, green_stats, red_stats, blue_stats] = detectGamePieces(hsv_image2);
% 
% transformed_green_centroids = transformPointsForward(transformation_purple, green_centroids);
% transformed_red_centroids = transformPointsForward(transformation_purple, red_centroids);
% transformed_blue_centroids = transformPointsForward(transformation_purple, blue_centroids);
% 
% grid_with_obstacles = popGrid(transformed_red_centroids, transformed_blue_centroids, transformed_green_centroids, occGrid)
% 
displayResults(cropped_img, green_centroids, red_centroids, blue_centroids, green_stats, red_stats, blue_stats);


%%
% startup_rvc;
% % host = '127.0.0.1'
% host = '192.168.0.100'
% port = 30003;
% 
% % Calling the constructor of rtde to setup tcp connction
% rtde = rtde(host,port);
% moveRobot(transformed_orange_centroids_IKD);
% clear cam