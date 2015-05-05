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
IG_thres = IG > getThreshold(IR, 0.5);
IB_thres = IB > getThreshold(IR, 0.5);

% Convert I to a hsv-image and threshold the saturated image
Ihsv = rgb2hsv(I);
IS = cutImage(Ihsv(:,:,2));
IS_threshold = getThreshold(IS,0.3);
IS = IS < IS_threshold; % Good pic to extract the road from!

IV = cutImage(Ihsv(:,:,3));
IV_threshold = getThreshold(IV,0.85);
IV = IV > IV_threshold; % Doesn't give too much info

% Sum all images up to get the best image. Works good for 'Bild2' to reduce
% the reflections from the water
%I_best = IB_thres+IR_thres+IG_thres+IS+IV;
%I_best = I_best > 4;

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


% Find the contours in the image
Icontour = findContour(I_best, 2/8, 4/8);

subplot(2,3,6)
imshow(Icontour)
title('Contours')

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

n = 5;
t = 1;
m = 250;
q = 1;

interations = 3;

polySum = zeros(nbrSegments,2);
nbrPoly = zeros(nbrSegments,1);

tic
figure(4)
x = 1:size(Ismall,1);
sqrtNbrSegments = sqrt(nbrSegments);

% Do the RanSaC-algoritm 'iterations' number of times
for k = 1:interations
    % For each image-segment
    for smallImageNrb = 1:nbrSegments;
        
        bestPoly = ransac(Ismall(:,:,smallImageNrb), n, t, m, q);
        
        % If a spline is found, plot it on top of the image
        if size(bestPoly, 2) == 2
            
            nbrPoly(smallImageNrb) = nbrPoly(smallImageNrb) + 1;
            
            y = polyval(bestPoly, x);

            subplot(sqrtNbrSegments,sqrtNbrSegments,smallImageNrb)
            imagesc([1 x(end)],[1 x(end)],Ismall(:,:,smallImageNrb))
            hold on
            plot(y,x,'r')
            axis([0 x(end) 0 x(end)])
            set(gca,'xtick',[],'ytick',[]);
            
            polySum(smallImageNrb,:) = polySum(smallImageNrb,:) + bestPoly;
            
        % If no spline is found, just display the image-segment
        else
            
            subplot(sqrtNbrSegments,sqrtNbrSegments,smallImageNrb)
            imshow(Ismall(:,:,smallImageNrb))
            set(gca,'xtick',[],'ytick',[]);
            
        end
        
    end
end
toc

% Find a mean spline for each image-segment
for smallImageNrb = 1:nbrSegments
    polySum(smallImageNrb,:) = polySum(smallImageNrb,:)./nbrPoly(smallImageNrb);
end

% Plot the mean spline for each image-segment
for smallImageNrb = 1:nbrSegments;
    
    y = polyval(polySum(smallImageNrb,:), x);

    subplot(sqrt(nbrSegments),sqrt(nbrSegments),smallImageNrb)
    imagesc([1 size(Ismall,1)],[1 size(Ismall,2)],Ismall(:,:,smallImageNrb))
    hold on
    plot(y,x,'r')
    set(gca,'xtick',[],'ytick',[]);
    
end


%% Find the true lines in the image

IfinalContour = zeros(size(Icontour));

maxY = polyval(polySum(1,:),x(end))
minY = polyval(polySum(3,:),x(1))

majorX = 1:size(Icontour,1);

if abs(maxY - minY) < 0.05*x(end)
    finalPoly = (polySum(1,:) + polySum(3,:))/2;
    y = round(polyval(finalPoly, majorX));
    
    for i = 1:majorX(end)
        IfinalContour(majorX(i),y(i)) = 1;
    end
    
    figure(5)
    clf
    imshow(IfinalContour)
    
end

%% Find white lines

% Threshold for the RGB-images
IR_thres = IR > getThreshold(IR, 0.9);
IG_thres = IG > getThreshold(IR, 0.9);
IB_thres = IB > getThreshold(IR, 0.9);

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

% Convert I to a hsv-image and threshold the saturated image
Ihsv = rgb2hsv(I);
IS = cutImage(Ihsv(:,:,2));
IS_threshold = getThreshold(IS,0.3)
IS = IS < IS_threshold; % Good pic to extract the road from!

%%

Icontour_lines = findContour(I_bestLines, 4/8, 5/8);

figure(8)
imshow(Icontour_lines)

%% Fill all holes

tic
I_filled = fillHoles(I_best, 0.8);
toc

figure(6)
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

IH_threshold = getThreshold(IH,0.9)
IS_threshold = getThreshold(IS,0.3)
IV_threshold = getThreshold(IV,0.85)

IH = IH < IH_threshold; % Doesn't give too much info
IS = IS < IS_threshold; % Good pic to extract the road from!
IV = IV > IV_threshold; % Doesn't give too much info

figure(7)
imshow(IV);
