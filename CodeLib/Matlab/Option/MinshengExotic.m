
function ans = MinshengExotic(StartPrice, CurrentPrice, Vol, TimeToMat, RiskFreeRate, UpperBound, UpperRatio, LowerBound, LowerRatio, Margin, NbPath)

    AvgSum = 0;
    PriceSum = 0;
    N = round(TimeToMat*252);
    
    %simulate p discretized paths at times T/N to T
    S = (RiskFreeRate-0.5*Vol*Vol)*TimeToMat/N+Vol*randn(N,NbPath)*sqrt(TimeToMat/N);
    S = CurrentPrice*exp(cumsum(S));   
    FinalPrice = S(N,:);
    
    iNbKnockOut = 0;
    %for i = 1: NbPath
        %for j = 1:N
        %    if S(j,i)/StartPrice>UpperBound || S(j,i)/StartPrice<LowerBound
        %        FinalPrice(i) =0;
        %        iNbKnockOut = iNbKnockOut + 1;
        %        break
        %    end     
        %end 
        
        PayOff = ExoticPayOff(StartPrice, FinalPrice, UpperBound, UpperRatio, LowerBound, LowerRatio, Margin)*TimeToMat;
        PriceSum  = PriceSum+exp(-RiskFreeRate*TimeToMat)*PayOff;
        %PriceSum  = exp(-RiskFreeRate*TimeToMat)*PayOff;
    %end
    %iNbKnockOut
    %ProbKnockOut = iNbKnockOut / NbPath
    %PriceSum
    ans = mean(PriceSum);% / NbPath;
     
    
end



   