function [A,B] = myransac(intPoints1, intPoints2, R)

n = length(R);
threshold = 10^-2;

k = zeros(1000,1);
for i = 1:1000
    
    co1 = randi([1 n]);
    co2 = randi([1 n]);
    
    while (co2 == co1)
        co2 = randi([1 n]);
    end
    
    co3 = randi([1 n]);
    
    while (co3 == co2 || co3 == co1)
        co3 = randi([1 n]);
    end
    
    p11 = intPoints1.Location(R(co1,1),:);
    p12 = intPoints1.Location(R(co2,1),:);
    p13 = intPoints1.Location(R(co3,1),:);
    p21 = intPoints2.Location(R(co1,2),:);
    p22 = intPoints2.Location(R(co2,2),:);
    p23 = intPoints2.Location(R(co3,2),:);
    
    p1 = [p11; p12; p13];
    p2 = [p21; p22; p23];
    
    [Ai, Bi] = findAffineTransform(p1,p2);
    
    for j = 1:intPoints1.length
        intPoints1.Location(j,:) = Ai * intPoints1.Location(j,:)' + Bi;
        
        for z = 1:intPoints2.length
            if (immse(intPoints1.Location(j,:),intPoints2.Location(z,:)) <= threshold)
                k(i) = k(i) + 1;
            end
        end
        
    end
    
    if (i == 1)
        A = Ai;
        B = Bi;
    elseif (k(i) >= k(i-1))
        A = Ai;
        B = Bi;
    end
    
end

end

