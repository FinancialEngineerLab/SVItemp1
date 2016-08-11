Spot= 100;
Strike = 80;
RiskFree = 0.05;
TimeToMat = 1;
OptionPrice=2.56;
Vol = 0.3;
CallOrPut = 1
[Call, Put] = blsprice(Spot,Strike,RiskFree,TimeToMat,Vol);


Spot= 100;
Strike = 70;
RiskFree = 0.05;
TimeToMat = 0.25;
OptionPrice=2.56;
Vol = 0.1;
CallOrPut = 1
[Call, Put] = blsprice(Spot,Strike,RiskFree,TimeToMat,Vol);

blsimpv(Spot,Strike,RiskFree,TimeToMat,Call)