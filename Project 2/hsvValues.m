% Load your RGB image
load('imgdata.mat');
% 
% % Convert RGB image to HSV
% hsvImage = rgb2hsv(img1);

img_rgb = imread('6.jpg');
% Convert the RGB image to HSV
hsvImage = rgb2hsv(img_rgb);
% % Display the RGB image
figure;
imshow(img_rgb);
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
