
%***********************************************************%
% INPUT:
% price_vector: a time serie of price
%***********************************************************%
% OUTPUT: 
% normalize the price series into a NAV form( start value is 1.0)
%***********************************************************%

function ret = Utility_NormalizePriceVector(price_vector)
    ret = price_vector/price_vector(1);
end