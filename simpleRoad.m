%% Simple road

% Read image of simple road
I = imread('Bild4.png');

% Show original image
figure(1)
imshow(I)

% Resample image
rate = size(I,2)/size(I,1);
Ir=resample(I,rate);


% Create 3 RGB images
IR =Ir(:,1:length(Ir)/3);
IG =Ir(:, length(Ir)/3+1 : 2*length(Ir)/3);
IB =Ir(:, 2*length(Ir)/3+1 : length(Ir));

% Show 3 RGB images
figure(2)
imshow(Ir)
title('Resampled RBG images')

% Convert to gray-scale
Ig = rgb2gray(I);

% Threshold
IB(IB > 0.95) = 0;

% Show blue image
figure(3)
subplot(1,2,1)
imshow(IB)
title('Blue image')

% Linear filter on blue image
w = [1 1 1; 1 1 1; 1 1 1]/9;
IB = filter2(w, IB);
subplot(1,2,2)
imshow(IB)
title('Linear filter on blue image')

% Linear filter on red image
w = [1 1 1; 1 1 1; 1 1 1]/9;
IR = filter2(w, IR);


% Find white lines
IB_thres = IB > .75;
IR_thres = IR > .85;
IG_thres = IG > .85;
figure(4)
subplot(1,2,1)
imshow(IB_thres)
title('Threshold for red image')

I_best = IB_thres+IR_thres+IG_thres+IS;
I_best = I_best > 3;

subplot(1,2,2)
imshow(I_best)
title('Best image')



%% Prewitt filter on the image to find contours

wy = [-1 -1 -1; 0 0 0; 1 1 1]/6;
wx = [-1 0 1; -1 0 1; -1 0 1]/6;

Ix = filter2(wx, IB);
Iy = filter2(wy, IB);

Ipre = sqrt(Ix.^2 + Iy.^2);

imshow(Ipre)
shg

%% Find grey areas

Igray = zeros(size(IR));

for i=1:length(IR)
    for j=1:length(IR)
        if max([IR(i,j), IG(i,j), IB(i,j)]) - min([IR(i,j), IG(i,j), IB(i,j)]) > 0.09
            Igray(i,j) = 1;
        end
    end
end

imshow(Igray)

%% Fill all holes with neighbours more than 6 that are similar

I_filled = fillHoles(I_best, 0.5); 

figure(5)

subplot(1,2,1)
imshow(I_best)
title('Not filled')

subplot(1,2,2)
imshow(I_filled)
title('Filled')

%% RGB to HSV

Ihsv = rgb2hsv(I);

rate = size(Ihsv,2)/size(Ihsv,1);
Ihsv = resample(Ihsv, rate);
%Ihsv = im2double(Ihsv);

imshow(Ihsv)

IH =Ir(:,1:length(Ir)/3);
IS =Ir(:, length(Ir)/3+1 : 2*length(Ir)/3);
IV =Ir(:, 2*length(Ir)/3+1 : length(Ir));

imshow(IS);
%%

IH_threshold = getThreshold(IH,0.8)
IS_threshold = getThreshold(IS,0.75)
IV_threshold = getThreshold(IV,0.8)

IH = IH > 0.2;
IS = IS > IS_threshold;
IV = IV > 0.7;

imshow(IS);

%imhist(Ihsv(:,:,3))