function [orange_centroids] = orangeDots(hsv_image)
    % threshold = input("Which Threshold values do you want to use (1 (works better on theirs) - 2(works better on mine)): ");
    % if threshold == 1
    %     % Uni Images threshold
    %     orange_hue_threshold = [0.08, 0.10];
    %     orange_saturation_threshold = [0.45, 0.85];
    %     orange_value_threshold = [0.65, 0.95];
    % else
    % Own Image threshold
    orange_hue_threshold = [0.06, 0.12];
    orange_saturation_threshold = [0.50, 0.80];
    orange_value_threshold = [0.70, 0.90];
    % end

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
        
    orange_centroids = sortrows(orange_centroids, 2);
    % Sort the top two by x-values
    orange_centroids(1:2,:) = sortrows(orange_centroids(1:2,:), 1);
    % Sort the bottom two by x-values
    orange_centroids(3:4,:) = sortrows(orange_centroids(3:4,:), 1);
    
    % Changes from 
    % Point | Coordinates   |   Position
    %   1   |   -284, 140   |   Top Left
    %   2   |   672, 154    |   Top Right
    %   3   |   272, 706    |   Bottom Left
    %   4   |   774, 689    |   Bottom Right
    %
    % Real World:
    % Point | Coordinates   |   Position
    %   1   |   272, 706    |   Top Left
    %   2   |   284, 140    |   Top Right
    %   3   |   774, 689    |   Bottom Left
    %   4   |   672,154     |   Bottom Right

    % orange_centroids = orange_centroids([2,1,4,3], :)

end
