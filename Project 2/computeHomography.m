function [transformation,transformation_purple, homography_matrix] = computeHomography(orange_centroids, purple_centroids)
    image_coordinates = [orange_centroids(4, 1) orange_centroids(4, 2); 
                         orange_centroids(3, 1) orange_centroids(3, 2); 
                         orange_centroids(2, 1) orange_centroids(2, 2); 
                         orange_centroids(1, 1) orange_centroids(1, 2)];
    
    image_coordinates_purple = [purple_centroids(4, 1) purple_centroids(4, 2); 
                               purple_centroids(3, 1) purple_centroids(3, 2); 
                               purple_centroids(2, 1) purple_centroids(2, 2); 
                               purple_centroids(1, 1) purple_centroids(1, 2)];

    
    world_coordinates = [-900 525; -900 75; -250 -525; -250 75];

    % Computing the projective transformation
    transformation = fitgeotrans(image_coordinates, world_coordinates, 'projective');
    homography_matrix = transformation.T;

    % Computing the projective transformation for purple dots
    transformation_purple = fitgeotrans(image_coordinates_purple, world_coordinates, 'projective');
    homography_matrix_purple = transformation_purple.T;
end
