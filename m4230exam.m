startup_rvc
% Step 1: Rotation of 85 degrees about the current x-axis
R1 = trotx(85, 'deg');

% Step 2: Rotation of 105 degrees about the current z-axis
R2 = trotz(105, 'deg');

% Step 3: Rotation of 45 degrees about the fixed z-axis
% Since this is about the fixed axis, it should be applied first
R3 = trotz(45, 'deg');

% Step 4: Rotation of 110 degrees about the current y-axis
R4 = troty(110, 'deg');

% Step 5: Rotation of 85 degrees about the fixed y-axis
% Since this is about the fixed axis, it should be applied first
R5 = troty(85, 'deg');

% Calculate the compound Rotation Matrix
compound_rotation_matrix = R3 * R5 * R1 * R2 * R4

%%
startup_rvc
A1 = [0; 0];
A2 = [220; 0];
A3 = [220; 100];
A4 = [0; 100];

B1 = [30; 60];
B2 = [300; 50];
B3 = [260; 230];
B4 = [60; 180];

C = [80; 160];

img_coordinates = [A1 A2 A3 A4];
world_coordinates = [B1 B2 B3 B4];

tform = fitgeotrans(img_coordinates', world_coordinates', 'projective');
H_matrix = tform.T;

disp(H_matrix);


%%


% Given data
P = [1, 0, 1; 1, 1, 2; 1, 1, 0];
Q = [1, 1, 0; 1, 1, 2; -1, 0, -1];

% Calculate rotational transformation A
A = Q / P;

% Calculate transformation T from frame {0} to frame {2} (from part a)
% Assuming you have calculated compound_rotation_matrix from part a
T = compound_rotation_matrix; % Replace this with the matrix from part a

% Calculate the similarity transformation B of A expressed in frame {2}
B = T * A * inv(T);

% Extract the second row of B
second_row_of_B = B(2, :);

% Display the second row of B
disp('Second row of B matrix:');
disp(second_row_of_B);

