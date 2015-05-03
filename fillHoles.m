function Inew = fillHoles(I, rate)
% Function that filles the holes in a binary image. This function works for
% images with small disturbances but not for big disturbances. 

% Size of image
N = size(I);

Inew = I;

for i = 1:6
    
    white = findEightNeighboursSum(Inew);
                
    for k = 1:N(1)
        for l = 1:N(2)
            
            if (1-white(k,l)/8) > rate
                Inew(k,l) = 0;
            elseif white(k,l)/8 > rate
                Inew(k,l) = 1;
            end
            
        end
    end
end


end

