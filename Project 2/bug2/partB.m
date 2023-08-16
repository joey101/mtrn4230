map = [
    1 1 1 1 1 1 1 1 1 1;
    1 0 0 0 0 0 0 0 0 1;
    1 0 0 0 1 1 0 0 0 1;
    1 3 0 0 2 2 0 0 0 4;
    1 0 0 0 1 1 0 0 0 1;
    1 0 0 0 0 0 0 0 0 1;
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

% for i = 1:size(path, 1)
%     % Update the map to show the path progress
%     mapCopy = map;
%     mapCopy(path(i, 1), path(i, 2)) = 5; % Mark the path cell
% 
%     % Display the updated map and path
%     imagesc(mapCopy);
%     title(['BUG2 Algorithm Iteration ' num2str(i)]);
%     plot(path(:, 2), path(:, 1), 'g.-'); % Plot path
%     hold off;
% 
%     % Pause for a short duration to observe each iteration
%     pause(0.5);
% 
%     % If this is not the last iteration, hold the image for the next iteration
%     if i < size(path, 1)
%         hold on;
%     end
% end