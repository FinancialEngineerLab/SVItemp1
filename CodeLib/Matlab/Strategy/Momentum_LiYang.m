% 计算每只股票的过去LookBack（参数）日的动量，并作标准化处理作为股票权重，持有Holding（参数）日，其中权重允许为负数，即允许做空股票

%%
% !!!!!!add 提取数据

%% weight
function weight = calc_mom(price,lookback)
    weight = zeros(size(price));
    weight(:,1) = price(:,1);
    [m,n] = size(price);
    % weight(1:lookback,2:end) = nan;
    weight(1:lookback,2:end) = 0;
    for j = lookback+1:m 
        for i = 2:n
            tData = price(:,i);
            weight(j,i) =  (tData(j-1)-tData(j-lookback))/tData(j-lookback);
        end
        
        temp = weight(j,2:end);
        weight(j,2:end) = (temp-mean(temp))./std(temp);
    end
    
    weight(isnan(weight)) = 0;
end    

%% stra_sr
function SR = strat_sr(prices, lb, hold)
    SR = 0;
    [m,n] = size(prices);
    % 计算权重
    port = calc_mom(prices,lb);
    port(isnan(port)) = 0;
    
    % 计算组合收益
    PortResample = [];
    Returns = [];
    Ind = 1;
    for i = hold:hold:m
        PortResample(Ind,:) = port(i-hold+1,:);
        Returns(Ind,:) = prices(i,:);
        Returns(Ind,2:end) = (prices(i,2:end)-prices(i-hold+1,2:end))./prices(i-hold+1,2:end);

        Ind = Ind + 1;
    end
    port_rets = PortResample(:,2:end).*Returns(:,2:end);
    port_rets = sum(port_rets,2);
    % 计算年化Sharpe Ratio
    SR = mean(port_rets)/std(port_rets)*sqrt( 252/hold );

end



lookbacks = 20:5:90;
holdings = 20:5:100;

DD = zeros(length(lookbacks), length(holdings));

for i = 1:length(lookbacks)
    for j = 1:length(holdings)
        lb = lookbacks(i);
        hold = holdings(j);
        DD(i,j) = strat_sr(StockMat, lb, hold);
    end
end
toc;


%% HeatPlot
temp = num2cell(lookbacks);
temp = cellfun(@num2str,temp,'UniformOutput',false);
YVarNames = temp;

temp = num2cell(holdings);
temp = cellfun(@num2str,temp,'UniformOutput',false);
XVarNames = temp;

XLabelString = 'Holding Period';
YLabelString = 'Lookack Period';
Fmatrixplot(DD,'ColorBar','On','XVarNames',XVarNames,'YVarNames',YVarNames,...
    'XLabelString',XLabelString,'YLabelString',YLabelString);
