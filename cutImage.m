function Icut = cutImage(I)
% Cut the image such that it becomes a [n x n]-matrix. Make sure that the
% image is a 2D-image.

sizeI = size(I);


if sizeI(1) > sizeI(2) % If image is taller than its width
    
    start = sizeI(1)/2 - sizeI(2)/2;
    stop = start + sizeI(2) - 1;
 
    Icut = I(start:stop, :);
    
else  % If the width of the image is greater than its height
    
    start = sizeI(2)/2 - sizeI(1)/2;
    stop = start + sizeI(1) - 1;
    
    Icut = I(:, start:stop);
    
end



end