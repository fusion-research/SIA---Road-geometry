%% Simple road

% Read image of simple road
I = imread('Bild4.png');

% Show original image
figure(1)
imshow(I)
title('Original image')

% Cut the image
IR=im2double(cutImage(I(:,:,1)));
IG=im2double(cutImage(I(:,:,2)));
IB=im2double(cutImage(I(:,:,3)));

% Threshold for the RGB-images
IR_thres = IR > getThreshold(IR, 0.5);
IG_thres = IG > getThreshold(IR, 0.5);
IB_thres = IB > getThreshold(IR, 0.5);

% Convert I to a hsv-image and threshold the saturated image
Ihsv = rgb2hsv(I);
IS = cutImage(Ihsv(:,:,2));
IS_threshold = getThreshold(IS,0.3)
IS = IS < IS_threshold; % Good pic to extract the road from!

% Sum all images up to get the best image
I_best = IB_thres+IR_thres+IG_thres+IS;
I_best = I_best > 3;

% Show images
figure(2)
subplot(2,3,1)
imshow(IR_thres)
title('Red image')

subplot(2,3,2)
imshow(IG_thres)
title('Green image')

subplot(2,3,3)
imshow(IB_thres)
title('Blue image')

subplot(2,3,4)
imshow(IS)
title('Saturated image')

subplot(2,3,5)
imshow(I_best)
title('Best image')

%% Find the contours in the image

Icontour = findContour(I_best, 5/8);

subplot(2,3,6)
imshow(Icontour)
title('Contours')

%% Find lines and fill the area between the lines

%% Given the boundaries, fill the image


%% Find white lines

% Threshold for the RGB-images
IR_thres = IR > getThreshold(IR, 0.9);
IG_thres = IG > getThreshold(IR, 0.9);
IB_thres = IB > getThreshold(IR, 0.9);

% Sum all images up to get the best image
I_bestLines = IB_thres+IR_thres+IG_thres+IS;
I_bestLines = I_bestLines > 3;

imshow(I_bestLines)

% Show blue image
figure(2)
subplot(2,3,1)
imshow(IR_thres)
title('Red image')

subplot(2,3,2)
imshow(IG_thres)
title('Green image')

subplot(2,3,3)
imshow(IB_thres)
title('Blue image')

subplot(2,3,4)
imshow(IS)
title('Saturated image')

subplot(2,3,5)
imshow(I_bestLines)
title('Best image')

% Convert I to a hsv-image and threshold the saturated image
Ihsv = rgb2hsv(I);
IS = cutImage(Ihsv(:,:,2));
IS_threshold = getThreshold(IS,0.3)
IS = IS < IS_threshold; % Good pic to extract the road from!

%% Fill all holes

tic
I_filled = fillHoles(I_best, 0.8); 
toc

figure(5)
clf

subplot(1,2,1)
imshow(I_best)
title('Not filled')

subplot(1,2,2)
imshow(I_filled)
title('Filled')

%% RGB to HSV

Ihsv = rgb2hsv(I);

IH = cutImage(Ihsv(:,:,1));
IS = cutImage(Ihsv(:,:,2));
IV = cutImage(Ihsv(:,:,3));

IH_threshold = getThreshold(IH,0.7)
IS_threshold = getThreshold(IS,0.3)
IV_threshold = getThreshold(IV,0.8)

IH = IH < IH_threshold; % Doesn't give too much info
IS = IS < IS_threshold; % Good pic to extract the road from!
IV = IV < IV_threshold; % Doesn't give too much info

imshow(IS);