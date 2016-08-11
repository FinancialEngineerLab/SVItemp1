% y=b[0]+b[1]*x1+b[2]*x3+b[3]*x3...
function [b, bint, r, rint, stats] = QuickReg(data_y,data_x) 
    [b, bint, r, rint, stats] = regress(data_y,data_x);
    disp('R^2  is');
    disp(stats[1]);
    disp('-----------------------------')
    disp('F stat  is');
    disp(stats[2]);
    disp('-----------------------------')
    disp('p-value  is');
    disp(stats[3]);
    
end