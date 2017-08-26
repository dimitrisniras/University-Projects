function [ throughput ] = Throughput( response_times )
sum = 0;
n = 0;
j = 0;
for i=1:length(response_times)
sum = sum + response_times(i);
n = n + 1;
if (sum >= 8000)
j = j + 1;
throughput(j) = n/8;
while (sum > 7000)
sum = sum - response_times(i-n+1);
n = n - 1;
end
end
end
end

