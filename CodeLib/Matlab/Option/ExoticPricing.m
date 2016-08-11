
function [Price,Variance] = ExoticPricing(StartPrice, CurrentPrice, Vol, TimeToMat, RiskFreeRate, UpperBound, UpperRatio, LowerBound, LowerRatio, Margin, NbPath,VarRed,PathDep) 
%shuqi:
%input: StartPrice - strike price
%       CurrentPrice - current stock price
%       UpperBound/ LowerBound - UpbarrierOnPayoff/ DownbarrierOnPayoff & UpbarrierOnPath/ DownbarrierOnPath
%       UpperRatio/ LowerRatio - UpShareRatio/ DownShareRatio
%       VarRed - dummy - 0 ordinary; 1 antithetic variate; 2 control variate
%       PathDep - dummy - 0 no; 1 yes

    AvgSum = 0;
    PriceSum = 0;
    %N = round(TimeToMat*252);
    N=500;
    
    %simulate p discretized paths at times T/N to T
    if VarRed == 1
     nu = RiskFreeRate-0.5*Vol*Vol;
     epsilon = randn(N,NbPath);
     S = CurrentPrice*[cumprod(exp(nu*TimeToMat/N+Vol*sqrt(TimeToMat/N)*[epsilon -epsilon]),1)];
     %S = (RiskFreeRate-0.5*Vol*Vol)*TimeToMat/N+Vol*[epsilon -epsilon]*sqrt(TimeToMat/N);   
     %S = CurrentPrice*exp(cumsum(S)); 
    else
      S = (RiskFreeRate-0.5*Vol*Vol)*TimeToMat/N+Vol*randn(N,NbPath)*sqrt(TimeToMat/N);
      S = CurrentPrice*exp(cumsum(S));  
    end
    
    FinalPrice = S(N,:);
    
    if PathDep == 1
      iNbKnockOut = 0;
      for i = 1: NbPath
        for j = 1:N
            if S(j,i)/StartPrice>UpperBound || S(j,i)/StartPrice<LowerBound
                FinalPrice(i) =StartPrice;
                iNbKnockOut = iNbKnockOut + 1;
                break
            end     
        end 
      end
    end
    
    PayOffEC = max(FinalPrice - StartPrice,0)/StartPrice ;  
    PayOff = ExoticPayOff(StartPrice, FinalPrice, UpperBound, UpperRatio, LowerBound, LowerRatio, Margin);
    
    if VarRed == 2
        Variance =  var(PayOff - PayOffEC);
       
    else
        Variance =  var(PayOff);
    end
    
    PriceSum  = PriceSum+exp(-RiskFreeRate*TimeToMat)*PayOff;
    %PriceSum  = exp(-RiskFreeRate*TimeToMat)*PayOff;
    %end
    %iNbKnockOut
    %ProbKnockOut = iNbKnockOut / NbPath
    %PriceSum
    Price = mean(PriceSum);% / NbPath;
     
    
end

