%% Simple road
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
I_best = bwareaopen(I_best, 200);
I_best = imcomplement(bwareaopen(imcomplement(I_best), 200));

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


% Find the contours in the image
Icontour = findContour(I_best, 2/8, 3/8);

subplot(2,3,6)
imshow(Icontour)
title('Contours')

%%



maxFound=0;
tic
for j=1:length(I)

    V=test3(j,:);
    S = zeros(size(V));
    for i=2:length(V)
        if(V(i-1)==1)
            S(i) = 1 + S(i-1);
        end
    end
    maxFound=max(maxFound, max(S));
end
toc

maxFound


%%

%I=I_best;
I = I_ultimate;

% Removed noise from actual road
InoNoiseRoad=imcomplement(bwareaopen(imcomplement(I),1000));

InoNoise=bwareaopen(InoNoiseRoad, 1000);

IroadLines=InoNoise-I_bestLines;

IroadLinesNoNoise=bwareaopen(imcomplement(IroadLines), 100);
IroadLinesNoNoise=bwareaopen(imcomplement(IroadLinesNoNoise), 5);

figure(5)
clf
subplot(2,1,1)
imshow(IroadLinesNoNoise)

subplot(2,1,2)
imshow(I_bestLines)

%% Divide the image into smaller segments
clc

subplot(1,1,1)
imshow(Icontour)

nbrSegments = 4;

Ismall = getSegments(Icontour, nbrSegments);

figure(3)
clf
for i = 1:nbrSegments
    subplot(sqrt(nbrSegments),sqrt(nbrSegments),i)
    imshow(Ismall(:,:,i))
end


%% Try to find lines with RanSaC

n = 3;
t = 1;
m = 250;
q = 1;

interations = 3;

polySum = zeros(nbrSegments,2);
nbrPoly = zeros(nbrSegments,1);

tic
x = 1:size(Ismall,1);
sqrtSeg = sqrt(nbrSegments);

% Do the RanSaC-algoritm 'iterations' number of times
for k = 1:interations
    % For each image-segment
    for smallImageNrb = 1:nbrSegments;
        
        bestPoly = ransac(Ismall(:,:,smallImageNrb), n, t, m, q);
        
        % If a spline is found, plot it on top of the image
        if size(bestPoly, 2) == 2
            
            nbrPoly(smallImageNrb) = nbrPoly(smallImageNrb) + 1;
            
            y = polyval(bestPoly, x);

            figure(4)
            subplot(sqrtSeg,sqrtSeg,smallImageNrb)
            imagesc([1 x(end)],[1 x(end)],Ismall(:,:,smallImageNrb))
            hold on
            plot(y,x,'r')
            axis([0 x(end) 0 x(end)])
            set(gca,'xtick',[],'ytick',[]);
            
            polySum(smallImageNrb,:) = polySum(smallImageNrb,:) + bestPoly;
            
        % If no spline is found, just display the image-segment
        else
            
            figure(4)
            subplot(sqrtSeg,sqrtSeg,smallImageNrb)
            imshow(Ismall(:,:,smallImageNrb))
            set(gca,'xtick',[],'ytick',[]);
            
        end
        
    end
end
toc

% Find a mean spline for each image-segment
for smallImageNrb = 1:nbrSegments
    polySum(smallImageNrb,:) = polySum(smallImageNrb,:)/nbrPoly(smallImageNrb);
end

% Plot the mean spline for each image-segment
for smallImageNrb = 1:nbrSegments;
    
    y = polyval(polySum(smallImageNrb,:), x);

    figure(4)
    subplot(sqrtSeg,sqrtSeg,smallImageNrb)
    imagesc([1 size(Ismall,1)],[1 size(Ismall,2)],Ismall(:,:,smallImageNrb))
    hold on
    plot(y,x,'r')
    set(gca,'xtick',[],'ytick',[]);
    
end


%% Find the true lines in the image

IfinalContour = zeros(size(Icontour));
pointsPerSegment = floor(length(Icontour)/sqrtSeg);

for i = 1:(nbrSegments-sqrtSeg)

    startX = 1+(ceil(i/sqrtSeg)-1)*pointsPerSegment
    stopX = startX + 2*pointsPerSegment - 1
    
    maxY = polyval(polySum(i,:),x(end));
    minY = polyval(polySum(i+sqrtSeg,:),x(1));
        
    if abs(maxY - minY) < 0.5*x(end)
        
        majorX = startX:stopX;
        finalPoly = (polySum(i,:) + polySum(i+sqrtSeg,:))/2;
        y = round(polyval(finalPoly, majorX)) + abs(1-mod(i,sqrtSeg))*pointsPerSegment;
        
        y(find(y == 0)) = 1;
        y = y(find(y > 0));
        
        for i = 1:length(y)
            IfinalContour(majorX(i), y(i)) = 1;
        end
        
    end
end

figure(5)
clf
imshow(IfinalContour)

%% Find white lines

% Threshold for the RGB-images
IR_thres = IR > getThreshold(IR, 0.92);
IG_thres = IG > getThreshold(IR, 0.92);
IB_thres = IB > getThreshold(IR, 0.92);

% Convert I to a hsv-image and threshold the saturated image
Ihsv = rgb2hsv(I);
IS = cutImage(Ihsv(:,:,2));
IS_threshold = getThreshold(IS,0.1)
IS = IS < IS_threshold; % Good pic to extract the road from!

% Sum all images up to get the best image
I_bestLines = IB_thres+IR_thres+IG_thres+IS;
I_bestLines = I_bestLines > 3;

% Show blue image
figure(5)
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

%% RGB to HSV

Ihsv = rgb2hsv(I);

IH = cutImage(Ihsv(:,:,1));
IS = cutImage(Ihsv(:,:,2));
IV = cutImage(Ihsv(:,:,3));

IH_threshold = getThreshold(IH,0.9)
IS_threshold = getThreshold(IS,0.3)
IV_threshold = getThreshold(IV,0.85)

IH = IH < IH_threshold; % Doesn't give too much info
IS = IS < IS_threshold; % Good pic to extract the road from!
IV = IV > IV_threshold; % Doesn't give too much info

figure(7)
imshow(IV);


%% Extract dark gray areas

figure(8)
clf

low = 55;
high = 125;

h = fspecial('disk', 3);
IR_h = filter2(h, IR);
IG_h = filter2(h, IG);
IB_h = filter2(h, IB);

IR_darkGray = (IR_h > low/255 & IR_h < high/255);
IG_darkGray = (IG_h > low/255 & IG_h < high/255);
IB_darkGray = (IB_h > low/255 & IB_h < high/255);

I_darkGray = (IR_darkGray+IG_darkGray+IB_darkGray) > 2;

subplot(2,2,1)
imshow(I_darkGray)

subplot(2,2,2)
I_darkGray = imcomplement(bwareaopen(imcomplement(I_darkGray), 600));
I_darkGray = bwareaopen(I_darkGray, 15000);
imshow(I_darkGray)

subplot(2,2,3)
I_ultimate = (I_best + I_darkGray) >= 1;
imshow(I_ultimate)

Itest = bwareaopen(I_ultimate, 1000);
Itest2 = bwareaopen(imcomplement(Itest), 2000);
subplot(1,1,1)
imshow(Itest2)
