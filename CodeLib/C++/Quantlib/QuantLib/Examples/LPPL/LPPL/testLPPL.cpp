#include "testLPPL.h"
#include "LPPL.h"


using namespace QuantLib;


#define REPORT_FAILURE(Tc,  M, Omega,\
					   expected_Tc, calculated_Tc, tolerance_Tc, expected_M, calculated_M, \
					   tolerance_M,expected_Omega, calculated_Omega, tolerance_Omega) \
	QL_FAIL( \
	" LPPL calibration  " \
	<< "    expected   " << Tc << ": " << expected_Tc << "\n" \
	<< "    calculated " << Tc << ": " << calculated_Tc << "\n"\
	<< "    error:            " << std::fabs(expected_Tc-calculated_Tc) \
	<< "\n" \
	<< "    tolerance:        " << tolerance_M<<"\n" \
	<< "    expected   " << M << ": " << expected_M << "\n" \
	<< "    calculated " << M << ": " << calculated_M << "\n"\
	<< "    error:            " << std::fabs(expected_M-calculated_M) \
	<< "\n" \
	<< "    tolerance:        " << tolerance_Omega<<"\n" \
	<< "    expected   " << Omega << ": " << expected_Omega << "\n" \
	<< "    calculated " << Omega << ": " << calculated_Omega << "\n"\
	<< "    error:            " << std::fabs(expected_Omega-calculated_Omega) \
	<< "\n" \
	<< "    tolerance:        " << tolerance_Omega<<"\n" \
);


void TestLPPL::testLPPLHelper()
{
	string strFilePath = "testData.txt";
	int iSkipedCols = 1;
	int iNbCols = 4;
	LPPLHelper lpplHelper(strFilePath, iNbCols, iSkipedCols);
	lpplHelper.readDataFromTxt();
	vector<double> vecData = lpplHelper.get1DVectorFromDataMatrix(3);

	Array calculated(3);
	calculated[0] = vecData[0]; 
	calculated[1] = vecData[50];
	calculated[2] = vecData[99];

	Array expected(3);
	expected[0] = 2186.1150;
	expected[1] = 2103.6710;
	expected[2] = 2072.8310;
	double tolerance = 1.0e-4;

	if(std::fabs(DotProduct(calculated-expected,calculated-expected)) > tolerance){
		REPORT_FAILURE("Data 0", "Data 50", "Data 99",expected[0],calculated[0], tolerance,
			expected[1],calculated[1], tolerance,
			expected[2],calculated[2], tolerance);
	}
	else
	{
		cout<<"-------------------------------------------"<<endl;
		cout<<" testLPPLCalculator_lpplCalibration: PASS"<<endl;
		cout<<"-------------------------------------------"<<endl<<endl;
	}
}


void TestLPPL::testLPPLCalculator_lpplCalibration()
{
	string strFilePath = "testData.txt";
	int iSkipedCols = 1;
	int iNbCols = 4;
	LPPLHelper lpplHelper(strFilePath, iNbCols, iSkipedCols);
	lpplHelper.readDataFromTxt();

	double dMLowerBound = 0.01;
	double dMUpBound = 2.0;
	double dMStepSize = 0.05; 
	double dTcLowerBound = 1.0; 
	double dTcUpBound = 1.2; 
	int iTcStepSize = 2;
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

	Array arrayOptimParams = lpplCalc.lpplCalibration();


	Array calculated(3);
	calculated[0] = arrayOptimParams[3]; //Tc
	calculated[1] = arrayOptimParams[4]; //m
	calculated[2] = arrayOptimParams[5]; //oemga

	Array expected(3);
	expected[0] = 104;
	expected[1] = 1.71;
	expected[2] = 9;
	double tolerance = 1.0e-4;

	if(std::fabs(DotProduct(calculated-expected,calculated-expected)) > tolerance){
		REPORT_FAILURE("Tc", "M", "Omega",expected[0],calculated[0], tolerance,
						expected[1],calculated[1], tolerance,
						expected[2],calculated[2], tolerance);
	}
	else
	{
		cout<<"-------------------------------------------"<<endl;
		cout<<" testLPPLCalculator_lpplCalibration: PASS"<<endl;
		cout<<"-------------------------------------------"<<endl<<endl;
	}
}


void TestLPPL::testLPPLCalculator_lpplConfidence()
{
	string strFilePath = "testData.txt";
	int iSkipedCols = 1;
	int iNbCols = 4;
	LPPLHelper lpplHelper(strFilePath, iNbCols, iSkipedCols);
	lpplHelper.readDataFromTxt();

	double dMLowerBound = 0.01;
	double dMUpBound = 2.0;
	double dMStepSize = 0.05; 
	double dTcLowerBound = 1.0; 
	double dTcUpBound = 1.2; 
	int iTcStepSize = 2;
	double dOmegaLowerBound = 1.0; 
	double dOmegaUpBound = 50.0; 
	double dOmegaStepSize = 0.5;
	int iConfidenceTimeIntervalMin = 90;
	int iConfidenceTimeIntervalMax = 100;
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
		vecDatetime,
		iConfidenceTimeIntervalMin,
		iConfidenceTimeIntervalMax
		);

	lpplCalc.lpplConfidence();

	vector<double> vecDamping = lpplCalc.getDampingVal();
	vector<double> vecConfidence = lpplCalc.getConfidence();

	Array calculated(4);
	calculated[0] = vecDamping[0]; 
	calculated[1] = vecDamping[1]; 
	calculated[2] = vecConfidence[0];

	Array expected(4);
	expected[0] = 0.052828383035744136;
	expected[1] = 0.061299176210506269;
	//expected[2] = 2.9062003469077431;
	expected[2] = 0;
	double tolerance = 1.0e-4;

	if(std::fabs(DotProduct(calculated-expected,calculated-expected)) > tolerance){
		REPORT_FAILURE("Damping1", "Damping2", "Confidence",
			expected[0],calculated[0], tolerance,
			expected[1],calculated[1], tolerance,
			expected[2],calculated[2], tolerance);
	}
	else
	{
		cout<<"-------------------------------------------"<<endl;
		cout<<"  testLPPLCalculator_lpplConfidence: PASS"<<endl;
		cout<<"-------------------------------------------"<<endl<<endl;
	}
}


void TestLPPL::testLPPLCalculator_lpplTrust()
{
	string strFilePath = "testData.txt";
	int iSkipedCols = 1;
	int iNbCols = 4;
	LPPLHelper lpplHelper(strFilePath, iNbCols, iSkipedCols);
	lpplHelper.readDataFromTxt();

	double dMLowerBound = 0.01;
	double dMUpBound = 2.0;
	double dMStepSize = 0.05; 
	double dTcLowerBound = 1.0; 
	double dTcUpBound = 1.2; 
	int iTcStepSize = 2;
	double dOmegaLowerBound = 1.0; 
	double dOmegaUpBound = 50.0; 
	double dOmegaStepSize = 0.5;
	int iConfidenceTimeIntervalMin = 90;
	int iConfidenceTimeIntervalMax = 100;
	int iSeed = 5;
	int iResampleTimes = 20;
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
		vecDatetime,
		iConfidenceTimeIntervalMin,
		iConfidenceTimeIntervalMax,
		iResampleTimes,
		iSeed
		);

	lpplCalc.lpplTrust();

	vector<double> vecDamping = lpplCalc.getDampingVal();
	vector<double> vecTrust = lpplCalc.getTrust();

	Array calculated(4);
	calculated[0] = vecDamping[0]; 
	calculated[1] = vecDamping[1]; 
	calculated[2] = vecTrust[0];

	Array expected(4);
	expected[0] = 0.052828383035744136;
	expected[1] = 0.052828383035744136;
	expected[2] = 0;
	double tolerance = 1.0e-4;

	if(std::fabs(DotProduct(calculated-expected,calculated-expected)) > tolerance){
		REPORT_FAILURE("Damping1", "Damping2", "Trust",
			expected[0],calculated[0], tolerance,
			expected[1],calculated[1], tolerance,
			expected[2],calculated[2], tolerance);
	}
	else
	{
		cout<<"-------------------------------------------"<<endl;
		cout<<"  testLPPLCalculator_lpplTrust: PASS"<<endl;
		cout<<"-------------------------------------------"<<endl<<endl;
	}
}



