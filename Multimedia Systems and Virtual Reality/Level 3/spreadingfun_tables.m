function [spread_long, spread_short] = spreadingfun_tables()

load('TableB219.mat');

table = B219a;
bval = table(:,5);
spread_long = zeros(size(table,1),size(table,1));

for i=1:size(table,1)
    for j=1:size(table,1)
        spread_long(i,j) = spreadingfun(i,j,bval);
    end
end

table = B219b;
bval = table(:,5);
spread_short = zeros(size(table,1),size(table,1));

for i=1:size(table,1)
    for j=1:size(table,1)
        spread_short(i,j) = spreadingfun(i,j,bval);
    end
end

end

function x = spreadingfun(i,j,bval)

if (i >= j) 
    tmpx = 3*(bval(j)-bval(i));
else
    tmpx = 1.5*(bval(j)-bval(i));
end

tmpz = 8*min((tmpx-0.5)^2 - 2*(tmpx-0.5), 0);
tmpy = 15.811389 + 7.5*(tmpx+0.474) - 17.5*sqrt(1 + (tmpx+0.474)^2);

if (tmpy < -100)
    x = 0;
else
    x = 10^((tmpz+tmpy)/10);
end

end