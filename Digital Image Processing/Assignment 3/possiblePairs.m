function [R] = possiblePairs(features1, features2)

[M1, M2] = size(features1.Features);
[N1, N2] = size(features2.Features);

threshold = 10^3;

k = 1;
for i = 1:M1
    for j = 1:N1
        dist = immse(features1.Features(i,:),features2.Features(j,:));
        
        if (dist <= threshold)
            R(k,1) = i;
            R(k,2) = j;
            
            k = k + 1;
        end
        
    end
end

end

