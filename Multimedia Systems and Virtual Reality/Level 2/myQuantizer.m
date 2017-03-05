function [ output_args ] = myQuantizer( input_args )
%MYQUANTIZER Summary of this function goes here
% proof-run: a = -0.8:0.01:0.8; b = myQuantizer(a);plot(a,b)
output_args = input_args; %zeros(length(input_args),1);
for i = 1:length(input_args)
    output_args(i) = SingleMyQuantizer(input_args(i));
end

end

%% the simmetric quantizer with step 0.1 for a single float number 
function result = SingleMyQuantizer(input)
    if(input >= 0.7)
        result = 0.75;
    elseif (input >= 0.6)
        result = 0.65;
    elseif (input >= 0.5)
        result = 0.55;
    elseif (input >= 0.4)
        result = 0.45;
    elseif (input >= 0.3)
        result = 0.35;
    elseif (input >= 0.2)
        result = 0.25;
    elseif (input >= 0.1)
        result = 0.15;
    elseif (input >= 0)
        result = 0.05;
    elseif (input >= -0.1)
        result = -0.05;
    elseif (input >= -0.2)
        result = -0.15;
    elseif (input >= -0.3)
        result = -0.25;
    elseif (input >= -0.4)
        result = -0.35;
    elseif (input >= -0.5)
        result = -0.45;
    elseif (input >= -0.6)
        result = -0.55;
    elseif (input >= -0.7)
        result = -0.65;
    else
        result = -0.75;
    end
end