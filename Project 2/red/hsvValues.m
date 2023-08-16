% Load your RGB image
load('imgdata.mat');

img_rgb = imcrop(img1, [345.510	7.510	1065.980	834.980]);
hsvImage = rgb2hsv(img2);

% img_rgb = imread('2.jpg');
% % Convert the RGB image to HSV
% hsvImage = rgb2hsv(img_rgb);


% % Display the RGB image
[orange_centroids] = orangeDots(hsvImage);
[purple_centroids] = purpleDots(hsvImage);

world_coordinates_purple = [-250 75; -250 -525; -900 75; -900 -525];

[transformation_purple, world_coordinates_orange] = computeHomography(orange_centroids, purple_centroids, world_coordinates_purple); 

img_3 = imwarp(img_rgb, transformation_purple);
hsv_image = rgb2hsv(img_3);
[orange_centroids] = orangeDots(hsv_image);

transformed_orange_centroids = transformPointsForward(transformation_purple, orange_centroids(:, 1), orange_centroids(:, 2));


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

figure;
imshow(cropped_img);
title('Click on a pixel to get its HSV values');



% Set up a callback function for mouse clicks
set(gcf, 'WindowButtonDownFcn', @(src, event) clickCallback(src, event, hsvImage));

function clickCallback(src, ~, hsvImage)
    % Get the clicked point's coordinates
    clickPoint = round(get(gca, 'CurrentPoint'));
    x = clickPoint(1, 1);
    y = clickPoint(1, 2);
    
    % Ensure the clicked point is within the image boundaries
    [rows, cols, ~] = size(hsvImage);
    if x < 1 || x > cols || y < 1 || y > rows
        return;
    end
    
    % Get HSV values at the clicked point
    clickedHSV = hsvImage(y, x, :);
    
    % Extract individual HSV values
    hue = clickedHSV(1);
    saturation = clickedHSV(2);
    value = clickedHSV(3);
    
    fprintf('Clicked pixel: Row = %d, Column = %d\n', y, x);
    fprintf('HSV values: H = %.2f, S = %.2f, V = %.2f\n', hue, saturation, value);
end
