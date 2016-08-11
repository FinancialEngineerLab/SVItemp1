
mu = 0.03;
S0 = 1;
sig = 0.3;

month = 3;
K = S0;

r = 0.03; %无风险利率
commision = 0.003; %交易成本
p = 100; %模拟路径数

N = 20*month;
T = month/12;

%p columns of the N-1 rehedging times (from T/N to T-T/N)
Times = cumsum(ones(N-1,p))*T/N;

%simulate p discretized paths at times T/N to T
S = (mu-0.5*sig*sig)*T/N+sig*randn(N,p)*sqrt(T/N);
S = S0*exp(cumsum(S));

%compute the initial hedge
[Call,Put] = blsdelta(S0,K,r,T,sig);
Initial_Delta = Call;
Bank = -Initial_Delta*S0*(1+commision);

%compute all the deltas
[Call,Put] = blsdelta(S(1:(N-1),:),K,r,T-Times,sig);
Delta = Call;

%compute the gains from trading at each rehedging times
Gains = ([Initial_Delta*ones(1,p);Delta(1:N-2,:)]-Delta(1:N-1,:)).*S(1:(N-1),:);
Gains = Gains-commision*abs(Gains);

%Profit or Loss is the sum of the actualized gains from trading+
%what was in the bank at the begining+what is held in stock-
%payments to the client
Profit_or_Loss = exp(-r*T)*(exp(r*(T-Times(:,1)))'*Gains+Bank*exp(r*T)...
                           +Delta(N-1,:).*S(N,:)*(1-commision)-max(0,S(N,:)-K));

%results
-quantile(Profit_or_Loss,.10)

%-mean(Profit_or_Loss)

[Call,Put] = blsprice(S0, K, r, T, sig);
Call


