 % Own Image threshold
 function [purple_centroids, ROI_mask_purple] = purpleDots(hsv_image)

    purple_hue_threshold = [0.67 0.88];
    purple_saturation_threshold = [0.5 1.00];
    purple_value_threshold = [0.3 0.70];

    hue_threshold_purple = (hsv_image(:,:,1) >= purple_hue_threshold(1) & hsv_image(:,:,1) <= purple_hue_threshold(2));
    saturation_threshold_purple = (hsv_image(:,:,2) >= purple_saturation_threshold(1) & hsv_image(:,:,2) <= purple_saturation_threshold(2));
    value_threshold_purple = (hsv_image(:,:,3) >= purple_value_threshold(1) & hsv_image(:,:,3) <= purple_value_threshold(2));
    
    purple_mask = hue_threshold_purple & saturation_threshold_purple & value_threshold_purple;
    
    % Applying morphological operations to refine the mask
    structuring_element = strel('disk', 7);
    closed_purple_mask = imclose(purple_mask, structuring_element);
    refined_purple_mask = bwareaopen(closed_purple_mask, 100);
    
    

    % Detecting centroids of the purple regions
    extra_point = [1300 740];
    purple_regions = regionprops(refined_purple_mask, 'Centroid');
    purple_centroids = cat(1, purple_regions.Centroid);
    purple_centroids(1,:) = extra_point;

    % Define a threshold for comparison
    threshold = 1e-4; % Adjust this value if needed

    % Remove the centroid with x-value close to 114.741782
    toRemove = abs(detected_purple_centroids(:,1) - 114.741782) < threshold;
    detected_purple_centroids(toRemove, :) = [];
    
    purple_centroids = sortrows(purple_regions, 2);
    purple_centroids = [sortrows(purple_centroids(1:2, :), 1); sortrows(purple_centroids(3:4, :), 1)];


    rows = size(hsv_image, 1);
    cols = size(hsv_image, 2);
    ROI_mask_purple = poly2mask(purple_centroids(:,1), purple_centroids(:,2), rows, cols); 
   
end