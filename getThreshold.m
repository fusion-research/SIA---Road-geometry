function T = getThreshold(I, rate)
% T = getThreshold(I, rate)
%
% Function that finds a threshold value such that about the amount of
% values, specified by 'rate', are to the left in the histogram of the 
% image.

% Get histogram
Ihist = imhist(I);

% Find indexes for which the Ihist-values are greater than a certain value
indexes = find(Ihist >= 0.0001*sum(Ihist));

% Sum all values in Ihist
summation = sum(Ihist(indexes));

i = 1;
histSum = Ihist(indexes(i));

while histSum < rate*summation
    i = i + 1;
    histSum = histSum + Ihist(indexes(i));
end

% The treashold should be a value in the range [0,1]
T = indexes(i)/length(Ihist);

end