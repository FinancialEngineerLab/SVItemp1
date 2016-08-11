tradetime = zeros(1);
hurst_yield = zeros(1);
object_money = zeros(1);
object_yield = zeros(1);
for i = 1:lastcol
    tradetime(i) = max(buy{1,i},sell{1,i});
    hurst_yield(i) = (money(i)-10000)/10000;
    object_money(i) = 10000/in1(1)*in1(find(time == tradetime(i)));
    object_yield(i) = (object_money(i)-10000)/10000;
end
h=figure;
plot(tradetime,hurst_yield,'r');
hold on
plot(tradetime,object_yield,'b');
title('Hurst策略与标的指数收益率比较');
datetick('x',2);
grid on
legend('Hurst策略','标的指数');







