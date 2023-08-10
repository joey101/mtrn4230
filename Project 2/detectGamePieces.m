function [green_centroids, red_centroids, blue_centroids, green_stats, red_stats, blue_stats] = detectGamePieces(hsv_image, ROI_mask)
    % threshold = input("Which Threshold values do you want to use (1-2): ");
    % if threshold == 1
        % % Adjusted HSV thresholds for green (player piece)
        % green_hue_threshold = [0.37, 0.41];
        % green_saturation_threshold = [0.4, 1];
        % green_value_threshold = [0.4, 1];
        % 
        % % % Adjusted HSV thresholds for red (obstacle)
        % red_hue_threshold = [0.95, 1.00];
        % red_saturation_threshold = [0.8, 0.9];
        % red_value_threshold = [0.6, 0.7];
        % 
        % % % HSV thresholds for blue (obstacle)
        % blue_hue_threshold = [0.55, 0.65];
        % blue_saturation_threshold = [0.4, 1];
        % blue_value_threshold = [0.4, 1];
    % else
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
    % end
    
    
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
end
