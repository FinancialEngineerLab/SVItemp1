
function ans = ExoticPayOff (StartPrice, FinalPrice, UpperBound, UpperRatio, LowerBound, LowerRatio, Margin)
    [Row,Col] = size(FinalPrice);
    ans = zeros(Row,Col);
    
    for i = 1:Row
        for j = 1: Col
          %ans(i,j) = max(FinalPrice(i,j)/StartPrice - 1,0);
           GrowthRate = FinalPrice(i,j)/StartPrice;
           if GrowthRate < LowerBound 
              ans(i,j) = Margin;
           else if GrowthRate <1 
                  ans(i,j) = Margin + (1-GrowthRate)*LowerRatio; 
               else if GrowthRate < UpperBound
                      ans(i,j) = Margin + (GrowthRate-1)*UpperRatio; 
                   else
                       ans(i,j) = Margin;
                   end
               end
           end
        end
    end
    
    
    
    
end