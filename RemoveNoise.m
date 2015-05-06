function Inew = RemoveNoise(I, ratio, area)
% Function that removes the noise in an image.

% Size of image
N = size(I);

% Allocating memory
%Inew = zeros(N);

%whiteNeighbours = findEightNeighboursSum(I);

for k = 1+area/2:N(1)-area/2
    for l = 1+area/2:N(2)-area/2
        
       if ((sum( sum( I( k-area/2:k+area/2 , l-area/2:l+area/2 ) ) ) ) / (area*area)) >= ratio
           %Inew(k,l) = 1;
           I(k,l) = 1;
       end
        
    end
end
Inew=I;
end