function [hsv_image, img_rgb] = loadImage()
    txt = input("Is it a JPG or .mat input (1 or 0): ");
    if txt == 1
        image = input("Which number jpg do you want (1-7): ");
        img_rgb = imread(append(string(image), '.jpg'));
        hsv_image = rgb2hsv(img_rgb);
    else
        load('imgdata.mat');
        hsv_image = rgb2hsv(img1);
        img_rgb = img1; % For consistency
        
        figure; imshow(img1); title('Original Image');

    end
end
% [307.5 0.5 1613 1080]
