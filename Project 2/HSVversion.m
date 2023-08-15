clear all

% preview(webcam(1))
% img = snapshot(cam);

% ++++++++++++++ MINE +++++++++++++++++++
load('imgdata.mat');
img2 = imcrop(img1, [345.510	7.510	1065.980	834.980]);
hsv_image = rgb2hsv(img2);
figure; imshow(img2);
% +++++++++++++++++++++Theres++++++++++++++++
% img2 = imread('4.jpg');
% hsv_image = rgb2hsv(img2);

[orange_centroids] = orangeDots(hsv_image);
[purple_centroids] = purpleDots(hsv_image);
% hold on;
% scatter(orange_centroids(:,1), orange_centroids(:,2), 'y', 'filled');
% % Plot the purple centroids in purple with 'o' marker
% scatter(purple_centroids(:,1), purple_centroids(:,2), 'g', 'filled');
% hold off

% Point | Coordinates   |   Position
%   1   |   -250, 75    |   Top Left
%   2   |   -250, -525  |   Top Right
%   3   |   -900, 75    |   Bottom Left
%   4   |   -900, -525  |   Bottom Right
world_coordinates_purple = [-250 75; -250 -525; -900 75; -900 -525];

[transformation_purple, world_coordinates_orange] = computeHomography(orange_centroids, purple_centroids, world_coordinates_purple); 

img_3 = imwarp(img2, transformation_purple);
hsv_image = rgb2hsv(img_3);
[orange_centroids] = orangeDots(hsv_image);

% Compute the bounding box
min_x = min(orange_centroids(:, 1));
max_x = max(orange_centroids(:, 1));
min_y = min(orange_centroids(:, 2));
max_y = max(orange_centroids(:, 2));

% Define the rectangle for cropping [xmin ymin width height]
rect = [min_x, min_y, max_x-min_x, max_y-min_y];
% Crop the image
cropped_img = imcrop(img_3, rect);
hsv_image = rgb2hsv(cropped_img);

[green_centroids, red_centroids, blue_centroids, green_stats, red_stats, blue_stats] = detectGamePieces(hsv_image);
displayResults(cropped_img, green_centroids, red_centroids, blue_centroids, green_stats, red_stats, blue_stats);

% clear cam