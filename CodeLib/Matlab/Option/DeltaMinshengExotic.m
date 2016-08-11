function ans = DeltaMinshengExotic(StartPrice, CurrentPrice, Vol, TimeToMat, RiskFreeRate, UpperBound, UpperRatio, LowerBound, LowerRatio, Margin, NbPath)
    [Row,Col] = size(CurrentPrice);
    ans = zeros(Row,Col);
    for i = 1:Row
        for j = 1:Col
            price1 = MinshengExotic(StartPrice, CurrentPrice(i,j)*1.001, Vol, TimeToMat(i,j), RiskFreeRate, UpperBound, UpperRatio, LowerBound, LowerRatio, Margin, NbPath);
            price2 = MinshengExotic(StartPrice, CurrentPrice(i,j)*0.999, Vol, TimeToMat(i,j), RiskFreeRate, UpperBound, UpperRatio, LowerBound, LowerRatio, Margin, NbPath);
    
            ans(i,j) = (price1 - price2)/(CurrentPrice(i,j)*0.002)*StartPrice;
            
            %ans(i, j) = blsdelta(CurrentPrice(i,j)/StartPrice,1,RiskFreeRate,TimeToMat(i,j),Vol);
        end
    end
end 