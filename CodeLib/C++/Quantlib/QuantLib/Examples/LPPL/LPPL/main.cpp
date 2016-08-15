#include "testLPPL.h"
#include "LPPL.h"

/***************************************************************************************/
int main(int, char* [])
{
	try
	{
		/******************************************************/

		/******************** Unit Test *************************/
		bool bRunTest = false;
		if(bRunTest)
		{
			TestLPPL::testLPPLHelper();
			TestLPPL::testLPPLCalculator_lpplCalibration();
			TestLPPL::testLPPLCalculator_lpplConfidence();
			TestLPPL::testLPPLCalculator_lpplTrust();
			system("PAUSE"); 
			return 0;
		}

		/******************************************************/



		/************** Read the data from txt file ************/
		string strFilePath = "SZ_Index.txt";
		int iSkipedCols = 1;
		int iNbCols = 4;
		LPPLHelper lpplHelper(strFilePath, iNbCols, iSkipedCols);
		lpplHelper.readDataFromTxt();


		/*************** Optimize the LPPL params***************/
		double dMLowerBound = 0.01;
		double dMUpBound = 2.0;
		double dMStepSize = 0.05; 
		double dTcLowerBound = 1.0; 
		double dTcUpBound = 1.2; 
		int iTcStepSize = 1;
		double dOmegaLowerBound = 1.0; 
		double dOmegaUpBound = 50.0; 
		double dOmegaStepSize = 0.5;
		vector<double> vecData = lpplHelper.get1DVectorFromDataMatrix(3);
		vector<string> vecDatetime = lpplHelper.getDatetime();

		LPPLCalculator lpplCalc( dMLowerBound,
			dMUpBound,
			dMStepSize,
			dTcLowerBound,
			dTcUpBound,
			iTcStepSize,
			dOmegaLowerBound,
			dOmegaUpBound,
			dOmegaStepSize,
			vecData,
			vecDatetime
			);

		//Array arrayOptimParams = lpplCalc.lpplCalibration();

		//lpplCalc.lpplConfidence();

		lpplCalc.lpplTrust();

		/*************** Optimize the LPPL params***************/

		system("pause");
		return 0;

	}
	catch (exception& e) 
	{
		cerr << e.what() << endl;
		return 1;
	} 
	catch (...) 
	{
		cerr << "unknown error" << endl;
		return 1;
	}
}