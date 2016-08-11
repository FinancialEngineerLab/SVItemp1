function [ r1, r2, r3, r4, r5 ] = premiumOfAll( indexCode, b1, b2, b3, b4, b5, day )
%UNTITLED Summary of this function goes here
%   输入b1,b2,b3,b4,b5为超额收益率基准天数，day为前一交易日的日期，返回所有指数的超额收益



m = length(indexCode);
r1 = 0;
r2 = 0;
r3 = 0;
r4 = 0;
r5 = 0;

for i=1:m
   result = premium(indexCode(i),b1,b2,b3,b4,b5,day);
   if i == 1
       r1 = [i, result(1,:)];
       r2 = [i, result(2,:)];
       r3 = [i, result(3,:)];
       r4 = [i, result(4,:)];
       r5 = [i, result(5,:)];
   else
       r1 = [r1; [i, result(1,:)]];
       r2 = [r2; [i, result(2,:)]];
       r3 = [r3; [i, result(3,:)]];
       r4 = [r4; [i, result(4,:)]];
       r5 = [r5; [i, result(5,:)]];
   end
end


end

