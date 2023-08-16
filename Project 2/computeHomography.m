function [transformation_purple, world_coordinates_orange] = computeHomography(orange_centroids, purple_centroids, world_coordinates_purple)
    
    % Computing the projective transformation for purple dots
    transformation_purple = fitgeotrans(purple_centroids, world_coordinates_purple, 'projective');
    homography_matrix_purple = transformation_purple.T;

    world_coordinates_orange = transformPointsForward(transformation_purple, orange_centroids);
    
    back_projected_points = transformPointsInverse(transformation_purple, world_coordinates_purple)

    disp("Orange Image Coordinates: ")
    disp(orange_centroids)
    disp("Orange World Coordinates: ")
    disp(world_coordinates_orange)

    disp("Purple Image Coordinates: ")
    disp(purple_centroids)

    disp("Purple World Coordinates: ")
    disp(world_coordinates_purple)
    
    disp("Homography Matrix for Purple: ")
    disp(homography_matrix_purple)
    
   
end
