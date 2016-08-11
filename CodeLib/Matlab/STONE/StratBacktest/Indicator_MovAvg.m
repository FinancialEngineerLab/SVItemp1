%***********************************************************%
% INPUT:
% price_vector = vector of pricies
% current_pos = current index position of the vector
% length = length of period
%***********************************************************%
% OUTPUT: 
% Moving average with period = length
%***********************************************************%

function ave = Indicator_MovAvg(price_vector,current_pos,length)
if(length>current_pos)
   ave = sum(price_vector(1:current_pos))/current_pos; 
else
   ave = sum(price_vector(current_pos-length+1:current_pos))/length; 
end
end