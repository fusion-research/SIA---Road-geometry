%% Main program that identifies the road from a map-image

clc
clear all

warning('off', 'images:initSize:adjustingMag')

% Read image of simple road
I = imread('Bild4.png');

% Show original image
figure(1)
imshow(I)

% Cut the image
IR = im2double(cutImage(I(:,:,1)));
IG = im2double(cutImage(I(:,:,2)));
IB = im2double(cutImage(I(:,:,3)));

% Threshold for the RGB-images
IR_thres = IR > getThreshold(IR, 0.5); % 444: 0.25
IG_thres = IG > getThreshold(IG, 0.5); % 444: 0.25
IB_thres = IB > getThreshold(IB, 0.5); % 444: 0.25

% Convert I to a hsv-image and threshold the saturated image
Ihsv = rgb2hsv(I);
IS = cutImage(Ihsv(:,:,2));
IS_thres = IS < getThreshold(IS,0.3);  % 444: 0.4

% Sum all images up to get the best image
I_best = IB_thres+IR_thres+IG_thres+IS_thres;
I_best = I_best > 3;

% Removed noise
InoNoiseRoad = imcomplement(bwareaopen(imcomplement(I_best),300));
InoNoiseR = bwareaopen(InoNoiseRoad, 1000);

IH = cutImage(Ihsv(:,:,1));
IS = cutImage(Ihsv(:,:,2));
IV = cutImage(Ihsv(:,:,3));

IH_thres = IH < getThreshold(IH,0.5); % Doesn't give too much info
IS_thres = IS < getThreshold(IS,0.3); % Good pic to extract the road from!
IV_thres = IV > getThreshold(IV,0.55); % Doesn't give too much info


figure(3)
subplot(2,3,1)
imshow(IR_thres)
title('Red image', 'Fontsize', 14)

subplot(2,3,2)
imshow(IG_thres)
title('Green image', 'Fontsize', 14)

subplot(2,3,3)
imshow(IB_thres)
title('Blue image', 'Fontsize', 14)

subplot(2,3,4)
imshow(IH_thres)
title('Hue image', 'Fontsize', 14)

subplot(2,3,5)
imshow(IS_thres)
title('Saturation image', 'Fontsize', 14)

subplot(2,3,6)
imshow(IV_thres)
title('Value image', 'Fontsize', 14)

%----------------Find white lines------------------------------------

% Threshold for the RGB-images. In Bild2, use 98%
IR_thres = IR > getThreshold(IR, 0.9); % 444: 0.8
IG_thres = IG > getThreshold(IG, 0.9); % 444: 0.8
IB_thres2 = IB > getThreshold(IB, 0.9); % 444: 0.8

% Sum all images up to get the best image
I_bestLines = IB_thres2+IR_thres+IG_thres+IS;
I_bestLines = I_bestLines > 3;

% Removed noise
InoNoiseLines = imcomplement(bwareaopen(imcomplement(I_bestLines),300));
InoNoiseL = bwareaopen(InoNoiseLines, 200);

% Subtract lines from road
IroadLines = InoNoiseR-InoNoiseL;

figure(2)
subplot(1,1,1)
imshow(IroadLines)


