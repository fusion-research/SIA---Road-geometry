% Discriminate between objects, first cell is replicate of main

clc
clear all
%clf

warning('off', 'images:initSize:adjustingMag')

% Read image of simple road
I = imread('Bild4.png');

% % Show original image
% figure(1)
% imshow(I)
% title('Original image')

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
%the reflections from the water
% I_best = IB_thres+IR_thres+IG_thres+IS+IV;
% I_best = I_best > 4;

% Sum all images up to get the best image
I_best = IB_thres+IR_thres+IG_thres+IS;
I_best = I_best > 3;

% Find white lines

% Threshold for the RGB-images
IR_thres = IR > getThreshold(IR, 0.9);
IG_thres = IG > getThreshold(IR, 0.9);
IB_thres2 = IB > getThreshold(IR, 0.9);

% Sum all images up to get the best image
I_bestLines = IB_thres2+IR_thres+IG_thres+IS;
I_bestLines = I_bestLines > 3;


% Removed noise from actual road
InoNoiseRoad=imcomplement(bwareaopen(imcomplement(I_best),100));
InoNoise=bwareaopen(InoNoiseRoad, 1000);
IroadLines=InoNoise-I_bestLines;
IroadLinesNoNoise=imcomplement(bwareaopen(imcomplement(IroadLines), 100));

figure(3)
imshow(IroadLinesNoNoise)


%% I_ultimate: do some extra noise reduction in prep for classification

test=IroadLinesNoNoise;

test2=bwareaopen(test, 10000);

test3=bwareaopen(imcomplement(test2), 170);

figure(4)
imshow(imcomplement(test3))


%% classify objects : 
% Note that some sizes are currently related to the area of the image. i.e.
% if we were to use the same zoom level but only look at a subset of the
% original image the results will be invalid since the size proportion
% between objects is preserved but proportion between objects and the area 
% of the image differs. 
% 
% This method thus works best if the area of the images is more or less
% constant


testPrep=test3; % The prepared img which we want to use for obj detection

cctestPrep=bwconncomp(testPrep);
%stats=regionprops(testPrep, 'all');

areaImg=size(testPrep,1)*size(testPrep, 2);

% Remove large objects

% Maximum accepted area of an object which could be a possible line/marking
maxAreaPercent=0.025; 

numPixels=cellfun(@numel,cctestPrep.PixelIdxList);
numObjects=cc.NumObjects;

objsKept=numPixels<maxAreaPercent*areaImg; % Only keep objs which are sufficiently small 

testObjs=testPrep;

for i=1:numObjects

    if(objsKept(i)==0)
        testObjs(cctestPrep.PixelIdxList{i})=0;
    end
end

cctestObjs=bwconncomp(testObjs);

imshow(testObjs)

%% Find dashed lines

% Remove objects if length/width if too small and/or if their area is too large
% (mainly eliminates solid lines which have the right eccentricity)

lineEccentricityLimit=0.986;
dashedAreaLimit=3e-4*areaImg;
statstestObj=regionprops(testObjs, 'all');
numObjects=cctestObjs.NumObjects;

objDashedLines=testObjs;

for i=1:numObjects

    if(statstestObj(i).Eccentricity<lineEccentricityLimit)
        objDashedLines(cctestObjs.PixelIdxList{i})=0;
    elseif(statstestObj(i).Area>dashedAreaLimit)
        objDashedLines(cctestObjs.PixelIdxList{i})=0;
    end
    
    % if obj has right density?
end

imshow(objDashedLines)

%% Find solid lines

% Remove objects if length/width if too small and/or if their area is too large
% (mainly eliminates solid lines which have the right eccentricity)

lineEccentricityLimit=0.986;
dashedAreaLimit=3e-4*areaImg;
statstestObj=regionprops(testObjs, 'all');
numObjects=cctestObjs.NumObjects;

objSolidLines=testObjs;

for i=1:numObjects

    if(statstestObj(i).Eccentricity<lineEccentricityLimit)
        objSolidLines(cctestObjs.PixelIdxList{i})=0;
    elseif(statstestObj(i).Area<dashedAreaLimit)
        objSolidLines(cctestObjs.PixelIdxList{i})=0;
    end
    
    % if obj has right density?
end

imshow(objSolidLines)

%% Look at individual objects

j=9;

tmpTest=objSolidLines;

cctmp=bwconncomp(objSolidLines);

numObjects=cctmp.NumObjects;

for i=1:numObjects

    tmpTest(cctmp.PixelIdxList{i})=0;

end

tmpTest(cctmp.PixelIdxList{j})=1;

imshow(tmpTest)

%% Find distance between dashed lines to convert pixels -> meters









%%

% stats.Eccentricity
% stats.Orientation
% looking at density would be useful for excluding noise

% Investigate: eccentricity, orientation, 


% pseudo code:
% - remove too large objects
% - for each object type, try to find the objects in a seperate "session" and
% store results. 

% We should look for

% dashed lines: look at eccentricity, orientation?, density if it can be
% extracted (computed?)

% lines: eccentricity?

%% Find object and visualize independant object using special colormap

cc=bwconncomp(test3);

labeled=labelmatrix(cc);

RGB_label=label2rgb(labeled, @copper, 'c', 'shuffle');

imshow(RGB_label, 'InitialMagnification', 'fit')


%% Extract the smallest object from the image

numPixels = cellfun(@numel,cc.PixelIdxList);
[minObj, indMin] = min(numPixels);

test4=test2;

for i=1:length(cc.PixelIdxList)

    test4(cc.PixelIdxList{i})=0;

end

test4(cc.PixelIdxList{indMin})=1;
imshow(test4)


%% Extract the k smallest objects from the image

numPixels = cellfun(@numel,cc.PixelIdxList);

Y=numPixels;

k=10;

[~, mi] = sort(Y);
lowestkindex = mi(1:k);
%lowest5Y = Y(lowest5index);


%numPixels = cellfun(@numel,cc.PixelIdxList);
% [minObj, indMin] = min(numPixels);

test3=testtest;

for i=1:length(cc.PixelIdxList)

    test3(cc.PixelIdxList{i})=0;

end

for i=1:k
    test3(cc.PixelIdxList{lowestkindex(i)})=1;
end


imshow(test3)

%% Remove the k largest objects from the image

numPixels = cellfun(@numel,cc.PixelIdxList);

Y=numPixels;
numObjects=length(cc.PixelIdxList);

k=10;

[~, mi] = sort(Y);
highestkindex = mi(numObjects-k:numObjects);
%lowest5Y = Y(lowest5index);


%numPixels = cellfun(@numel,cc.PixelIdxList);
% [minObj, indMin] = min(numPixels);

test4=testtest;

for i=highestkindex

    test4(cc.PixelIdxList{i})=0;

end


imshow(test4)

%%

testtest=imcomplement(IroadLinesNoNoise);

figure(4)
imshow(testtest)
%%

cc=bwconncomp(testtest);

labeled=labelmatrix(cc);

RGB_label=label2rgb(labeled, @copper, 'c', 'shuffle');

imshow(RGB_label, 'InitialMagnification', 'fit')

%%

n=3;
t=2;
m=100;

tic
polyFound=ransac(test3, n, t, m, n, n);
toc


%% Divide the image into smaller segments
clc


img=test3;
nbrSegments = 8^2;

Ismall = getSegments(img, nbrSegments);

figure(3)
clf
for i = 1:nbrSegments
    subplot(sqrt(nbrSegments),sqrt(nbrSegments),i)
    imshow(Ismall(:,:,i))
end

%%
% Try to find lines with RanSaC

n=3;
t=2;
m=100;
q=n;
pMin=round(size(Ismall,1)^2/500);
polyDeg=3;

interations = 1;

polySum = zeros(nbrSegments,2);
nbrPoly = zeros(nbrSegments,1);

tic
x = 1:size(Ismall,1);
sqrtSeg = sqrt(nbrSegments);

polyRes=zeros(sqrtSeg);

% Do the RanSaC-algoritm 'iterations' number of times
for k = 1:interations
    % For each image-segment
    for smallImageNrb = 1:nbrSegments;
        
        bestPoly = ransac(Ismall(:,:,smallImageNrb), n, t, m, q, pMin, polyDeg);
        
        % If a spline is found, plot it on top of the image
        if size(bestPoly, 2) == polyDeg+1
            
            polyRes(smallImageNrb)=1;
            
            nbrPoly(smallImageNrb) = nbrPoly(smallImageNrb) + 1;
            
            y = polyval(bestPoly, x);

            figure(4)
            subplot(sqrtSeg,sqrtSeg,smallImageNrb)
            imagesc([1 x(end)],[1 x(end)],Ismall(:,:,smallImageNrb))
            hold on
            plot(y,x,'r')
            axis([0 x(end) 0 x(end)])
            set(gca,'xtick',[],'ytick',[]);
            
            %polySum(smallImageNrb,:) = polySum(smallImageNrb,:) + bestPoly;
            
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

polyRes'

%%
x=1:size(test3,1);
y=polyval(polyFound, x);

figure(5)
hold on
plot(x,y)
axis equal