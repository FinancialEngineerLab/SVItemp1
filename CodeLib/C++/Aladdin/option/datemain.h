#pragma once
#include "calendar.h"
#include "Aladdin\xll\oper.h"

int add_tenor(int iToday,int n, TimeUnit unit,BusinessDayConvention bConvention, bool endOfMonth);
TimeUnit read_tenor(char* cTenor);
BusinessDayConvention read_businessdayconvention(char* cConvention);