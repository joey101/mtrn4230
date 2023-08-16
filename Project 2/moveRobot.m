
function moveRobot(orange_centroids)
    host = '127.0.0.1'
    host = '192.168.0.100'
    port = 30003;
    
    % Calling the constructor of rtde to setup tcp connction
    rtde = rtde(host,port);

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

end