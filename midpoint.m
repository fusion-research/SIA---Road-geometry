function T=midpoint(I,Tstart)
%T=midpoint(I,Tstart);
%
%Uses the midpoint method of finding a threshold value of I
%Tstart is the optional starting threshold and must be in [0,1].
%The histogram of the image I should be bimodal with both peaks in [0,1].
%
%
%Mats K 010124 modified 030120

if nargin==1 %nargin means: Number of ARGuments (IN)
   Tstart=.5;
end

[C,x]=imhist(I);
%C is the counts of the corresponding pixel values in x
L=length(C);

%find index in C corresponding to Tstart:
Tstart=find(x>=Tstart);
Tstart=Tstart(1);

%Tstart is now an integer valued number 


%---------------------------------
%Everything within these two lines are just for controlling
%that Tstart was chosen properly

if Tstart>=L
    Tstart=L-1;
end

Cl=sum(C(1:Tstart));   %Number of counts in the lower part (below Tstart)
Cu=sum(C(Tstart+1:L)); %Number of counts in the upper part (above Tstart)

%Controlling that both categories are non-empty
if Cl==0
    while Cl==0
        Tstart=Tstart+1;
        Cl=sum(C(1:Tstart));
    end
elseif Cu==0
    while Cu==0
        Tstart=Tstart-1;
        Cu=sum(C(Tstart+1:L));
    end
end

%--------------------------------

Told=Tstart-1;
T=Tstart;

while T~=Told     %`~=' means `not equal to'
    my0=x(1:T)'*C(1:T)/sum(C(1:T));
    my1=x(T+1:L)'*C(T+1:L)/sum(C(T+1:L));
    Told=T;
    T=round((my0+my1)/2*L);
end
%Return a number between zeros and one
T=T/L;
