function Inew = fillHoles(I, rate)

% Size of image
N = size(I);

Inew = I;

for i = 1:3
    for k = 1:N(1)
        for l = 1:N(2)
            
            % Get neighbors to the pixel, with PBC
            n = findEightNeighbours(I, k, l);
            
            white = sum(n);
            
            
            if (1-white/length(n)) > rate
                Inew(k,l) = 0;
            elseif white/length(n) > rate
                Inew(k,l) = 1;
            end
            
        end
    end
end


end

