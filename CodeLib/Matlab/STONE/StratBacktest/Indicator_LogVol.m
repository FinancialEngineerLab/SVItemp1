%***********************************************************%
% INPUT:
% price_vector = vector of pricies
% current_pos = current index position of the vector
% length = length of period
%***********************************************************%
% OUTPUT: 
% volatility of log price
%***********************************************************%

function log_vol = Indicator_LogVol(price_vector,current_pos,length)
if(length>current_pos)
   log_vol = std(log(price_vector(1:current_pos))); 
else
   log_vol = std(log(price_vector(current_pos-length+1:current_pos))); 
end
end