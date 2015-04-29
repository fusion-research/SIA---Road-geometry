%% PROJECT 142 1.0
I=imread('Bild3.png');

rate = size(I,2)/size(I,1);
Ir=resample(I,rate);

% creating 3 images f�r RGB
IR =Ir(:,1:length(Ir)/3);
IG =Ir(:, length(Ir)/3+1 : 2*length(Ir)/3);
IB =Ir(:, 2*length(Ir)/3+1 : length(Ir));

threshold_IB = midpoint(IB);

% creating binary images
IR_threshold = IR < 0.8;
IG_threshold = IG < 0.7;
IB_threshold = IB < threshold_IB; %mean(mean(IB)); %0.6 good for bild1
imshow(IB_threshold)

%% normalized blue - green

InormB=IB./(IR+IG+IB);
InormG=IG./(IR+IG+IB);

imshow(InormG)

%%
InormG_thresh2=InormG<0.35;

imshow(InormG_thresh2)


%%

thresh_InormB=midpoint(InormB);
thresh_InormG=midpoint(InormG);

InormB_thresh=InormB<thresh_InormB;
InormG_thresh=InormG<thresh_InormG;



figure(1)
imshow(InormB_thresh)

figure(2)
imshow(InormG_thresh)

%%

InormBmG=InormB_thresh-InormG_thresh;

BmG=InormBmG==0;

figure(3)
imshow(imcomplement(BmG))

%%

thresh_norm=midpoint(Inorm);

Inorm_thresh=Inorm < thresh_norm;

imshow(Inorm_thresh);


%% grayscale

% Recreate the (square) color image from the resampled "images"
I_square(:,:,1)=IR;
I_square(:,:,2)=IG;
I_square(:,:,3)=IB;

%imshow(Ir_gray)

% Convert to grayscale
I_square_gray=rgb2gray(I_square);

imshow(Igray)

%%
threshold_gray = midpoint(I_square_gray);
Igray_t = I_square_gray < threshold_gray;

figure(111)
imshow(Igray_t)


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------- BLUE ---------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% original IB

img=IB_threshold;

figure(1)
imshow(img)

%% contours

IB_contours = imcomplement(IB < 0.80);

figure(11)
imshow(IB_contours)

%% contours trying to remove noise - garbage so far

% remove small objects, fill in lines.    

t_rect=[2 13];
R_disk=2;
N_disk=4;
P_pl=1;
V_pl=[1 1]; % V is a two-element vector containing integer-valued row and column offsets.

SE_rect=strel('rectangle', t_rect);
SE_disk=strel('disk', R_disk, N_disk);
SE_pl=strel('periodicline', P_pl, V_pl);
SE_l=strel('line', 10, 45);

% remove clutter
IB_contours2=imopen(IB_contours, SE_disk);


% fill in lines
IB_contours3=imclose(IB_contours, SE_l);

figure(12)
imshow(IB_contours2)

%% road with filling

test = bwareaopen(img, 10000);

figure(21)
imshow(test)

%% road with filling and noise reduction (closing)

test2=test;

t=[10 25];
SE2=strel('rectangle', t);

test2 = imclose(test2, SE2);

figure(22)
imshow(test2)

%% apply opening for smoothing?

R_disk2=10;
SE3=strel('disk', R_disk2, 0);

test3=imopen(test2, SE3);

figure(23)
imshow(test3)


%% test of arbitrary strel

nhood=[1 0 1;
       0 0 0
       1 0 1];
SE_arb=strel('arbitrary', nhood);

test4=imopen(test, SE_arb);

figure(31)
imshow(test4)
