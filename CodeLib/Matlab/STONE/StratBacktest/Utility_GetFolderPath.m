
%***********************************************************%
% INPUT:
% NONE
%***********************************************************%
% OUTPUT: 
% Current path of the folder  'C:\Test\'
%***********************************************************%

function p1 = Utility_GetFolderPath()

p1 = mfilename('fullpath');
i = strfind(p1,'\');
p1 = p1(1:i(end));

end
