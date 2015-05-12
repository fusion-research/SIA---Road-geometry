function N = RemoveNoise2(I, area)
% Function that removes the noise in an image.

N=zeros(size(I));
%area2=area/2+0.5;

% Corners
for i = 1:area/2
    for j = 1:area/2
        N(1,1)     = N(1,1)     + I(i,j);
        N(1,end)   = N(1,end)   + I(i,end+1-j);
        N(end,1)   = N(end,1)   + I(end+1-i,j);
        N(end,end) = N(end,end) + I(end+1-i,end+1-j);
    end
end

% semi-corners
for i = 2:area/2
    N(1,i)   = N(1,i-1) + sum( I(1:area/2,area/2+i-1) );           % x=1, y=1 moving in x
    N(i,1)   = N(i-1,1) + sum( I(area/2+i-1,1:area/2) );           % x=1, y=1 moving in y
    
    N(end,i) = N(end,i-1) + sum( I(end-area/2+1:end,area/2+i-1) );     % x=1, y=end moving in x
    N(end-i+1,1) = N(end-i+2,1) + sum(I( end-area/2-i+2 , 1:area/2 )); % x=1, y=end moving in -y
    
    N(i,end) = N(i-1,end) + sum( I(area/2+i-1,end-area/2+1:end) );     % x=end, y=1 moving in y
    N(1,end-i+1) = N(1,end-i+2) + sum(I( 1:area/2 , end-area/2-i+2 )); % x=end, y=1 moving in -x
    
    N(end,end-i+1) = N(end,end-i+2) + sum(I( end-area/2+1:end , end-area/2-i+2 )); % x=end, y=end moving in -x
    N(end-i+1,end) = N(end-i+2,end) + sum(I( end-area/2-i+2 , end-area/2+1:end )); % x=end, y=end moving in -y
end

% boundaries
for i = area/2+1:length(I)-area/2
    N(1,i)   = N(1,i-1) + sum(I(1:area/2,area/2+i)) - sum(I(1:area/2,i-area/2)); % upper boundary
    N(end,i) = N(end,i-1) + sum(I(end-area/2+1:end,area/2+i)) - sum(I(end-area/2+1:end,i-area/2)); % lower boundary
    N(i,1)   = N(i-1,1) + sum(I(area/2+i,1:area/2)) - sum(I(i-area/2,1:area/2)); % left boundary
    N(i,end) = N(i-1,end) + sum(I(area/2+i,end-area/2+1:end)) - sum(I(i-area/2,end-area/2+1:end)); % right boundary
end

% inner boundaries on corners
for i = 1:area/2-1
    for j = 1:area/2-1
        N(j+1,i+1)     = N(j,i+1) + sum(I( area/2+j , 1:area/2+i )); % upper left corner
        N(j+1,end-i)   = N(j,end-i) + sum(I( area/2+j , end-area/2-i:end )); % upper right corner
        N(end-j,i+1)   = N(end+1-j,i+1) + sum(I( end-area/2+1-j , 1:area/2+i )); % lower left corner
        N(end-j,end-i) = N(end+1-j,end-i) + sum(I( end-area/2+1-j , end-area/2-i:end )); % lower right corner
    end
end

% inner boundaries
for i = area/2+1:length(I)-area/2
    for j = 1:area/2-1
        N(j+1,i)   = N(j,i) + sum(I( j+area/2 , i-area/2+1:i+area/2 )); % upper part
        N(end-j,i) = N(end,i) + sum(I( end-area/2+1-j , i-area/2+1:i+area/2 )); % lower part
        N(i,j+1)   = N(i,j) + sum(I( i-area/2+1:i+area/2 , j+area/2 )); % left part
        N(i,end-j) = N(i,end) + sum(I( i-area/2+1:i+area/2 , end-area/2+1-j )); % right part
    end
end

% inner points
N(area/2,area/2) = sum( sum( I( 1:area , 1:area ) ) );
for i = 1:length(I)-area
    N(area/2,area/2 +i) = N(area/2,area/2+i-1) - sum( I(1:area,i) ) + sum( I(1:area, area +i) );
end
for i = 1:length(I)-area+1
    for j = 1:length(I)-area
        N(area/2 +j, area/2 +i-1) = N(area/2 +j-1,area/2+i-1) - sum( I(j,i:area+i-1) ) + sum( I(j+area,i:area+i-1) );
    end
end


% %normalizing
% N(area/2:end-area/2,area/2:end-area/2) = N(area/2:end-area/2,area/2:end-area/2)/(area*area);% inner points
% 
% N(1,1)= N(1,1)/(area*area/4); % corners
% N(1,end)= N(1,end)/(area*area/4);
% N(end,1)= N(end,1)/(area*area/4);
% N(end,end)= N(end,end)/(area*area/4);
% 
% N(1,area/2+1:end-area/2)  = N(1,area/2+1:end-area/2)/(area*area/2); % boundaries
% N(end,area/2+1:end-area/2)= N(end,area/2+1:end-area/2)/(area*area/2);
% N(area/2+1:end-area/2,1)  = N(area/2+1:end-area/2,1)/(area*area/2);
% N(area/2+1:end-area/2,end)= N(area/2+1:end-area/2,end)/(area*area/2);



end