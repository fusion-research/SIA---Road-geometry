%% Detecting shadows

clc
clear all
clf

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
IG_thres = IG > getThreshold(IG, 0.5);
IB_thres = IB > getThreshold(IB, 0.5);

% Convert I to a hsv-image and threshold the saturated image
Ihsv = rgb2hsv(I);
IS = cutImage(Ihsv(:,:,2));
IS_threshold = getThreshold(IS,0.3);
IS = IS < IS_threshold; % Good pic to extract the road from!

IV = cutImage(Ihsv(:,:,3));
IV_threshold = getThreshold(IV,0.85);
IV = IV > IV_threshold; % Doesn't give too much info

% Sum all images up to get the best image. Works good for 'Bild2' to reduce
%the reflections from the water
% I_best = IB_thres+IR_thres+IG_thres+IS+IV;
% I_best = I_best > 4;

% Sum all images up to get the best image
I_best = IB_thres+IR_thres+IG_thres+IS;
I_best = I_best > 3;
I_best = bwareaopen(I_best, 100);
I_best = bwareaopen(imcomplement(I_best), 300);

% Show images
figure(2)
clf
imshow(I_best)
title('Best image')

% ------------ Detect gray areas -------------------------------------

low = 55;
high = 185;

% Disk filter on each color-image
h = fspecial('disk', 3);
IR_h = filter2(h, IR);
IG_h = filter2(h, IG);
IB_h = filter2(h, IB);

% Make a binary image with two threasholds
IR_darkGray = (IR_h > low/255 & IR_h < high/255);
IG_darkGray = (IG_h > low/255 & IG_h < high/255);
IB_darkGray = (IB_h > low/255 & IB_h < high/255);

% Keep the white pixels that are white in each individual image
I_darkGray = (IR_darkGray+IG_darkGray+IB_darkGray) > 2;

% Noise reduction
I_darkGray = imcomplement(bwareaopen(imcomplement(I_darkGray), 600));
I_darkGray = bwareaopen(I_darkGray, 15000);

I_ultimate = (I_best + I_darkGray) >= 1;

I_ultimate = bwareaopen(I_ultimate, 1000);
I_ultimate = bwareaopen(imcomplement(I_ultimate), 2000);

figure(3)
clf
imshow(I_ultimate)

% ------------ Find white lines -------------------------------------


% Threshold for the RGB-images
IR_thres = IR > getThreshold(IR, 0.90);
IG_thres = IG > getThreshold(IG, 0.90);
IB_thres = IB > getThreshold(IB, 0.90);

% Convert I to a hsv-image and threshold the saturated image
Ihsv = rgb2hsv(I);
IS = cutImage(Ihsv(:,:,2));
IS_threshold = getThreshold(IS,0.1)
IS = IS < IS_threshold; % Good pic to extract the road from!

% Sum all images up to get the best image
I_bestLines = IB_thres+IR_thres+IG_thres+IS;
I_bestLines = I_bestLines > 3;

% Show blue image
figure(4)
clf
imshow(I_bestLines)
title('Best image')


% ------------ Get ultimate image -------------------------------------

% Removed noise from actual road
InoNoiseRoad=imcomplement(bwareaopen(imcomplement(I_ultimate),100));
InoNoise=bwareaopen(InoNoiseRoad, 100);

% Subtract the white lines from the road
IroadLines=InoNoise-I_bestLines;

% Noise reducement
IroadLinesNoNoise=bwareaopen(imcomplement(IroadLines), 100);
IroadLinesNoNoise=imcomplement(bwareaopen(imcomplement(IroadLinesNoNoise), 100));

figure(5)
clf
imshow(IroadLinesNoNoise)
%%
IR(find(IroadLinesNoNoise == 1)) = 1;
imshow(IR)

%% Study of the different gray-histograms

% Read image of simple road
I1 = imread('Bild1.png');
I2 = imread('Bild2.png');
I3 = imread('Bild3.png');
I4 = imread('Bild4.png');
I5 = imread('Bild5.png');
I6 = imread('Bild6.png');


I1 = rgb2gray(I1);
I2 = rgb2gray(I2);
I3 = rgb2gray(I3);
I4 = rgb2gray(I4);
I5 = rgb2gray(I5);
I6 = rgb2gray(I6);

figure(6)
subplot(2,2,1)
imhist(I5)
subplot(2,2,2)
imshow(I5)
subplot(2,2,3)
imhist(I3)
subplot(2,2,4)
imshow(I3)
