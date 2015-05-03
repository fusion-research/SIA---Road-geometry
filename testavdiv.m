%% PROJECT 142 1.0
I=imread('Bild3.png');

rate = size(I,2)/size(I,1);
Ir=resample(I,rate);

Itest=imresize(I, [size(I,2), size(I,2)]);

imshow(Itest)

%%
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

%% test of findEightNeighbours

N=size(test);

nbrNeighbours=zeros(N);

%% 
profile on

tic
for i=1:N(1)
    for j=1:N(2)
        nbrNeighbours(i,j)=sum(findEightNeighbours(test, i, j));
    end
end
toc

p=profile('info');


%%
tmptest=nbrNeighbours>1;

figure(333)
imshow(tmptest)

%% 
tic
nbrNeighbours=findEightNeighboursSum(test);
toc

%%
nbrNeighbours=test;

figure(333)
imshow(nbrNeighbours)
%%

%for i=1:5
    nbrNeighbours=findEightNeighboursSum(nbrNeighbours);
    nbrNeighbours=nbrNeighbours>4;
%end
figure(333)
imshow(nbrNeighbours)

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

%% distance conversions: pixels to cm

x1=[1 1];
x2=[2 2];

dpix=sqrt((x1(1)-x2(1))^2 + (x1(2)-x2(2))^2); % calculate distance in pixels

pix_per_inch=get(0, 'ScreenPixelsPerInch');
CM_PER_INCH=2.54;
img_scale=3000; % Scale of the image: one m on screen <==> IMG_SCALE meters in reality
% TODO: decide on a "zoom level" and find the corresponding img scale

% pix_to_m_scaled=img_scale*CM_PER_INCH*10^(-3)/pix_per_inch;
pix_to_m_scaled=getScalingPixToM(img_scale);

dm_scaled=dpix*pix_to_m_scaled;

%%
% get(0, 'ScreenPixelsPerInch') = 85
% get(groot, 'ScreenPixelsPerInch')= 90

% seems like ScreenPixelsPerInch might be inaccurate sometimes as output 
% depends on OS: "value shown is the setting of the display resolution 
% specified in your system preferences". investigate this further. 


96*16/17 % pixels per inc according to website and using a ruler
% http://www.infobyip.com/detectmonitordpi.php. groot seems correct. 

%% TEST AV RANSAC, inlined

% Jonathan använder n=4, m=4000, d=0.1, q=60, h=10


% Returns bestPoly: the best polynomial found fitted by MATLAB's polyfit

n=3; % number of points used to sample first polynomial
t=2; % distance from polynomial which is accepted
m=3; % number of iterations
q=n; % lower limit for number of acceptable points for consensus set

maxC=0; % number of elements in largest consensus set so far
%ny=10; % nbr of points used to eval polynomial: let it depend on length(data)?


bestPoly=0;

% %data = [1 1;
%         2 2;
%         3 3;
%         4 4;
%         5 5;];

%  data=[1 2
%        2 4
%        3 5];

data=[1 1
      2 5
      3.4 8
      6 3
      5 1
      7 9
      9 11
      5.1 2
      5.2 3
      5.3 2.5
      5.4 1.5
      5.5 1.8];
  
ny=length(data);  
  
% usage of n, t and q seem okay

vec=1:length(data);
sampleVec1=zeros(n,2);
%data=; % each row in data specify coordinates of a point: (x,y)

for l=1:100
    
    y=datasample(vec, n, 'Replace', false);
    
    for k=1:n
        sampleVec1(k,1)=data(y(k),1);
        sampleVec1(k,2)=data(y(k),2);
    end
    
    p=polyfit(sampleVec1(:,1), sampleVec1(:,2), 1);
    
    xmin=min(data(:,1));
    xmax=max(data(:,1));
    
    xVal=linspace(xmin, xmax, ny); % range over which to eval poly
    
    pEval=polyval(p, xVal);
    
    Y=zeros(ny,2);
    Y(:,1)=xVal;
    Y(:,2)=pEval;
    
    consensusSet=rangesearch(data, Y, t);
    
    A=zeros(n*n, 1); % find a better solution for this
    
    for i=1:ny
        tmp=consensusSet{i};
        for j=1:length(tmp)
            A((i-1)*ny+j)=tmp(j);
        end
    end
    
    C1=unique(A);
    C1=C1(C1~=0); % C1 contains data points within distance t of first polynomial
    
    % if consensus set is large enough, refit poly
    if(length(C1)>q && length(C1)>maxC)
        
        n2=length(C1);
        maxC=n2;
        
        sampleVec2=zeros(n2,2);
        
        for k=1:n2
            sampleVec2(k,1)=data(C1(k),1);
            sampleVec2(k,2)=data(C1(k),2);
        end
        
        bestPoly=polyfit(sampleVec2(:,1), sampleVec2(:,2), 1);
    end
end

%bestPoly
maxC


figure(1)
clf
hold on
plot(xVal, pEval)
plot(data(:,1), data(:,2), 'r*')
title('Poly 1')

figure(2)
clf

if(maxC>q && length(bestPoly)>1)
    pEval2=polyval(bestPoly, xVal);
    
    figure(2)
    clf
    hold on
    plot(xVal, pEval2)
    plot(data(:,1), data(:,2), 'r*')
    title('Poly 2')
else
    disp('**Warning: no good polynomial found**')
end


%% optimization

data=[1 1
      2 5
      3.4 8
      6 3
      5 1
      7 9
      9 11
      5.1 2
      5.2 3
      5.3 2.5
      5.4 1.5
      5.5 1.8];
  
profile on
tic
polyFound=ransac(data);
toc
profile viewer

%%
polyFound=ransac(data, 3, 2, 100, 3);


%%

data(C1(2),1)
data(C1(2),2)
%%

plot(xVal, pEval)

%%

        for k=1:n2
            sampleVec2(k,1)=data(C1(k),1);
            sampleVec2(k,2)=data(C1(k),2);
        end



%%

B=cell2mat(consensusSet)



%%

a=cat(1, consensusSet{:})







%% backup f8n

% function n = findEightNeighbours(I, x, y)
% 
% N = size(I);
% n = [];
% 
% 
% % East
% if x== N(1)
%     ;
% else
%     n(end+1) = I(x+1,y);
% end
% 
% 
% % West
% if x == 1
%     ;
% else
%     n(end+1) = I(x-1,y);
% end
% 
% 
% % NW, NE
% if y == 1
%     ;
% else
%     if(x==1) % NE
%         n(end+1) = I(x+1,y-1);
%         
%     elseif(x==N(1)) % NW
%         n(end+1) = I(x-1,y-1);
%         
%     else % NE and NW
%         n(end+1) = I(x+1,y-1);
%         n(end+1) = I(x-1,y-1);
%     end
%     n(end+1) = I(x,y-1);
% end
% 
% 
% 
% % SW, SE
% if y == N(2)
%     ;
% else
%     if(x==1) % SE
%         n(end+1) = I(x+1,y+1);
%         
%     elseif(x==N(1)) % SW
%         n(end+1) = I(x-1,y+1);
%         
%     else % SE and SW
%         n(end+1) = I(x+1,y+1);
%         n(end+1) = I(x-1,y+1);
%     end
%     n(end+1) = I(x,y+1);
% end
% 
% 
% end
