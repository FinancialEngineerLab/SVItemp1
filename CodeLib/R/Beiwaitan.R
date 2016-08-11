
#fileFormat = 1, csv

beiwaitan.utils.test<-function()
{
	return £¨"hi"£©
}


beiwaitan.utils.readfile<-function(fileFormat,fileAddress, headerFlag,sepFlag)
{
	if(fileFormat == 1) {
		dataTable = read.table(fileAddress,header = headerFlag,sep =sepFlag )
	}
	print("Hi From ")
	return (dataTable)
}

beiwaitan.utils.plot<-function(x_axis_data, y_axis_data, dim_y_axis)
{
	plot(x_axis_data, y_axis_data)
	axis(1, at = 1:max(x_axis_data), labels = letters[1:max(x_axis_data)])
}


beiwaitan.stat.reg <- function(data_y, data_x){
 lm.sol<- lm(data_y, data_x +1)

}

