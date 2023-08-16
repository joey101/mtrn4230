function displayResults(img_3, green_centroids, red_centroids, blue_centroids, green_stats, red_stats, blue_stats)
   % Displaying the detected centroids on the image
   
    figure; imshow(img_3); title('Refined Detection of Game Pieces');
   
    hold on;
    
    % Check if green regions are detected
    if ~isempty(green_centroids)
        scatter(green_centroids(:, 1), green_centroids(:,2), 'g', 'filled'); % Player piece in green
        for k = 1:length(green_stats)
            rectangle('Position', green_stats(k).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2);
        end
    end
    
    % Check if red regions are detected
    if ~isempty(red_centroids)
        scatter(red_centroids(:, 1), red_centroids(:,2), 'r', 'filled');     % Obstacle in red
        for k = 1:length(red_stats)
            rectangle('Position', red_stats(k).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
        end
    end
    
    % Check if blue regions are detected
    if ~isempty(blue_centroids)
        scatter(blue_centroids(:, 1), blue_centroids(:,2), 'b', 'filled');   % Obstacle in blue
        for k = 1:length(blue_stats)
            rectangle('Position', blue_stats(k).BoundingBox, 'EdgeColor', 'b', 'LineWidth', 2);
        end
    end
    
    hold off;
end
