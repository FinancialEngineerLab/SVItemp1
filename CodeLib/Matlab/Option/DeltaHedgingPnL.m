


%DeltaHedgingPnL(100,100,0,0.05,0.4,0.2,1,250,250,7);


function [PnL]=DeltaHedgingPnL(S0,K,mu,r,sigma_a, sigma_i,sigma_h,T,f,hf, nSim, iCallPut)
% f is stock frequence, hf is hedge frequence
dt=T/f; step=f/hf;
figure;
PnLs=[];
for l=1:nSim
    s=Stock(S0,mu,sigma_a,T,f);
    i=1:step:f+1;
    ii=i(1:length(i)-1);
    if(iCallPut == 1)
        v=BS_call(s(ii),K,r,sigma_i,T-(ii-1)*dt);
        v=[v,BS_call(s(f+1),K,r,sigma_i,0)];
    else
        v=BS_put(s(ii),K,r,sigma_i,T-(ii-1)*dt);
        v=[v,BS_put(s(f+1),K,r,sigma_i,0)];  
    end
    
    P=[v(1)];
    
    if(iCallPut == 1)
        delta=Delta_call(s(ii),K,r,sigma_h,T-(ii-1)*dt);
        delta=[delta,Delta_call(s(f+1),K,r,sigma_h,0)];
    else
        delta=Delta_put(s(ii),K,r,sigma_h,T-(ii-1)*dt);
        delta=[delta,Delta_put(s(f+1),K,r,sigma_h,0)];
    end
    
    cash=[P(1)-delta(1)*s(1)];
    for j=1:hf
        P=[P,delta(j)*s(i(j+1))+cash(j)*(1+r*step*dt)];
        cash=[cash,P(j+1)-delta(j+1)*s(i(j+1))];
    end
    % for printing the evolution of each PnL
    hold on;
    plot(v-P,'Color',rand(1,3));
    hold off;
    PnLs = [PnLs,P(hf+1)-v(hf+1)];
    ylabel('PnL of Hedged Position');
    xlabel('Time')
end 

end

function [d]=Delta_call(S,K,r,sigma,T)
    if (T==0)
    d=(S>K);
    else
    d1=(log(S/K)+(r+sigma^2/2)*T)./(sigma*sqrt(T));
    d=normcdf(d1);
    end 
end

function [d]=Delta_put(S,K,r,sigma,T)
    d=Delta_call(S,K,r,sigma,T)-1;
end


function [p]=BS_call(S,K,r,sigma,T)
    if (T==0)
        p=subplus(S-K);
    else
        d1=(log(S/K)+(r+sigma^2/2)*T)./(sigma*sqrt(T));
        d2=d1-sigma*sqrt(T);
        p=S.*normcdf(d1)-K*exp(-r*T).*normcdf(d2);
    end
end

function [p]=BS_put(S,K,r,sigma,T)
p=BS_call(S,K,r,sigma,T)+K*exp(-r*T)-S;
end

function [s]=Stock(S0,mu,sigma,T,f)
    %f is the frequence
    dt=T/f;
    N=randn(1,f);
    s=[S0];
    for i=1:f
        s=[s,s(i)*exp((mu-sigma^2/2)*dt+sigma*sqrt(dt)*N(i))];
    end
end