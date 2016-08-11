function Profit_or_Loss = ReplicationMingshengExotic(StartPrice, CurrentPrice, Vol, TimeToMat, RiskFreeRate, UpperBound, UpperRatio, LowerBound, LowerRatio, Margin, NbPath)
 
    commision = 0.0003; %交易成本
    N = round(TimeToMat*252);
    
    %p columns of the N-1 rehedging times (from T/N to T-T/N)
    Times = cumsum(ones(N-1,NbPath))*TimeToMat/N;
    
    %simulate p discretized paths at times T/N to T
    S = (RiskFreeRate-0.5*Vol*Vol)*TimeToMat/N+Vol*randn(N,NbPath)*sqrt(TimeToMat/N);
    S = StartPrice*exp(cumsum(S));   

    %compute the initial hedge
    Initial_Delta =  DeltaMinshengExotic(StartPrice, CurrentPrice, Vol, TimeToMat, RiskFreeRate, UpperBound, UpperRatio, LowerBound, LowerRatio, Margin, NbPath);
    Bank = -Initial_Delta*StartPrice*-abs(Initial_Delta)*StartPrice*commision;
 
    %compute all the deltas
    %Delta = ones(N-1,NbPath);
    Delta = DeltaMinshengExotic(StartPrice, S(1:(N-1),:), Vol, TimeToMat-Times, RiskFreeRate, UpperBound, UpperRatio, LowerBound, LowerRatio, Margin, NbPath);
   

    %compute the gains from trading at each rehedging times
    Gains = ([Initial_Delta*ones(1,NbPath);Delta(1:N-2,:)]-Delta(1:N-1,:)).*S(1:(N-1),:);
    Gains = Gains-commision*abs(Gains);

    %Profit or Loss is the sum of the actualized gains from trading+
    %what was in the bank at the begining+what is held in stock-
    %payments to the client
    Payoff = ones(1, NbPath);
    Payoff = ExoticPayOff (StartPrice, S(N,:), UpperBound, UpperRatio, LowerBound, LowerRatio, Margin);
     
    Profit_or_Loss = exp(-RiskFreeRate*TimeToMat)*(exp(RiskFreeRate*(TimeToMat-Times(:,1)))'*Gains+Bank*exp(RiskFreeRate*TimeToMat)...
                               +Delta(N-1,:).*S(N,:)*(1-commision)-Payoff);
    
    Profit_or_Loss = Profit_or_Loss/StartPrice;
    
    %results
    -quantile(Profit_or_Loss,.10);

    %-mean(Profit_or_Loss)

    Profit_or_Loss = -mean(Profit_or_Loss);
end