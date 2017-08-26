function [t] = rec_cost(n)

if (n == 1) 
    t = 0;
else
    t = (n/2 * 6) + (6 * n /2) + (2 * rec_cost(n/2));
end

end