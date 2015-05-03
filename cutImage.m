function Icut = cutImage(I)
% Cut the image such that it becomes a [n x n]-matrix. Make sure that the  
% image is a 2D-image.

sizeI = size(I);

start = sizeI(2)/2 - sizeI(1)/2;

stop = start + sizeI(1) - 1;

Icut = I(:, start:stop);

end