function bestPoly = ransac(data, n, t, m, q)

% Data is a vector where each row corresponds to one observation (x,y)

% n : number of points used to sample first polynomial
% t : distance from polynomial which is accepted
% m : number of iterations
% q : lower limit for number of acceptable points for consensus set
% Providing only one argument (data) chooses default values of params.

% Returns bestPoly: the best polynomial found fitted by MATLAB's polyfit,
% i.e. it contains the the coefficients for the corresponding polynomial
% If no good polynomial is found as message will be disp'ed and 0 is
% returned. 

% Standard settings
if(nargin==1)
    n=3; 
    t=2; 
    m=100; 
    q=n; 
end
    
maxC=0; % number of elements in largest consensus set so far
ny=length(data); % number of evaluation points for polynomial

bestPoly=0;
  
vec=1:length(data);
sampleVec1=zeros(n,2);

for l=1:m
    
    y=datasample(vec, n, 'Replace', false);
    
    for k=1:n
        sampleVec1(k,1)=data(y(k),1);
        sampleVec1(k,2)=data(y(k),2);
    end
    
    p=polyfit(sampleVec1(:,1), sampleVec1(:,2), 1);
    
    xmin=min(data(:,1));
    xmax=max(data(:,1));
    
    xVal=linspace(xmin, xmax, ny); % range over which to eval poly
    
    pEval=polyval(p, xVal);
    
    Y=zeros(ny,2);
    Y(:,1)=xVal;
    Y(:,2)=pEval;
    
    consensusSet=rangesearch(data, Y, t);
    
    A=zeros(n*n, 1); % find a better solution for this (~3% of computation; not a priority)
    
    for i=1:ny
        tmp=consensusSet{i};
        for j=1:length(tmp)
            A((i-1)*ny+j)=tmp(j);
        end
    end
    
    C1=unique(A);
    C1=C1(C1~=0); % C1 contains data points within distance t of first polynomial
    
    % if consensus set is large enough, refit poly
    if(length(C1)>q && length(C1)>maxC)
        
        n2=length(C1);
        maxC=n2;
        
        sampleVec2=zeros(n2,2);
        
        for k=1:n2
            sampleVec2(k,1)=data(C1(k),1);
            sampleVec2(k,2)=data(C1(k),2);
        end
        
        bestPoly=polyfit(sampleVec2(:,1), sampleVec2(:,2), 1);
    end
end


if(~(maxC>q && length(bestPoly)>1))
    disp('**Warning: no good polynomial found**')
end

end