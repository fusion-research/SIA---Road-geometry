function Ismall = getSegments(I, nbrSegments)
% Function that divides one image into smaller image-segments
%
% 'nbrSegments' must be a square number

sqrtSeg = sqrt(nbrSegments);
pointsPerSegment = floor(length(I)/sqrtSeg);

% Memory allocation
Ismall = zeros(pointsPerSegment, pointsPerSegment, sqrtSeg);

k = 1;

% Create small image segments
for i = 1:sqrtSeg
    for j = 1:sqrtSeg
        tempVecX = (i-1)*pointsPerSegment+1:i*pointsPerSegment;
        tempVecY = (j-1)*pointsPerSegment+1:j*pointsPerSegment;
        Ismall(:,:,k) = I(tempVecX,tempVecY);
        k = k + 1;
    end
end

end