map = [
    1 1 1 1 1 1 1 1 1 1;
    1 3 1 4 0 0 0 0 0 1;
    1 0 0 1 2 0 2 1 0 1;
    1 0 0 0 0 0 0 0 0 1;
    1 0 0 1 0 0 2 0 0 1;
    1 0 0 0 0 0 1 0 0 1;
    1 1 1 1 1 1 1 1 1 1];

path = bug2Algo(map);

% Display the path
imagesc(map);
colormap([1 1 1;   % Empty Space - Yellow
          1 0 0;   % Wall or Red Obstacle - Red
          0 0 1;   % Blue Obstacle - Blue
          0 1 0;   % Player Piece - Green
          1 0 1]); % Destination - Magenta
hold on;
grid on;
plot(path(:, 2), path(:, 1), 'g.-'); % Plot path
hold off;