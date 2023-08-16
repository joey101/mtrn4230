function grid = popGrid(redObs, blueObs, playerObs, occGrid)
     % Define grid parameters (cell size, origin)
    cell_size = 60; % in mm
    grid_origin = [0, 0]; % Bottom-left corner of the grid
    
    % Calculate grid indices for each real-world coordinate
    red_indices = floor((redObs - grid_origin) / cell_size) + 1;
    blue_indices = floor((blueObs - grid_origin) / cell_size) + 1;
    player_indices = floor((playerObs - grid_origin) / cell_size) + 1;
    % des_indices = floor((desObs - grid_origin) / cell_size) + 1;
    
    % Create an empty occupancy grid
    grid_size = size(occGrid);
    grid = occGrid;
    
    % Populate the grid with obstacles based on grid indices
    for i = 1:size(red_indices, 1)
        row = red_indices(i, 2);
        col = red_indices(i, 1);
        grid(row, col) = 1; % Mark cell as red obstacle
    end
    
    for i = 1:size(blue_indices, 1)
        row = blue_indices(i, 2);
        col = blue_indices(i, 1);
        grid(row, col) = 2; % Mark cell as blue obstacle
    end
    
    for i = 1:size(player_indices, 1)
        row = player_indices(i, 2);
        col = player_indices(i, 1);
        grid(row, col) = 3; % Mark cell as player piece
    end
    
    % for i = 1:size(des_indices, 1)
    %     row = des_indices(i, 2);
    %     col = des_indices(i, 1);
    %     grid(row, col) = 4; % Mark cell as destination
    % end

end