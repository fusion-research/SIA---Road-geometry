function bestPoly = ransac(I, n, t, m, q, pMin, polyDeg)

% I : binary matrix where 1 corresponds to observation and 0 corresponds to
% no observation
% n : number of points used to sample first polynomial
% t : distance from polynomial which is accepted
% m : number of iterations
% q : lower limit for number of acceptable points for consensus set
% Providing only one argument (I) chooses default values of params.

% Returns bestPoly: the best polynomial found fitted by MATLAB's polyfit,
% i.e. it contains the the coefficients for the corresponding polynomial
% If no good polynomial is found as message will be disp'ed and 0 is
% returned. 

% Suppress warning from polyfit (irrelevant for m large enough)
% warning('off', 'MATLAB:polyfit:RepeatedPointsOrRescale'); (not needed using polyfitAlternative)
warning('off', 'MATLAB:nearlySingularMatrix');

% Thoughts about further opt:
% - rangesearch takes a lot of times. could we write our own function which
% only counts each point once? i.e. if point x_i lies within distance t of 
% point y_j we do not care about x_i any longer: we don't have to check
% its distance from the other points y_k, k~=j

% Check other values of params; standard settings have mostly been used so
% far. 

%tmpavg=0;

[i,j]=find(I>0);
data=[i,j];

% Data is a vector where each row corresponds to one observation (x,y)

% Standard settings
if(nargin==1)
    n=3; 
    t=2; 
    m=100; 
    q=n; 
    pMin=n;
elseif(nargin==5)
    pMin=n;
    polyDeg=1;
end
    
maxC=0; % number of elements in largest consensus set so far

% should ny really be length(data)???
%ny=length(data); % number of evaluation points for polynomial
ny=round(length(data)/2); 
% ny could be made smaller to save time; this will affect results tho..

bestPoly=0;

%disp(data)

% If the image doesn't have enough available points, do not run algorithm
if(length(data) < max(n, pMin))
    return;
end

vec=1:length(data);
sampleVec1=zeros(n,2);

for l=1:m
    
    y=datasample(vec, n, 'Replace', false);
    
    for k=1:n
        sampleVec1(k,1)=data(y(k),1);
        sampleVec1(k,2)=data(y(k),2);
    end
    
    %p=polyfit(sampleVec1(:,1), sampleVec1(:,2), 1);
    p=polyfitAlternative(sampleVec1(:,1), sampleVec1(:,2), 1);
    
    xmin=min(data(:,1));
    xmax=max(data(:,1));
    
    xVal=linspace(xmin, xmax, ny); % range over which to eval poly
    pEval=polyval(p, xVal);
    
    Y=zeros(ny,2);
    Y(:,1)=xVal;
    Y(:,2)=pEval;
    
    consensusSet=rangesearch(data, Y, t); % 42 %
    
    % ****
    % find a better solution for this
    % was 3 %, is now ~26 % of computation
    
    %A=zeros(ny, 1);  
    
%     mcs = cellfun(@(x)(mat2str(x)), consensusSet, 'uniformoutput', false);
%     B=unique(mcs);
%     disp(size(B))
%     B=B(B~=0);
%     C1=B;

    A=zeros(ny*n,1); % this pre-allocation is kinda arbitrarily done..
    %A=zeros(ny, 1);
    
    for i=1:ny
        tmp=consensusSet{i};
        for j=1:length(tmp)
            A((i-1)*ny+j)=tmp(j);
        end
    end
    
    A=A(A~=0); % 20 % 
    C1=unique(A);
    % ****
    
    % atm tmp (on average) is too short for us to experience any substantial 
    % cache misses. check if is also the case for a typical image.
    % this is prolly why method above is faster..
    
%     for i=1:ny
%         tmp=consensusSet{i};
%         A((i-1)*ny+1 : (i-1)*ny+length(tmp))=tmp;
%     end

    %tmpavg=tmpavg+length(tmp);
    
    
%     A=A(A~=0); % 20 % 
%     C1=unique(A);
    %C1=C1(C1~=0);
    % C1 contains data points within distance t of first polynomial
    
    % if consensus set is large enough, refit poly
    if(length(C1)>q && length(C1)>maxC)        
        n2=length(C1);
        maxC=n2;
        
        sampleVec2=zeros(n2,2);
        
        for k=1:n2
            sampleVec2(k,1)=data(C1(k),1);
            sampleVec2(k,2)=data(C1(k),2);
        end
        
        %bestPoly=polyfit(sampleVec2(:,1), sampleVec2(:,2), 1);
        bestPoly=polyfitAlternative(sampleVec2(:,1), sampleVec2(:,2), polyDeg);
    end
end

%disp(size(A))
%disp(ny)
%tmpavg/m
%disp(maxC)

if(~(maxC>q && length(bestPoly)>1))
    disp('**Warning: no good polynomial found**')
end

end
