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