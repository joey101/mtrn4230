
function moveRobot(orange_centroids)
  

    % Setting + moving to home
    home = [-588.53, -133.30, 227.00, 2.221, 2.221, 0.00];
    rtde.movej(home);
    disp("Home"); pause(2);
    
    % Move to each corner
    rtde.movel([orange_centroids(1,:) 227.00 2.221 2.221 0.00]);
    disp("Corner 1");pause(2);
    rtde.movel([orange_centroids(2,:) 227.00 2.221 2.221 0.00]);
    disp("Corner 2"); pause(2);
    rtde.movel([orange_centroids(3,:) 227.00 2.221 2.221 0.00]);
    disp("Corner 3"); pause(2);
    rtde.movel([orange_centroids(4,:) 227.00 2.221 2.221 0.00]);
    disp("Corner 4");
    rtde.close;


end