function n = findEightNeighboursSum(I)

% I is assumed to be a square, binary matrix. 

% n is a matrix containing the number of neighbours for each element of I.

s=size(I);
N=s(1);
n=zeros(s);


% Corners
n(1,1) = I(1,2)+I(2,1) + I(2,2);
n(1,N) = I(1,N-1) + I(2, N) + I(2, N-1);
n(N, 1) = I(N,2) + I(N-1, 1) + I(N-1, 2);
n(N, N) = I(N, N-1) + I(N-1, N) + I(N-1, N-1);

% Rest of boundary
for i=2:N-1

    % y==1
    n(1,i) = I(1,i-1) + I(1, i+1) + I(2,i-1) + I(2, i) + I(2,i+1);
    
    % y==end
    n(end,i) = I(end,i-1) + I(end, i+1) + I(end-1,i-1) + I(end-1, i) + I(end-1,i+1);

    % x==1
    n(i, 1) = I(i-1,1) + I(i+1,1) + I(i-1,end-1) + I(i,end-1) + I(i+1,end-1);

    % x==end
    n(i, end) = I(i-1,end) + I(i+1,end) + I(i-1,end-1) + I(i,end-1) + I(i+1,end-1); 

end

% Inner points
for i=2:N-1
    for j=2:N-1
        n(i,j) = I(i-1, j-1) + I(i-1, j) + I(i-1, j+1) + I(i, j-1) + I(i, j+1) + I(i+1, j-1) + I(i+1, j) + I(i+1, j+1);
    end
end

end

