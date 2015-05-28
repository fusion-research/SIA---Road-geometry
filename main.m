%% Main program that identifies the road from a map-image

clc
clear all

warning('off', 'images:initSize:adjustingMag')

% Read image of simple road
I = imread('Bild4.png');

% % Show original image
%figure(1)
%imshow(I)

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

%% Classify objects 
%
% Note that some sizes are currently related to the area of the image. i.e.
% if we were to use the same zoom level but only look at a subset of the
% original image the results will be invalid since the size proportion
% between objects is preserved but proportion between objects and the area 
% of the image differs. 
% 
% This method thus works best if the area of the images is more or less
% constant as otherwise the parameters have to be adjusted manually. 

% The image which is to be used for discrimination
preparedImage=IroadLines; 

% Maximum accepted area of an object which could be a possible line/marking
maxAreaPercent=0.025; 

% Minimum eccentricity of an object to be considered a line. Should be a
% value close to 1
lineEccentricityLimit=0.98; 

% Area limit for a dashed line. Lines with area larger than this is
% considered to be a solid line segment
dashedAreaLimit=3e-4*areaImg;

% Remove too small objects as they are considered noise
preparedImage=bwareaopen(imcomplement(preparedImage), 170);

ccPrep=bwconncomp(preparedImage);

areaImg=size(preparedImage,1)*size(preparedImage, 2);

numPixels=cellfun(@numel,ccPrep.PixelIdxList);
numObjects=ccPrep.NumObjects;

% Only keep objs which are sufficiently small 
objsKept=numPixels<maxAreaPercent*areaImg; 

testObjs=preparedImage;

for i=1:numObjects

    if(objsKept(i)==0)
        testObjs(ccPrep.PixelIdxList{i})=0;
    end
end

cctestObjs=bwconncomp(testObjs);

%----------------Find dashed lines------------------------------------

statObj=regionprops(testObjs, 'all');
numObjects=cctestObjs.NumObjects;

objDashedLines=testObjs;

for i=1:numObjects

    if(statObj(i).Eccentricity<lineEccentricityLimit)
        objDashedLines(cctestObjs.PixelIdxList{i})=0;
    elseif(statObj(i).Area>dashedAreaLimit)
        objDashedLines(cctestObjs.PixelIdxList{i})=0;
    end
    
end

matToTxt(objDashedLines, 'DashedLines')

%----------------Find solid lines------------------------------------

statObj=regionprops(testObjs, 'all');
numObjects=cctestObjs.NumObjects;

objSolidLines=testObjs;

for i=1:numObjects

    if(statObj(i).Eccentricity<lineEccentricityLimit)
        objSolidLines(cctestObjs.PixelIdxList{i})=0;
    elseif(statObj(i).Area<dashedAreaLimit)
        objSolidLines(cctestObjs.PixelIdxList{i})=0;
    end
    
end

matToTxt(objSolidLines, 'SolidLines')

% Find unidentified objects
unidentifiedObjs=testObjs-objSolidLines-objDashedLines;

unidentifiedObjs=unidentifiedObjs>0;
matToTxt(unidentifiedObjs, 'UnidentifiedObjects')

% Create a copy of the image which excludes unidentified objects
IroadLinesMuid=IroadLines;
IroadLinesMuid(unidentifiedObjs)=1;


%% View the different images and objects

figure(1)
hold on
title('Image with unidentified objects')
imshow(IroadLines)

figure(2)
hold on
title('Dashed line objects')
imshow(objDashedLines)

figure(3)
hold on
title('Solid line segment objects')
imshow(objSolidLines)

figure(4)
hold on
title('Unidentified objects')
imshow(unidentifiedObjs)

figure(5)
hold on
title('Image where the unidentified objects have been removed')
imshow(IroadLinesMuid)
