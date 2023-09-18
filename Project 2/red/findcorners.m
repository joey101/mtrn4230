% Visualize the detected centroids on the original image
clear all
load('../imgdata.mat');
% figure; imshow(img1); title('Original Image');
% img1 = imcrop(img1,[307.5 0.5 1613 1080]);

hsv_image = rgb2hsv(img1);
figure; imshow(hsv_image);
hold on;
scatter(purple_centroids(:,1), purple_centroids(:,2), 'g', 'filled');
for i = 1:size(purple_centroids, 1)
    text(purple_centroids(i,1), purple_centroids(i,2), num2str(i), 'Color', 'red');
end
% Assuming purple_centroids is the matrix containing the detected centroids

% Print the centroids
disp('Detected Purple Centroids:');
purple_centroids(4, :) = [];
for i = 1:size(purple_centroids, 1)
    fprintf('Centroid %d: (%f, %f)\n', i, purple_centroids(i, 1), purple_centroids(i, 2));
end
imshow(hsv_image);
hold on;
plot(purple_centroids(:,1), purple_centroids(:,2), 'ro');

hold off;
