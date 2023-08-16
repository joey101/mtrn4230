function grid = popGrid(redObs, blueObs, playerObs, occGrid)
     % Define grid parameters (cell size, origin)
    cell_size = 60; % in mm
    grid_origin = [5, 1]; % Bottom-left corner of the grid
       
    % Create an empty occupancy grid
    grid_size = size(occGrid);
    grid = occGrid;
    
    % Populate the grid with obstacles based on grid indices
if ~isempty(redObs) 
    red_indices = abs(floor((redObs - grid_origin) / cell_size));

    for i = 1:size(red_indices, 1)
        row = red_indices(i, 2);
        col = red_indices(i, 1);
        
        fprintf('Red Obs - Row: %d, Col: %d\n', row, col); % Debugging output
        
        grid(row, col) = 1; % Mark cell as red obstacle
    end
end

if ~isempty(blueObs)
    blue_indices = abs(floor((blueObs - grid_origin) / cell_size));

    for i = 1:size(blue_indices, 1)
        row = blue_indices(i, 2);
        col = blue_indices(i, 1);
        
        fprintf('Blue Obs - Row: %d, Col: %d\n', row, col); % Debugging output
        
        grid(row, col) = 2; % Mark cell as blue obstacle
    end
end

if ~isempty(playerObs)
    player_indices = abs(floor((playerObs - grid_origin) / cell_size));

    for i = 1:size(player_indices, 1)
        row = player_indices(i, 2);
        col = player_indices(i, 1);
        
        fprintf('Player Obs - Row: %d, Col: %d\n', row, col); % Debugging output
        
        grid(row, col) = 3; % Mark cell as player piece
    end
end


end