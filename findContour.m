function Icontour = findContour(I, rateLow, rateHigh)
% Function that the contours in a binary image.

% Size of image
N = size(I);

Icontour = zeros(size(I));

whiteNeighbours = findEightNeighboursSum(I);

for k = 1:N(1)
    for l = 1:N(2)
        
        if I(k,l) == 1 && whiteNeighbours(k,l)/8 <= rateHigh && ...
                whiteNeighbours(k,l)/8 >= rateLow
            Icontour(k,l) = 1;
        end
        
    end
end

end