%% Christoffer TEST

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

%%
area=4;
I = ones(10);
ratio=0.5;
disp(area)
tic
N =RemoveNoise2(I,area);
Inew=zeros(size(I));
for k = 1+area/2:N(1)-area/2
    for l = 1+area/2:N(2)-area/2
        if N(k,l) >ratio
            Inew = 1;
        end
    end
end
toc

tic
Inew2 = RemoveNoise(I, ratio, area);
toc