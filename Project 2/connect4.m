

con4File = imread('TestImage.jpg');
%imshow(con4File)

maskR = (con4File(:,:,1) > 135)&(con4File(:,:,1) < 155);
maskG = (con4File(:,:,2) > 200)&(con4File(:,:,2) < 220);
maskB = (con4File(:,:,3) > 70)&(con4File(:,:,3) < 90);
mask = maskR&maskG&maskB;
se = strel('disk',7);
mask = imclose(mask, se);
%imshow(mask);

mask = bwareaopen(mask, 100);
imshow(mask);

[centers,radii] = imfindcircles(mask, [20,50]);
hold on;
plot(centers(:,1),centers(:,2),'r*');

% for connecting to lab robot webcam
%camList = webcamlist;
%cam = camlist(1);
%con4File = snapshot(cam);

world = [0 0; 0 450; 650 450; 650 0];
tform = fitgeotrans(centers, world, 'projective');
hold off;
con4FileTrans = imwarp(con4File, tform, outputView=imref2d(size(con4File)));
imshow(imcrop(con4FileTrans, [0 0 650 450]));

