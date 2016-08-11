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
		
		if(oRange(i,0) == "IsPathDependent")  //"·������"
		{
			(*pPayoffParams)->iPathDep = (int)oRange(i,1);
		}
		else if(oRange(i,0) == "OptionType")  //��Ȩ����
		{
			(*pPayoffParams)->iOptionType = (int)oRange(i,1);
		}
		else if(oRange(i,0) == "Strike")  //��Ȩ��
		{
			(*pPayoffParams)->dStrike = oRange(i,1);
		}
		else if(oRange(i,0) == "IsPayOffInRatio")  //��������Ϊ����
		{
			(*pPayoffParams)->iUseRatio = (int)oRange(i,1);
		}
		else if(oRange(i,0) == "Margin")   //��Ȩ��������
		{
			(*pPayoffParams)->dMargin = oRange(i,1);
		}
		else if(oRange(i,0) == "UpbarrierOnPayoff")  //������������
		{
			(*pPayoffParams)->dUpbarrierOnPayoff = oRange(i,1);
		}
		else if(oRange(i,0) == "DownbarrierOnPayoff")  //������������
		{
			(*pPayoffParams)->dDownbarrierOnPayoff = oRange(i,1);
		}
		else if(oRange(i,0) == "UpbarrierOnPath")  //���·������
		{
			(*pPayoffParams)->dUpbarrierOnPath = oRange(i,1);
		}
		else if(oRange(i,0) == "DownbarrierOnPath")   //���·������
		{
			(*pPayoffParams)->dDownbarrierOnPath = oRange(i,1);
		}
		else if(oRange(i,0) == "UpShareRatio")   //���Ƿ������
		{
			(*pPayoffParams)->dUpRatio = oRange(i,1);
		}
		else if(oRange(i,0) == "DownShareRatio")   //�µ��������
		{
			(*pPayoffParams)->dDownRatio = oRange(i,1);
		}
		else if(oRange(i,0) == "DeltaHedging")     //delta�Գ�
		{   
			(*pPayoffParams)->iDeltaHedging = (int)oRange(i,1);
		}
		else if(oRange(i,0) == "Commission")     //������
		{   
			(*pPayoffParams)->dCommision = oRange(i,1);
		}
	}
}
