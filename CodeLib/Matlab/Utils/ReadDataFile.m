%fileFormat = 1,xls, varargin 1= SheetName, 2 = RangeName
function dataTable = ReadDataFile(fileFormat, filePath,varargin) 
    if fileFormat == 1
        if numel(varargin) == 0  
            dataTable = xlsread(filePath);
        elseif numel(varargin) == 1 % input a SheetName(or SheetNumber) 
            dataTable = xlsread(filePath, varargin{1});
        elseif numel(varargin) == 2 % also input a RangeName
            dataTable = xlsread(filePath, varargin{1},varargin{2});
        else
            disp('too many param');
            return;
        end
    else
        disp('Currently only accept fileFormat = 1');
        return
    end 
end