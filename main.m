%% Main program that identifies the road from a map-image

clc
clear all

warning('off', 'images:initSize:adjustingMag')

% Read image of simple road
I = imread('Bild4.png');

% % Show original image
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

%% For the presentation

IH = cutImage(Ihsv(:,:,1));
IS = cutImage(Ihsv(:,:,2));
IV = cutImage(Ihsv(:,:,3));

IH_thres = IH < getThreshold(IH,0.3); % Doesn't give too much info
IS_thres = IS < getThreshold(IS,0.3); % Good pic to extract the road from!
IV_thres = IV > getThreshold(IV,0.6); % Doesn't give too much info


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

%%

I = cutImage(I);

I(InoNoiseR == 0) = 0;

imshow(I)

% Edge detection
I = cutImage(I);

h = fspecial('disk',10);

BW1 = edge(I,'Prewitt');
BW2 = edge(I,'Canny');

imshowpair(BW1,BW2,'montage');

%%

figure(8)

IRnorm = IR./(IR+IG+IB+1);
IGnorm = IG./(IR+IG+IB+1);
IBnorm = IB./(IR+IG+IB+1);

subplot(1,3,1)
imshowpair(IR, IRnorm,'montage');

subplot(1,3,2)
imshowpair(IG, IGnorm,'montage');

subplot(1,3,3)
imshowpair(IB, IBnorm,'montage');

%h = fspecial('disk',5);
%IGnorm = imfilter(IGnorm, h);
BW1 = edge(IGnorm,'Prewitt');
BW2 = edge(IGnorm,'Canny');

figure(10)
imshowpair(BW1,BW2,'montage');

%%



I4 = imread('Bild1.png');
I444 = imread('Bild444.png');

% Cut the image
IR = im2double(cutImage(I4(:,:,1)));
IG = im2double(cutImage(I4(:,:,2)));
IB = im2double(cutImage(I4(:,:,3)));

IRnorm4 = IR./(IR+IG+IB+1);
IGnorm4 = IG./(IR+IG+IB+1);
IBnorm4 = IB./(IR+IG+IB+1);

% Cut the image
IR = im2double(cutImage(I444(:,:,1)));
IG = im2double(cutImage(I444(:,:,2)));
IB = im2double(cutImage(I444(:,:,3)));

IRnorm444 = IR./(IR+IG+IB+1);
IGnorm444 = IG./(IR+IG+IB+1);
IBnorm444 = IB./(IR+IG+IB+1);


subplot(2,3,1)
imhist(IRnorm4)

subplot(2,3,2)
imhist(IGnorm4)

subplot(2,3,3)
imhist(IBnorm4)

subplot(2,3,4)
imhist(IRnorm444)

subplot(2,3,5)
imhist(IGnorm444)

subplot(2,3,6)
imhist(IBnorm444)
shg
%-----

IRnorm4 = IRnorm4 < 0.225;
IGnorm4 = IGnorm4 < 0.225;
IBnorm4 = IGnorm4 > 0.225;

IRnorm444 = IRnorm444 < 0.225;
IGnorm444 = IGnorm444 < 0.225;
IBnorm444 = IGnorm444 < 0.225;

figure(9)
subplot(2,3,1)
imshow(IRnorm4)

subplot(2,3,2)
imshow(IGnorm4)

subplot(2,3,3)
imshow(IBnorm4)

subplot(2,3,4)
imshow(IRnorm444)

subplot(2,3,5)
imshow(IGnorm444)

subplot(2,3,6)
imshow(IBnorm444)
shg

%%  Try to displace some color-component
clc

InewB1 = zeros(size(IBnorm));
InewB2 = zeros(size(IBnorm));

displacement = 10;

for i = 1:size(IBnorm,1)-displacement
    for j = 1:size(IBnorm,1)-displacement
        InewB1(i+displacement, j+displacement) = IBnorm(i, j);
    end
end

for i = 1:size(IBnorm,1)-displacement
    for j = 1:size(IBnorm,1)-displacement
        InewB2(i, j) = IBnorm(i+displacement, j+displacement);
    end
end

Icool = (IBnorm+InewB1+InewB2)/3;

subplot(1,1,1)
imshowpair(IBnorm, InewB1, 'montage')
imshowpair(IBnorm, Icool, 'montage')
shg


BW1 = edge(Icool,'Prewitt');
BW2 = edge(Icool,'Canny');

figure(10)
imshowpair(BW1,BW2,'montage');