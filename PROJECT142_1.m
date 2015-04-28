%% PROJECT 142 1.0
I=imread('Bild3.png');

rate = size(I,2)/size(I,1);
Ir=resample(I,rate);
%figure(1), imshow(Ir)

% creating 3 images f�r RGB
IR =Ir(:,1:length(Ir)/3);
IG =Ir(:, length(Ir)/3+1 : 2*length(Ir)/3);
IB =Ir(:, 2*length(Ir)/3+1 : length(Ir));

threshold_IB = midpoint(IB);

% creating binary images
IR_threshold = IR < 0.8;
IG_threshold = IG < 0.7;
IB_threshold = IB < threshold_IB;%mean(mean(IB)); %0.6 good for bild1
imshow(IB_threshold)


%% Prewitt filter on the image to find contours

wy = [-1 -1 -1; 0 0 0; 1 1 1]/6;
wx = [-1 0 1; -1 0 1; -1 0 1]/6;

Ix = filter2(wx, IB_threshold);
Iy = filter2(wy, IB_threshold);

Ipre = sqrt(Ix.^2 + Iy.^2);

imshow(Ipre)
shg