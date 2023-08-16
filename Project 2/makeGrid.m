function grid = makeGrid(boardCord) 
    % boardCord = [min_x; max_x;min_y;max_y];
    % Calculate the number of rows and columns
    num_rows = 8; % Specify the number of rows
    num_cols = 5; % Specify the number of columns
    
    % Calculate step sizes for rows and columns
    row_step = (boardCord(4) - boardCord(3)) / (num_rows - 1);
    col_step = (boardCord(2) - boardCord(1)) / (num_cols - 1);
    
    % Generate row and column indices using linspace
    row_indices = linspace(boardCord(3), boardCord(4), num_rows);
    col_indices = linspace(boardCord(1), boardCord(2), num_cols);
    
    % Create the occupancy grid
    grid = zeros(num_rows, num_cols);
end