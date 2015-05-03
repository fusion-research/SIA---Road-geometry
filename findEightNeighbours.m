function res = findEightNeighbours(I)

N = size(I);
res=zeros(N);

for i=1:N(1)
    for j=1:N(2)
        
        n = 0;
        
        
        % East
        if x== N(1)
            ;
        else
            %n(end+1) = I(x+1,y);
            n=n+1;
        end
        
        
        % West
        if x == 1
            ;
        else
            %n(end+1) = I(x-1,y);
            n=n+1;
        end
        
        
        % NW, NE
        if y == 1
            ;
        else
            if(x==1) % NE
                %n(end+1) = I(x+1,y-1);
                n=n+1;
                
            elseif(x==N(1)) % NW
                %n(end+1) = I(x-1,y-1);
                n=n+1;
                
            else % NE and NW
                %n(end+1) = I(x+1,y-1);
                %n(end+1) = I(x-1,y-1);
                n=n+2;
            end
            %n(end+1) = I(x,y-1);
            n=n+1;
        end
        
        
        
        % SW, SE
        if y == N(2)
            ;
        else
            if(x==1) % SE
                %n(end+1) = I(x+1,y+1);
                n=n+1;
                
            elseif(x==N(1)) % SW
                %n(end+1) = I(x-1,y+1);
                n=n+1;
                
            else % SE and SW
                %n(end+1) = I(x+1,y+1);
                %n(end+1) = I(x-1,y+1);
                n=n+2;
            end
            %n(end+1) = I(x,y+1);
            n=n+1;
        end
        res(i,j)=n;
    end
end


end