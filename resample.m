function Inew = resample(I,rate)

[Ny,Nx] = size(I);
Nx_new  = round(Nx/rate);

I    = im2double(I);
Inew = zeros(Ny,Nx_new);

% last column:
Inew(:,Nx_new)=I(:,Nx);

% intermediate columns:
for x_new = 1:(Nx_new-1)
  %determine the x-position in the old image
  %all the minus 1:s comes from the fact that the smallest index is 1 (and not 0)
  %and that the first column in the new image is supposed to be the first
  %column in the old image
  x  = 1+(x_new-1)*(Nx-1)/(Nx_new-1); 

  %perform the interpolation
  xx = floor(x);
  k=I(:,xx+1)-I(:,xx);
  m=I(:,xx)-k*xx;
  Inew(:,x_new) = k*x+m;
  %or equivalently:
  %Inew(:,x_new) = I(:,xx)*(1-(x-xx)) + I(:,xx+1)*(x-xx); % linear interpolation
end
