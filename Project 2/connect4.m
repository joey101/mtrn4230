
%%
% Connect to the webcam
% Preview the webcam
cam = webcam(1);
preview(webcam(1));


% Capture one frame from the webcam
rgb_image = snapshot(cam);

% Define the lower and upper bounds for the HSV values
hsv_lower_bound = [0.1, 0.2, 0.3]; % Replace with your values
hsv_upper_bound = [0.4, 0.5, 0.6]; % Replace with your values

% Convert the RGB image to an HSV image
hsv_image = rgb2hsv(rgb_image);

% Create a mask that identifies the pixels in the HSV image that are within the specified bounds
mask = hsv_image(:,:,1) >= hsv_lower_bound(1) & hsv_image(:,:,1) <= hsv_upper_bound(1) & ...
       hsv_image(:,:,2) >= hsv_lower_bound(2) & hsv_image(:,:,2) <= hsv_upper_bound(2) & ...
       hsv_image(:,:,3) >= hsv_lower_bound(3) & hsv_image(:,:,3) <= hsv_upper_bound(3);

% Apply the mask to the RGB image
masked_rgb_image = bsxfun(@times, rgb_image, cast(mask, 'like', rgb_image));

% Display the masked image
imshow(masked_rgb_image);

% Clear the webcam
clear cam;


