function path = bug2Algo(grid)
    EMPTY = 0;
    WALL = 1;
    BLUE_OBSTACLE = 2;
    PLAYER = 3;
    GOAL = 4;
    % RIGHT = [1 0];
    % LEFT = [-1 0];
    % DOWN = [0 -1];
    % UP = [0 1];

    % Find player and goal positions
    [startX, startY] = find(grid == PLAYER);
    [goalX, goalY] = find(grid == GOAL);
    start = [startX(1), startY(1)];
    goal = [goalX(1), goalY(1)];
    
    % Anonymous function to check if a cell is free or is the goal
    % isFree = @(x, y) grid(x, y) == EMPTY || grid(x, y) == GOAL;
    isObstacle = @(x, y) grid(x, y) == WALL || grid(x, y) == BLUE_OBSTACLE;
    
    path = [];
    current = start;
    path = [path; current];
    while ~isequal(current, goal)
        % [direction] = movementDir(start, goal);

        neighbors = [current(1)-1, current(2); 
                     current(1)+1, current(2); 
                     current(1), current(2)-1; 
                     current(1), current(2)+1];

        neighbors = neighbors(neighbors(:,1) > 0 & neighbors(:,1) <= size(grid, 1) & ...
                    neighbors(:,2) > 0 & neighbors(:,2) <= size(grid, 2), :);

        % First, get all valid neighbors (those within the grid and not diagonal)
        valid_neighbors = neighbors(neighbors(:,1) > 0 & neighbors(:,1) <= size(grid, 1) & ...
                                    neighbors(:,2) > 0 & neighbors(:,2) <= size(grid, 2), :);
        
        % Then I get rid of all the cells that are obstacles
        free_neighbors = valid_neighbors(~arrayfun(isObstacle, valid_neighbors(:,1), valid_neighbors(:,2)), :);
        
        % Then I make sure the cell is not already in the path to visit the
        % same spot
        free_neighbors = free_neighbors(~ismember(free_neighbors, path, 'rows'), :);
        
        % Calculate the Euclidean distance for each free neighbor to the goal
        distances = sqrt(sum((free_neighbors - goal).^2, 2));
        
        % Find the index of the neighbor with the minimum distance
        [~, idx] = min(distances);
        
        % Get the coordinates of the neighbor closest to the goal
        closest_neighbor = free_neighbors(idx, :);
        path = [path; closest_neighbor];
        current = closest_neighbor;
        
    end
    
    path = [path; goal];
end
