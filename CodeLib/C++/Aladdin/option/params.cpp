#pragma once
#include "params.h"





void readMCParams(OPERX oRange, MCPARAMS *pMCParams)
{
	int iRow = 0;

	iRow = oRange.rows();

	 for(int i = 0; i < iRow; i++)
	{
		if(oRange(i,0) == "NbPath")
		{
			(*pMCParams)->iNbPath = (int)oRange(i,1);
		}
		else if(oRange(i,0) == "NbTimeStep")
		{
			(*pMCParams)->iNbTimeStep = (int)oRange(i,1);
		}
		else if (oRange(i,0) == "VarReduction")
		{   
			(*pMCParams)->iVarReduction = (int)oRange(i,1);
		}
		else if (oRange(i,0) == "DeltaHedgingSize")
		{   
			(*pMCParams)->dDeltaHedgingSize = (double)oRange(i,1);
		}
	}
}



void readPayoffParams(OPERX oRange,PAYOFFPARAMS *pPayoffParams)
{
	int iRow = 0;

	iRow = oRange.rows();

	for(int i = 0; i < iRow; i++)
	{
		
		if(oRange(i,0) == "IsPathDependent")  //"路径依赖"
		{
			(*pPayoffParams)->iPathDep = (int)oRange(i,1);
		}
		else if(oRange(i,0) == "OptionType")  //期权类型
		{
			(*pPayoffParams)->iOptionType = (int)oRange(i,1);
		}
		else if(oRange(i,0) == "Strike")  //行权价
		{
			(*pPayoffParams)->dStrike = oRange(i,1);
		}
		else if(oRange(i,0) == "IsPayOffInRatio")  //到期收益为比例
		{
			(*pPayoffParams)->iUseRatio = (int)oRange(i,1);
		}
		else if(oRange(i,0) == "Margin")   //期权保本收益
		{
			(*pPayoffParams)->dMargin = oRange(i,1);
		}
		else if(oRange(i,0) == "UpbarrierOnPayoff")  //到期收益上限
		{
			(*pPayoffParams)->dUpbarrierOnPayoff = oRange(i,1);
		}
		else if(oRange(i,0) == "DownbarrierOnPayoff")  //到期收益下限
		{
			(*pPayoffParams)->dDownbarrierOnPayoff = oRange(i,1);
		}
		else if(oRange(i,0) == "UpbarrierOnPath")  //标的路径上限
		{
			(*pPayoffParams)->dUpbarrierOnPath = oRange(i,1);
		}
		else if(oRange(i,0) == "DownbarrierOnPath")   //标的路径下限
		{
			(*pPayoffParams)->dDownbarrierOnPath = oRange(i,1);
		}
		else if(oRange(i,0) == "UpShareRatio")   //上涨分享比例
		{
			(*pPayoffParams)->dUpRatio = oRange(i,1);
		}
		else if(oRange(i,0) == "DownShareRatio")   //下跌分享比例
		{
			(*pPayoffParams)->dDownRatio = oRange(i,1);
		}
		else if(oRange(i,0) == "DeltaHedging")     //delta对冲
		{   
			(*pPayoffParams)->iDeltaHedging = (int)oRange(i,1);
		}
		else if(oRange(i,0) == "Commission")     //手续费
		{   
			(*pPayoffParams)->dCommision = oRange(i,1);
		}
	}
}
