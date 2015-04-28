%% PROJECT 142 1.0
I=imread('Bild3.png');

rate = size(I,2)/size(I,1);
Ir=resample(I,rate);
figure(1), imshow(Ir)

% creating 3 images fï¿½r RGB
IR =Ir(:,1:length(Ir)/3);
IG =Ir(:, length(Ir)/3+1 : 2*length(Ir)/3);
IB =Ir(:, 2*length(Ir)/3+1 : length(Ir));

threshold_IB = midpoint(IB);

% creating binary images
IR_threshold = IR < 0.8;
IG_threshold = IG < 0.7;
IB_threshold = IB < 0.8;%threshold_IB;%mean(mean(IB)); %0.6 good for bild1
%imshow(IB_threshold)


%% denna förkastar alla värden som är har stor skillnad mellan RGB
IGRAY = zeros(size(IR));
for i=1:length(IR)
    for j=1:length(IR)
        if max([IR(i,j), IG(i,j), IB(i,j)]) - min([IR(i,j), IG(i,j), IB(i,j)]) < 0.1
            IGRAY(i,j) = mean([IR(i,j), IG(i,j), IB(i,j)]);
        end
    end
end
imshow(IGRAY)
%%
threshold_IGRAY = midpoint(IGRAY);
IGRAY_bin = IGRAY < threshold_IGRAY;
imshow(IGRAY_bin)
%% sorterar om i en skala som är ljusare desto närmare RGB är...
IGRAY = zeros(size(IR));
for i=1:length(IR)
    for j=1:length(IR)
            IGRAY(i,j) = 1 - ( max([IR(i,j), IG(i,j), IB(i,j)]) - min([IR(i,j), IG(i,j), IB(i,j)]) );
    end
end
imshow(IGRAY)

%% sorterar om i en skala som är ljusare desto närmare RGB är... (MED TRÖSKEL)
IGRAY = zeros(size(IR));
for i=1:length(IR)
    for j=1:length(IR)
            IGRAY(i,j) = 1 - ( max([IR(i,j), IG(i,j), IB(i,j)]) - min([IR(i,j), IG(i,j), IB(i,j)]) );
            if IGRAY(i,j) < 0.85
                IGRAY(i,j)=0;
            end
    end
end
IGRAY(IGRAY==0)=2;
lowest = min(min(IGRAY));
IGRAY = IGRAY - lowest;
IGRAY(IGRAY==2-lowest)=0;
highest = max(max(IGRAY));
IGRAY=IGRAY/highest;

imshow(IGRAY)
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
