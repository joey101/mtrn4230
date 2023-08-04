
%%
% Load the image
camList = webcamlist;
cam = camlist(1);
preview(cam);
con4File = snapshot(cam);

img = imread(con4File);

% Convert the image to HSV color space
img_hsv = rgb2hsv(img);

% Identify the corners of the game board
mask_yellow = img_hsv(:,:,1) > hue_lower_bound_yellow & img_hsv(:,:,1) < hue_upper_bound_yellow;
stats_yellow = regionprops(mask_yellow, 'Centroid');
corners_img = cat(1, stats_yellow.Centroid);

% Calculate the homography matrix
corners_real = [-250, 75; -250, -525; -900, 75; -900, -525];
tform = estimateGeometricTransform(corners_img, corners_real, 'projective');

% Identify the pieces
mask_green = img_hsv(:,:,1) > hue_lower_bound_green & img_hsv(:,:,1) < hue_upper_bound_green;
stats_green = regionprops(mask_green, 'Centroid');
pieces_img = cat(1, stats_green.Centroid);

% Obtain the pose of the pieces
pieces_real = transformPointsForward(tform, pieces_img);

