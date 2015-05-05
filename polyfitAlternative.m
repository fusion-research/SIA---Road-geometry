function [p] = polyfitAlternative(x,y,n)

% Basically MATLAB's built in polyfit but without warnings and check of
% nargout. Use with caution!

%   Copyright 1984-2011 The MathWorks, Inc.
%   $Revision: 5.17.4.14 $  $Date: 2011/05/17 02:32:30 $

x = x(:);
y = y(:);

% Construct Vandermonde matrix.
V(:,n+1) = ones(length(x),1,class(x));
for j = n:-1:1
   V(:,j) = x.*V(:,j+1);
end

% Solve least squares problem.
[Q,R] = qr(V,0);
p = R\(Q'*y);    % Same as p = V\y;



p = p.';          % Polynomial coefficients are row vectors by convention.
