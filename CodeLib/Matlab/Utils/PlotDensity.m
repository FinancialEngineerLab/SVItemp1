function [] = PlotDensity(data, titleChart, x_lable_name, y_label_name,linetype,varargin) %last argument = legend name
    
    ymin = min(data);
    ymax = max(data);
    x = linspace(ymin, ymax,20);
    nbOfY = hist(data,x);%计算各个区间的个数
    nbOfY=nbOfY/length(data); %计算各个区间的个数
    
    plot(x,nbOfY,linetype,'LineWidth',2.5);
    title(titleChart);
    xlabel(x_lable_name);
    ylabel(y_label_name);
    
    if numel(varargin) == 1
        legend(varargin);
    end
    hold on
end