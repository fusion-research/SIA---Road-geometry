%% PROJECT 142 1.0
I=imread('Bild5.png');
rate = size(I,2)/size(I,1);

%% RGB
Ir=resample(I,rate);

<<<<<<< HEAD
% creating 3 images for RGB
IR =Ir(:, 1:length(Ir)/3);
IG =Ir(:,   length(Ir)/3+1 : 2*length(Ir)/3);
IB =Ir(:, 2*length(Ir)/3+1 :   length(Ir));
=======

% creating 3 images f�r RGB
IR =Ir(:,1:length(Ir)/3);
IG =Ir(:, length(Ir)/3+1 : 2*length(Ir)/3);
IB =Ir(:, 2*length(Ir)/3+1 : length(Ir));
>>>>>>> a81d88349eaffe17e581753ecab8195c5f4ff0b4

figure(1); set(figure(1),'position',[1 100 1979 1079])
subplot(2,3,[1,2,3]);imshow(Ir)
subplot(2,3,4); imhist(IR)
subplot(2,3,5); imhist(IG)
subplot(2,3,6); imhist(IB)

threshold_IR = midpoint(IR);
threshold_IG = midpoint(IG);
threshold_IB = midpoint(IB);
% creating binary images
IR_threshold = IR < 0.8;
IG_threshold = IG < 0.7;
IB_threshold = IB < 0.8;%threshold_IB;%mean(mean(IB)); %0.6 good for bild1
%figure(2), imshow(IB_threshold)

%% HSV
I_HSV = rgb2hsv(I);
I_HSVr=resample(I_HSV,rate);

% creating 3 images for HSV
IH = I_HSVr(:, 1:length(I_HSVr)/3);
IS = I_HSVr(:,   length(I_HSVr)/3+1 : 2*length(I_HSVr)/3);
IV = I_HSVr(:, 2*length(I_HSVr)/3+1 :   length(I_HSVr));

figure(1); set(figure(1),'position',[1 100 1979 1079])
subplot(2,3,[1,2,3]);imshow(I_HSVr)
subplot(2,3,4); imhist(IH)
subplot(2,3,5); imhist(IS)
subplot(2,3,6); imhist(IV)

threshold_IH = midpoint(IH);
threshold_IS = midpoint(IS);
threshold_IV = midpoint(IV);
% creating binary images
IH_threshold = IH < 0.8;
IS_threshold = IS < threshold_IS;%0.08;
IV_threshold = IV < 0.8;%threshold_IB;%mean(mean(IB)); %0.6 good for bild1
%figure(2), imshow(IS_threshold)

%% YCbCr
I_YUV = rgb2ycbcr(I);
I_YUVr=resample(I_YUV,rate);

% creating 3 images for YUV
IY = I_YUVr(:, 1:length(I_YUVr)/3);
IU = I_YUVr(:,   length(I_YUVr)/3+1 : 2*length(I_YUVr)/3);
IV = I_YUVr(:, 2*length(I_YUVr)/3+1 :   length(I_YUVr));

figure(1); set(figure(1),'position',[1 100 1979 1079])
subplot(2,3,[1,2,3]);imshow(I_YUVr)
subplot(2,3,4); imhist(IY)
subplot(2,3,5); imhist(IU)
subplot(2,3,6); imhist(IV)

threshold_IY = midpoint(IY);
threshold_IU = midpoint(IU);
threshold_IV = midpoint(IV);
% creating binary images
IY_threshold = IY < 0.8;
IU_threshold = IU < 0.7;
IV_threshold = IV < 0.8;%threshold_IB;%mean(mean(IB)); %0.6 good for bild1
%figure(2), imshow(IB_threshold)

%% NTSC - YIQ
I_YIQ = rgb2ycbcr(I);
I_YIQr=resample(I_YIQ,rate);

% creating 3 images for YIQ
IY = I_YIQr(:, 1:length(I_YIQr)/3);
II = I_YIQr(:,   length(I_YIQr)/3+1 : 2*length(I_YIQr)/3);
IQ = I_YIQr(:, 2*length(I_YIQr)/3+1 :   length(I_YIQr));

figure(1); set(figure(1),'position',[1 100 1979 1079])
subplot(2,3,[1,2,3]);imshow(I_YIQr)
subplot(2,3,4); imhist(IY)
subplot(2,3,5); imhist(II)
subplot(2,3,6); imhist(IQ)

threshold_IY = midpoint(IY);
threshold_II = midpoint(II);
threshold_IQ = midpoint(IQ);
% creating binary images
IY_threshold = IY < 0.8;
II_threshold = II < 0.7;
IQ_threshold = IQ < 0.8;%threshold_IB;%mean(mean(IB)); %0.6 good for bild1
%figure(2), imshow(IB_threshold)


%% interative analysis
IB; %= IS;
R = 1;
R2 = 1;%7;%10;
first= 90;
last = 40;
SE = strel('diamond', R);
SE2 = strel('diamond', R2);
I = IB < threshold_IB;
%figure(99), imshow(I);
for i=first:-1:last
    
    I = imclose(I,SE);
    
    figure(i)
    imshow(I)
    
    Itemp1 = imcomplement(I);
    Itemp2 = IB > 1/first*i*threshold_IB;
    I = Itemp1 + Itemp2;
    I = I > 0;
    I = imcomplement(I);
    
end
I = imclose(I,SE2);
figure(last+1)
imshow(I)
figure(last+2)
imshow(IB < threshold_IB)


%% test for interative analysis

for i=1:10
    figure(i)
    IB_threshold = IB < 0.1*i*threshold_IB;
    imshow(IB_threshold)
end

%% test for making things work...
I1 = IB > 0.4*threshold_IB;
figure(1), imshow(I1)
I2 = IB > 0.8*threshold_IB;
figure(2), imshow(I2)

I3 = I1 + I2;
I3 = I3 > 0;
I3= imcomplement(I3);
figure(3), imshow(I3)
% %
R = 3;
SE = strel('diamond', R);

I1 = IB < threshold_IB;
%figure(1), imshow(I1)

I1 = imclose(I1,SE);
%figure(2), imshow(I1)

I1 = imcomplement(I1);
I2 = IB > 0.8*threshold_IB;
I3 = I1 + I2;
I3 = I3 > 0;
I3= imcomplement(I3);
figure(3), imshow(I3)

I3 = imclose(I3,SE);
figure(4), imshow(I3)

%%
%grayscale
Igray = rgb2gray(I);
figure(2), imshow(Igray, [0 255])

%% Prewitt filter on the image to find contours

wy = [-1 -1 -1; 0 0 0; 1 1 1]/6;
wx = [-1 0 1; -1 0 1; -1 0 1]/6;

Ix = filter2(wx, IB_threshold);
Iy = filter2(wy, IB_threshold);

Ipre = sqrt(Ix.^2 + Iy.^2);

imshow(Ipre)
shg
