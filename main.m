%% Main program that identifies the road from a map-image

clc
clear all

warning('off', 'images:initSize:adjustingMag')

% Read image of simple road
I = imread('Bild6.png');

% % Show original image
figure(1)
imshow(I)

% Cut the image
IR = im2double(cutImage(I(:,:,1)));
IG = im2double(cutImage(I(:,:,2)));
IB = im2double(cutImage(I(:,:,3)));

% Threshold for the RGB-images
IR_thres = IR > getThreshold(IR, 0.50);
IG_thres = IG > getThreshold(IG, 0.50);
IB_thres = IB > getThreshold(IB, 0.50);

% Convert I to a hsv-image and threshold the saturated image
Ihsv = rgb2hsv(I);
IS = cutImage(Ihsv(:,:,2));
IS_threshold = getThreshold(IS,0.3);
IS = IS < IS_threshold; % Good pic to extract the road from!

% Sum all images up to get the best image
I_best = IB_thres+IR_thres+IG_thres+IS;
I_best = I_best > 3;

% Removed noise
InoNoiseRoad = imcomplement(bwareaopen(imcomplement(I_best),300));
InoNoiseR = bwareaopen(InoNoiseRoad, 1000);

%----------------Find white lines------------------------------------

% Threshold for the RGB-images. In Bild2, use 98%
IR_thres = IR > getThreshold(IR, 0.9);
IG_thres = IG > getThreshold(IG, 0.9);
IB_thres2 = IB > getThreshold(IB, 0.9);

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
