 % Own Image threshold
 function [purple_centroids] = purpleDots(hsv_image)

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
    extra_point = [955 728];
    purple_regions = regionprops(refined_purple_mask, 'Centroid');
    purple_centroids = cat(1, purple_regions.Centroid);
    purple_centroids(end+1,:) = extra_point;

    purple_centroids = sortrows(purple_centroids, 2);
    % Sort the top two by x-values
    purple_centroids(1:2,:) = sortrows(purple_centroids(1:2,:), 1);
    % Sort the bottom two by x-values
    purple_centroids(3:4,:) = sortrows(purple_centroids(3:4,:), 1);
    
   
end