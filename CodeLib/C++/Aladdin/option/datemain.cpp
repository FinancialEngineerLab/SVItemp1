#include "datemain.h"



int add_tenor(int iToday,int n, TimeUnit unit,BusinessDayConvention bConvention, bool endOfMonth)
{
	Date dReturnDate;
	Calendar cCalendar(iToday);

	dReturnDate = cCalendar.addTenor(Date(iToday),n,unit, bConvention,endOfMonth);

	return dReturnDate.serialNumber();
}


TimeUnit read_tenor(char* cTenor)
{
	
	if(!strcmp(cTenor,"BD") || !strcmp(cTenor,"bd")|| !strcmp(cTenor,"Bd")|| !strcmp(cTenor,"BDay"))
	{
		return Days;
	}
	else if(!strcmp(cTenor,"M")||  !strcmp(cTenor,"m")||!strcmp(cTenor,"Month"))
	{
		return Months;
	}
	else if(!strcmp(cTenor,"Y")||  !strcmp(cTenor,"y")||!strcmp(cTenor,"Year"))
	{
		return Years;
	}
	else if(!strcmp(cTenor,"D") || !strcmp(cTenor,"d")|| !strcmp(cTenor,"Day"))
	{
		return NormalDays;
	}
	else
	{
		ALADDIN_FAIL("Unrecognizable tenor");
	}
}

BusinessDayConvention read_bc(char* cBC)
{

	if(!strcmp(cBC,"F") || !strcmp(cBC,"f")|| !strcmp(cBC,"Following"))
	{
		return Following;
	}
	else if(!strcmp(cBC,"U")||  !strcmp(cBC,"u")||!strcmp(cBC,"Unadjusted"))
	{
		return Unadjusted;
	}
	else
	{
		ALADDIN_FAIL("Unrecognizable convention");
	}
}