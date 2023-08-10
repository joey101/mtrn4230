%% Part A: Computer Vision for Game Board Detection
clear all;

% Load the image data
load('imgdata.mat');
imshow(img1);

% Point 1: Identify the four corners of the game board using the top-down view provided by the webcam.
% Using RGB thresholds to detect yellowish regions in the image (presumably the corners of the game board).
red_threshold = (img1(:,:,1) <= 230 & img1(:,:,1) >= 185);
green_threshold = (img1(:,:,2) <= 170 & img1(:,:,2) >= 120);
blue_threshold = (img1(:,:,3) <= 100 & img1(:,:,3) >= 60);

yellow_mask = red_threshold & green_threshold & blue_threshold;

% Applying morphological operations to refine the mask
structuring_element = strel('disk', 7);
closed_mask = imclose(yellow_mask, structuring_element);
refined_mask = bwareaopen(closed_mask, 100);

% Detecting centroids of the yellow regions
yellow_regions = regionprops(refined_mask, 'Centroid');
yellow_centroids = cat(1, yellow_regions.Centroid);

% Displaying the detected centroids on the image
hold on;
scatter(yellow_centroids(:, 1), yellow_centroids(:,2), 'r', 'filled');
hold off;

% Point 2: Calculate the homography matrix and complete a projective transform.
% Defining image coordinates of detected centroids and their corresponding real-world coordinates
image_coordinates = [yellow_centroids(4, 1) yellow_centroids(4, 2); 
                     yellow_centroids(3, 1) yellow_centroids(3, 2); 
                     yellow_centroids(2, 1) yellow_centroids(2, 2); 
                     yellow_centroids(1, 1) yellow_centroids(1, 2)];

world_coordinates = [-900 525; -900 75; -250 -525; -250 75];

% Computing the projective transformation
transformation = fitgeotrans(image_coordinates, world_coordinates, 'projective');
homography_matrix = transformation.T;

% Point 3: Obtain the pose of each of the corners in reference to the robot’s base joint.
real_corner1 = transformPointsForward(transformation, [yellow_centroids(1, 1) yellow_centroids(1, 2)]);
real_corner2 = transformPointsForward(transformation, [yellow_centroids(2, 1) yellow_centroids(2, 2)]);
real_corner3 = transformPointsForward(transformation, [yellow_centroids(3, 1) yellow_centroids(3, 2)]);
real_corner4 = transformPointsForward(transformation, [yellow_centroids(4, 1) yellow_centroids(4, 2)]);

% Displaying the transformation matrix
disp(homography_matrix);

% Note: Point 4 is not addressed in this code. Additional color thresholding or segmentation techniques are needed.




