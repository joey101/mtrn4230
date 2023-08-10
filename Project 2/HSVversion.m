%% Part A: Computer Vision for Game Board Detection
clear all;
close all;

% Load the image data
load('imgdata.mat');
figure; imshow(img1); title('Original Image');
% img_rgb = imread('1.jpg');
% Convert the RGB image to HSV
% hsv_image = rgb2hsv(img_rgb);
hsv_image = rgb2hsv(img1);
figure; imshow(hsv_image); title('HSV Image');


%% Point 1: Identify the four corners of the game board using the top-down view provided by the webcam.
% Using HSV thresholds to detect orange regions in the image (corners of the game board).

% Uni Images threshold
% orange_hue_threshold = [0.08, 0.10];
% orange_saturation_threshold = [0.45, 0.85];
% orange_value_threshold = [0.65, 0.95];

% Own Image threshold
orange_hue_threshold = [0.06, 0.12];
orange_saturation_threshold = [0.50, 0.80];
orange_value_threshold = [0.70, 0.90];


hue_threshold_orange = (hsv_image(:,:,1) >= orange_hue_threshold(1) & hsv_image(:,:,1) <= orange_hue_threshold(2));
saturation_threshold_orange = (hsv_image(:,:,2) >= orange_saturation_threshold(1) & hsv_image(:,:,2) <= orange_saturation_threshold(2));
value_threshold_orange = (hsv_image(:,:,3) >= orange_value_threshold(1) & hsv_image(:,:,3) <= orange_value_threshold(2));

orange_mask = hue_threshold_orange & saturation_threshold_orange & value_threshold_orange;

% Applying morphological operations to refine the mask
structuring_element = strel('disk', 7);
closed_orange_mask = imclose(orange_mask, structuring_element);
refined_orange_mask = bwareaopen(closed_orange_mask, 100);

% Detecting centroids of the orange regions
orange_regions = regionprops(refined_orange_mask, 'Centroid');
orange_centroids = cat(1, orange_regions.Centroid);

% Displaying the detected centroids on the image
figure; imshow(img1); title('Detected Corners');
% figure; imshow(img_rgb); title('Detected Corners');

hold on;
scatter(orange_centroids(:, 1), orange_centroids(:,2), 'r', 'filled');
hold off;

%% Point 2: Calculate the homography matrix and complete a projective transform.
% Defining image coordinates of detected centroids and their corresponding real-world coordinates
image_coordinates = [orange_centroids(4, 1) orange_centroids(4, 2); 
                     orange_centroids(3, 1) orange_centroids(3, 2); 
                     orange_centroids(2, 1) orange_centroids(2, 2); 
                     orange_centroids(1, 1) orange_centroids(1, 2)];

world_coordinates = [-900 525; -900 75; -250 -525; -250 75];

% Computing the projective transformation
transformation = fitgeotrans(image_coordinates, world_coordinates, 'projective');
homography_matrix = transformation.T;

%% Point 3: Obtain the pose of each of the corners in reference to the robot's base joint.
real_corner1 = transformPointsForward(transformation, [orange_centroids(1, 1) orange_centroids(1, 2)]);
real_corner2 = transformPointsForward(transformation, [orange_centroids(2, 1) orange_centroids(2, 2)]);
real_corner3 = transformPointsForward(transformation, [orange_centroids(3, 1) orange_centroids(3, 2)]);
real_corner4 = transformPointsForward(transformation, [orange_centroids(4, 1) orange_centroids(4, 2)]);

% Displaying the transformation matrix
disp(homography_matrix);

%% Restrict detection to within the four corners
% rows = size(img_rgb, 1);
% cols = size(img_rgb, 2);
rows = size(img1, 1);
cols = size(img1, 2);
ROI_mask = poly2mask(orange_centroids(:,1), orange_centroids(:,2), rows, cols);

%% Point 4: Identify the location of each of the obstacle and player piece on the gameboard

% ==================My Own
% Adjusted HSV thresholds for green (player piece)
% green_hue_threshold = [0.37, 0.41];
% green_saturation_threshold = [0.4, 1];
% green_value_threshold = [0.4, 1];
% 
% % Adjusted HSV thresholds for red (obstacle)
% red_hue_threshold = [0.95, 1.00];
% red_saturation_threshold = [0.8, 0.9];
% red_value_threshold = [0.6, 0.7];
% 
% % HSV thresholds for blue (obstacle)
% blue_hue_threshold = [0.55, 0.65];
% blue_saturation_threshold = [0.4, 1];
% blue_value_threshold = [0.4, 1];

% =====================
% Adjusted HSV thresholds for green (player piece)
green_hue_threshold = [0.33, 0.43];
green_saturation_threshold = [0.45, 1];
green_value_threshold = [0.45, 1];

% Adjusted HSV thresholds for red (obstacle)
red_hue_threshold = [0.93, 1.00];
red_saturation_threshold = [0.75, 1];
red_value_threshold = [0.55, 0.75];

% Adjusted HSV thresholds for blue (obstacle)
blue_hue_threshold = [0.53, 0.67];
blue_saturation_threshold = [0.45, 1];
blue_value_threshold = [0.45, 0.85];

% Create masks based on the thresholds
green_mask = (hsv_image(:,:,1) >= green_hue_threshold(1) & hsv_image(:,:,1) <= green_hue_threshold(2)) & ...
             (hsv_image(:,:,2) >= green_saturation_threshold(1) & hsv_image(:,:,2) <= green_saturation_threshold(2)) & ...
             (hsv_image(:,:,3) >= green_value_threshold(1) & hsv_image(:,:,3) <= green_value_threshold(2));

red_mask = (hsv_image(:,:,1) >= red_hue_threshold(1) & hsv_image(:,:,1) <= red_hue_threshold(2)) & ...
           (hsv_image(:,:,2) >= red_saturation_threshold(1) & hsv_image(:,:,2) <= red_saturation_threshold(2)) & ...
           (hsv_image(:,:,3) >= red_value_threshold(1) & hsv_image(:,:,3) <= red_value_threshold(2));

blue_mask = (hsv_image(:,:,1) >= blue_hue_threshold(1) & hsv_image(:,:,1) <= blue_hue_threshold(2)) & ...
            (hsv_image(:,:,2) >= blue_saturation_threshold(1) & hsv_image(:,:,2) <= blue_saturation_threshold(2)) & ...
            (hsv_image(:,:,3) >= blue_value_threshold(1) & hsv_image(:,:,3) <= blue_value_threshold(2));

% Apply the ROI mask to the color-segmented masks
green_mask = green_mask & ROI_mask;
red_mask = red_mask & ROI_mask;
blue_mask = blue_mask & ROI_mask;

% Obtain the centroids for each refined mask
green_stats = regionprops(green_mask, 'Centroid', 'BoundingBox');
green_centroids = cat(1, green_stats.Centroid);

red_stats = regionprops(red_mask, 'Centroid', 'BoundingBox');
red_centroids = cat(1, red_stats.Centroid);

blue_stats = regionprops(blue_mask, 'Centroid', 'BoundingBox');
blue_centroids = cat(1, blue_stats.Centroid);

% Displaying the detected centroids on the image
% figure; imshow(img_rgb); title('Refined Detection of Game Pieces');
figure; imshow(img1); title('Refined Detection of Game Pieces');

hold on;

% Check if green regions are detected
if ~isempty(green_centroids)
    scatter(green_centroids(:, 1), green_centroids(:,2), 'g', 'filled'); % Player piece in green
    for k = 1:length(green_stats)
        rectangle('Position', green_stats(k).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2);
    end
end

% Check if red regions are detected
if ~isempty(red_centroids)
    scatter(red_centroids(:, 1), red_centroids(:,2), 'r', 'filled');     % Obstacle in red
    for k = 1:length(red_stats)
        rectangle('Position', red_stats(k).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
    end
end

% Check if blue regions are detected
if ~isempty(blue_centroids)
    scatter(blue_centroids(:, 1), blue_centroids(:,2), 'b', 'filled');   % Obstacle in blue
    for k = 1:length(blue_stats)
        rectangle('Position', blue_stats(k).BoundingBox, 'EdgeColor', 'b', 'LineWidth', 2);
    end
end

hold off;