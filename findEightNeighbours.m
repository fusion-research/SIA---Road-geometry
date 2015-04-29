function n = findEightNeighbours(I, x, y)

N = size(I);
n = [];

% North
if y == 1
    ;
else
    n(end+1) = I(x,y-1);
end

% East
if x== N(1)
    ;
else
    n(end+1) = I(x+1,y);
end

% South
if y == N(2)
    ;
else
    n(end+1) = I(x,y+1);
end

% West
if x == 1
    ;
else
    n(end+1) = I(x-1,y);
end


end