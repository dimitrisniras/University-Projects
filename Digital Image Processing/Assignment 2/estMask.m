function [h] = estMask(x,y)

[n1,n2] = size(y); % size of y array
tolerance = 10 ^ -5; % tolerance of array compare
flag = 0; 

for i = 1:200
    for j = 1:360
        h = fspecial('motion',i,j); % motion blur filter
        y_temp = conv2(h,x); % convolution of h*x
        [k1,k2] = size(y_temp); % size of convolution

         if (k1 == n1 && k2 == n2)
            e = norm(y_temp - y); % error of y_temp - y
            
            if (e <= tolerance)
                flag = 1; % done if arrays are equal
                break
            end
            
         end     
    end
    
    if (flag == 1) 
        break
    end
    
end

end
