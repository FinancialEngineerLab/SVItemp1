// LPPL.cpp : Defines the entry point for the console application.

#include "math.h"

#include <fstream>
#include <iostream>
#include <time.h>
#include "LPPL.h"


/************************************* LPPL Helper *********************************/

void LPPLHelper::readDataFromTxt()
{
	ifstream dataFile;
	double dNumber = 0.0;
	vector<double> dataRow;
	int iDataCount = 0;
	int iSkipedCount = 0;
	string buffer;

	dataFile.open(strDataFilePath_, ios::in);

	if(dataFile.is_open())
	{
		while(dataFile >> buffer)
		{
			iDataCount +=1;
			if(iSkipedCount < iSkipCols_) // 忽略前若干列
			{
				dateTime_.push_back(buffer);
				iDataCount -= 1;
				iSkipedCount += 1;
				continue;
			}
			dNumber = std::atof(buffer.c_str());
			dataRow.push_back(dNumber);			
			if(iDataCount % iNbCols_ == 0)
			{
				dataMatrix_.push_back(dataRow);
				dataRow.clear();
				iSkipedCount = 0;
			}
		}
		dataFile.close();	
	}
	else
	{
		QL_FAIL("readDataFromTxt: failed to open data txt file");
	}

}

void LPPLHelper::printOut2dVector()
{
	cout.setf(ios::fixed);
	setprecision(4);
	for(int i = 0; i < dataMatrix_.size(); i++)
	{
		for( int j = 0; j < dataMatrix_[0].size(); j++)
		{
			cout<<dataMatrix_[i][j]<<" ";
		}
		cout<<endl;
	}

}

void LPPLHelper::printOut1dVector()
{
	cout.setf(ios::fixed);
	setprecision(4);
	for(int i = 0; i < dateTime_.size(); i++)
	{
		cout<<dateTime_[i]<<endl;		
	}

}

vector<double> LPPLHelper::get1DVectorFromDataMatrix(int iCol)
{
	QL_REQUIRE(iCol < dataMatrix_[0].size()," iCol starts at 0 and must be less than the numbers of columns of data matrix");
	vector<double> ret;
	for(int i = 0; i< dataMatrix_.size(); i++)
	{
		ret.push_back(dataMatrix_[i][iCol]);
	}
	return ret;
}


/************************** LPPL Calculator *******************************************/

Matrix LPPLCalculator::getLinearParamsFrom_Tc_M_Omega(double dM, int iTc, double dOmega)
{
	int iLens = vecDataForComputation.size();
	Matrix x(iLens, 4);
	Matrix y(iLens, 1);
	Matrix b(4, 1);

	for(int i = 0; i < iLens; i++)
	{
		x[i][0] = 1;
		x[i][1] = FormulaFt(dM, iTc, i);
		x[i][2] = FormulaGt(dM, iTc, dOmega,i);
		x[i][3] = FormulaHt(dM, iTc, dOmega,i);
		y[i][0] = log(vecDataForComputation[i]);
	}
	//std::cout<<x<<std::endl;
	return inverse(transpose(x) * x) * transpose(x) * y;
}

double LPPLCalculator::FormulaLPPL(double dM, int iTc, double dOmega, int iCurrentTi)
{
	Matrix matLinearParams = getLinearParamsFrom_Tc_M_Omega(dM,iTc,dOmega);
	double A = matLinearParams[0][0];
	double B = matLinearParams[0][1];
	double C1 = matLinearParams[0][2];
	double C2 = matLinearParams[0][3];

	return A + B * pow((iTc - iCurrentTi), dM) + C1 * pow((iTc -iCurrentTi ),dM)  * cos(dOmega * log((double)(iTc -iCurrentTi ))) + 
		  C2 * pow((iTc -iCurrentTi ), dM) * sin(dOmega * log((double)(iTc -iCurrentTi)));
}

double LPPLCalculator::FormulaLPPL(double A, double B, double C1, double C2, double dM, int iTc, double dOmega, int iCurrentTi)
{
	return A + B * pow((iTc - iCurrentTi), dM) + C1 * pow((iTc -iCurrentTi ),dM)  * cos(dOmega * log((double)(iTc -iCurrentTi ))) + 
		C2 * pow((iTc -iCurrentTi ), dM) * sin(dOmega * log((double)(iTc -iCurrentTi)));
}


double LPPLCalculator::sumSquaredErr(double dM, int iTc, double dOmega)
{
	Matrix matLinearParams = getLinearParamsFrom_Tc_M_Omega(dM,iTc,dOmega);
	double A = matLinearParams[0][0];
	double B = matLinearParams[0][1];
	double C1 = matLinearParams[0][2];
	double C2 = matLinearParams[0][3];

	double dSSE = 0.0;
	for(int i = 0; i < vecDataForComputation.size();i++)
	{
		dSSE += pow(log(vecDataForComputation[i])-FormulaLPPL(A, B, C1, C2, dM,iTc,dOmega,i),2);
	}
	return dSSE / vecDataForComputation.size();
}

double LPPLCalculator::getMedianFromVector(vector<double> vecTrustForEachDay)
{
	double dTrustMedian = 0.0;
	int iLens = 0;

	sort(vecTrustForEachDay.begin(), vecTrustForEachDay.end());
	iLens = vecTrustForEachDay.size();

	dTrustMedian = vecTrustForEachDay[(int)(iLens / 2)];

	return dTrustMedian;
}

Array LPPLCalculator::lpplCalibration()
{
	Array arrayOptimParams(7);
	double dM = 0.0;
	int iTc = 0;
	double dOmega = 0.0;
	double dFitness = 0.0;
	double dBenchMark = 10000.0;

	if (vecDataForComputation.size() == 0)
	{
		vecDataForComputation = vecData;
	}

	cout<<endl<<"LPPL Calibration in process...."<<endl;
	for(iTc = vecTcBound[0]*vecDataForComputation.size();iTc <= vecTcBound[1]*vecDataForComputation.size();iTc += iTcStepSize_)
	{
		for(dM = vecMBound[0]; dM <= vecMBound[1];dM += dMStepSize_)
		{
			for(dOmega = vecOmegaBound[0]; dOmega <= vecOmegaBound[1]; dOmega += dOmegaStepSize_)
			{
				dFitness = sumSquaredErr(dM, iTc,dOmega);
				if(dBenchMark > dFitness)
				{
					dBenchMark = dFitness;
					arrayOptimParams[3] = iTc;
					arrayOptimParams[4] = dM;
					arrayOptimParams[5] = dOmega;
				}
			}
		}
	}
	
	cout<<"LPPL Calibration finished...."<<endl<<endl;
	Matrix matLinearParams = getLinearParamsFrom_Tc_M_Omega(arrayOptimParams[4], arrayOptimParams[3], arrayOptimParams[5]);

	arrayOptimParams[0] = matLinearParams[0][0]; // A
	arrayOptimParams[1] = matLinearParams[0][1];  // B
	arrayOptimParams[2] = sqrt(pow(matLinearParams[0][2], 2) + pow(matLinearParams[0][3], 2));  //C
	arrayOptimParams[6] = atan(matLinearParams[0][3] / matLinearParams[0][2]);  //phi
	//arrayOptimParams_ = arrayOptimParams;
	return arrayOptimParams;
}

void LPPLCalculator::getResiduals(Array arrayOptimParams)
{
	double A = arrayOptimParams[0];
	double B = arrayOptimParams[1];
	double phi = arrayOptimParams[6];
	double C1 = arrayOptimParams[2] * cos(phi);
	double C2 = arrayOptimParams[2] * sin(phi);
	double Tc = arrayOptimParams[3];
	double m = arrayOptimParams[4];
	double Omega = arrayOptimParams[5];
	
	vecResiduals.clear();

	for(int i = 0; i < vecDataForTimeWindow.size(); i++)
	{
		vecResiduals.push_back(vecDataForTimeWindow[i] - exp(FormulaLPPL(A, B, C1, C2, m, Tc, Omega, i)));
	}
}

vector<double> LPPLCalculator::resampleDataVectorForComputation(Array arrayOptimParams, int iSeed = NULL)
{
	vector<double> vecResampleData;

	double A = arrayOptimParams[0];
	double B = arrayOptimParams[1];
	double phi = arrayOptimParams[6];
	double C1 = arrayOptimParams[2] * cos(phi);
	double C2 = arrayOptimParams[2] * sin(phi);
	double Tc = arrayOptimParams[3];
	double m = arrayOptimParams[4];
	double Omega = arrayOptimParams[5];

	if(iSeed = NULL)
	{
		srand(clock());
	}
	else
	{
		srand(iSeed);
	}
	
	random_shuffle(vecResiduals.begin(), vecResiduals.end());

	for(int i = 0; i < vecDataForTimeWindow.size(); i++)
	{
		vecResampleData.push_back(exp(FormulaLPPL(A, B, C1, C2, m, Tc, Omega, i)) + vecResiduals[i]);
	}

	return vecResampleData;
}

bool LPPLCalculator::lpplCalibrationFilter()
{
	bool bFlag = true;
	int iSampleSize = vecDataForTimeWindow.size();
	double dB = arrayOptimParams_[1];
	double dC = arrayOptimParams_[2];
	double dM = arrayOptimParams_[4];
	double dOmega = arrayOptimParams_[5];
	int iTc = arrayOptimParams_[3];
	double dDamping = dM * fabs(dB) / (dOmega * fabs(dC));
	vecDamping.push_back(dDamping);

	/* 0.01<m<1.2 */
	if(dM < 0.01 || dM > 1.2)
	{
		cout<<"m doesn't fit"<<endl;
		bFlag = false;
	}

	/* 2<omega<25 */
	if(dOmega < 2 || dOmega > 25)
	{
		cout<<"omega doesn't fit"<<endl;
		bFlag = false;
	}

	/* t2-0.05dt<tc<tc+0.01dt */
	if(iTc < iSampleSize * 0.95 || iTc > iSampleSize * 1.1)
	{
		cout<<"tc doesn't fit"<<endl;
		bFlag = false;
	}

	if(dDamping < 0.8 )
	{
		cout<<"Damping = "<<dDamping<<endl;
		cout<<"damping doesn't fit"<<endl;
		bFlag = false;
	}

	for(int i = 0; i < vecResiduals.size(); i++)
	{
		if(vecResiduals[i] / vecDataForComputation[i] > 0.05)
		{
			bFlag = false;
		}
	}

	return bFlag;
}

void LPPLCalculator::lpplConfidence()
{
	int iSampleSize = 0;
	int iSampleFit = 0;
	double dTotalTime = 0.0;
	double dConfidence = 0.0;
	/* Time Counting */
	clock_t cStart, cFinish, cLoopStart, cLoopEnd;

	cStart=clock();

	fstream fsResult("Result.txt", fstream::out);
	fstream fsConf("Confidence.txt", fstream::out);

	for(int k = iConfidenceTimeIntervalMax_; k <= vecData.size(); k += 1)
	{
		iSampleSize = 0;
		iSampleFit = 0;

		/* Fix T2, move T1 */
		for(int i = k - iConfidenceTimeIntervalMax_; i <= k - iConfidenceTimeIntervalMin_; i += 5)
		{

			cLoopStart = clock();

			resetDataVectorForComputation(vecData.begin() + i, vecData.begin() + k);

			std::cout<<"---------------------------------------------------------------"<<endl;
			std::cout<<"Loop "<<iSampleSize + 1<<":"<<endl;			
			std::cout<<"Start Date: "<<*(vecDateTime.begin() + i)<<"   End Date: "<<*(vecDateTime.begin() + k - 1)<<endl;
			std::cout<<"Input Days: "<<vecDataForTimeWindow.size()<<std::endl;
			std::cout<<"---------------------------------------------------------------"<<endl;
			fsResult<<"---------------------------------------------------------------"<<endl;
			fsResult<<"Loop "<<iSampleSize + 1<<":"<<endl;			
			fsResult<<"Start Date: "<<*(vecDateTime.begin() + i)<<"   End Date: "<<*(vecDateTime.begin() + k - 1)<<endl;
			fsResult<<"Input Days: "<<vecDataForTimeWindow.size()<<std::endl;
			fsResult<<"---------------------------------------------------------------"<<endl;

			/* Exhaustion Method */
			vecDataForComputation = vecDataForTimeWindow;
			arrayOptimParams_ = lpplCalibration();

			getResiduals(arrayOptimParams_);

			/* Filter the result */
			if(lpplCalibrationFilter())
			{
				iSampleFit += 1;
				cout<<"\nThis loop result fits!"<<endl;
				fsResult<<"\nThis loop result fits!"<<endl;
			}
			else
			{
				cout<<"\n此组解不符合过滤条件！"<<endl;
				fsResult<<"\n此组解不符合过滤条件！"<<endl;
			}

			iSampleSize += 1;

			/* Time Counting */
			cLoopEnd = clock();
			dTotalTime=(double)(cLoopEnd-cLoopStart)/CLOCKS_PER_SEC;

			//fsResult<<"Start date:"<<dataTime_[i]<<endl;			
			fsResult<<"A     :"<<arrayOptimParams_[0]<<endl;
			fsResult<<"B     :"<<arrayOptimParams_[1]<<endl;
			fsResult<<"C     :"<<arrayOptimParams_[2]<<endl;
			fsResult<<"tc    :"<<arrayOptimParams_[3]<<endl;
			fsResult<<"m     :"<<arrayOptimParams_[4]<<endl;
			fsResult<<"omega :"<<arrayOptimParams_[5]<<endl;
			fsResult<<"phi   :"<<arrayOptimParams_[6]<<"\n"<<endl;
			
			/* A B C tc m omega phi */
			cout<<arrayOptimParams_<<endl;
			cout<<"此循环的运行时间为"<<dTotalTime<<"秒！\n"<<endl;
		}

		if(arrayOptimParams_[1]>=0)
		{
			dConfidence=(double)iSampleFit / iSampleSize;
		}
		else
		{
			dConfidence = (double)iSampleFit / iSampleSize * 1;
		}
		vecConfidence.push_back(dConfidence);

		std::cout<<"Sample Size: "<<iSampleSize<<endl;
		std::cout<<"Sample Fit : "<<iSampleFit<<endl;
		std::cout<<"Confidence: "<<dConfidence<<"\n"<<endl;
		fsResult<<"Sample Size: "<<iSampleSize<<endl;
		fsResult<<"Sample Fit : "<<iSampleFit<<endl;
		fsResult<<"Confidence: "<<dConfidence<<"\n"<<endl;
		fsConf<<*(vecDateTime.begin() + k - 1)<<" "<<dConfidence<<endl;
	}
	fsResult.close();
	fsConf.close();
}


bool LPPLCalculator::lpplTrustFilter(Array arrayResampleOptimParams)
{
	bool bFlag = true;
	int iSampleSize = vecDataForComputation.size();
	double dB = arrayOptimParams_[1];
	double dC = arrayOptimParams_[2];
	double dM = arrayOptimParams_[4];
	double dOmega = arrayOptimParams_[5];
	int iTc = arrayOptimParams_[3];
	double dDamping = dM * fabs(dB) / (dOmega * fabs(dC));
	vecDamping.push_back(dDamping);

	/* 0.01<m<0.99 */
	if(dM < 0.01 || dM > 0.99)
	{
		cout<<"m = "<<dM<<" < 0.01"<< " or > 0.99"<<endl;
		cout<<"m doesn't fit"<<endl;
		bFlag = false;
	}

	/* 2<omega<25 */
	if(dOmega < 2 || dOmega > 25)
	{
		cout<<"Omega = "<<dOmega<<" < 2"<< " or > 5" <<endl;
		cout<<"Omega doesn't fit"<<endl;
		bFlag = false;
	}

	/* t2-0.05dt<tc<tc+0.01dt */
	if(iTc < iSampleSize * 0.95 || iTc > iSampleSize * 1.1)
	{
		cout<<"iTc = "<<iTc<<" < "<<iSampleSize * 0.95<< " or > " <<iSampleSize * 1.1<<endl;
		cout<<"Tc doesn't fit"<<endl;
		bFlag = false;
	}

	if(dDamping < 1 )
	{
		cout<<"Damping = "<<dDamping<<" < 1"<<endl;
		cout<<"Damping doesn't fit"<<endl;
		bFlag = false;
	}

	for(int i = 0; i < vecResiduals.size(); i++)
	{
		if(vecResiduals[i] / vecDataForComputation[i] > 0.20)
		{
			bFlag = false;
		}
	}

	return bFlag;
}
	

void LPPLCalculator::lpplTrust()
{
	int iSampleSize = 0;
	int iSampleFit = 0;
	int iLoopCount = 0;
	double dTotalTime = 0.0;
	double dTrustEachLoop = 0.0;
	double dTrustMedian = 0.0;
	Array arrayResampleOptimParams;

	/* Time Counting */
	clock_t cStart, cFinish, cLoopStart, cLoopEnd;
	cStart = clock();

	fstream fsResult("LPPL_Trust_Detail.txt", fstream::out);
	fstream fsTrust("LPPL_Trust_Result.txt", fstream::out);

	for(int i = iConfidenceTimeIntervalMax_; i <= vecData.size(); i += 1)
	{
		iLoopCount = 0;

		/* Fix T2, move T1 */
		for(int j = i - iConfidenceTimeIntervalMax_; j <= i - iConfidenceTimeIntervalMin_; j += 5)
		{
			iSampleSize = 0;
			iSampleFit = 0;

			resetDataVectorForComputation(vecData.begin() + j, vecData.begin() + i);

			std::cout<<"---------------------------------------------------------------"<<endl;
			std::cout<<"Time Window "<<++iLoopCount<<":"<<endl;			
			std::cout<<"Start Date: "<<*(vecDateTime.begin() + j)<<"   End Date: "<<*(vecDateTime.begin() + i - 1)<<endl;
			std::cout<<"Input Days: "<<vecDataForTimeWindow.size()<<std::endl;
			std::cout<<"---------------------------------------------------------------"<<endl;
			fsResult<<"---------------------------------------------------------------"<<endl;
			fsResult<<"Time Window "<<iLoopCount<<":"<<endl;			
			fsResult<<"Start Date: "<<*(vecDateTime.begin() + j)<<"   End Date: "<<*(vecDateTime.begin() + i - 1)<<endl;
			fsResult<<"Input Days: "<<vecDataForTimeWindow.size()<<std::endl;
			fsResult<<"---------------------------------------------------------------"<<endl;

			/* Exhaustion Method 根据对应时间的起点和终点拟合一条LPPL曲线 */
			vecDataForComputation = vecDataForTimeWindow;
			arrayOptimParams_ = lpplCalibration();


			cout<<"Start Re-sample 100 Times!"<<endl;
			/* Re-sample 100 Times */
			for(int k = 0; k < iResampleTimes_; k++)
			{
				cLoopStart = clock();

				cout<<"-------------------------------------------------------"<<endl;
				cout<<"Loop "<<k + 1<<endl;

				fsResult<<"-------------------------------------------------------"<<endl;
				fsResult<<"Loop "<<k + 1<<endl;

				getResiduals(arrayOptimParams_);
				vecDataForComputation = resampleDataVectorForComputation(arrayOptimParams_, iSeed_);
				arrayResampleOptimParams = lpplCalibration();

				if(lpplTrustFilter(arrayResampleOptimParams))
				{
					iSampleFit += 1;
					cout<<"\nThis re-sample data fits!"<<endl;
					fsResult<<"\nThis re-sample data fits!"<<endl;
				}
				else
				{
					cout<<"\n此组解不符合过滤条件！"<<endl;
					fsResult<<"\n此组解不符合过滤条件！"<<endl;
				}
				iSampleSize += 1;

				/* Time Counting */
				cLoopEnd = clock();
				dTotalTime=(double)(cLoopEnd-cLoopStart)/CLOCKS_PER_SEC;

				/* A B C tc m omega phi */
				cout<<arrayResampleOptimParams<<endl;
				cout<<"This loop costs "<<dTotalTime<<" seconds!\n"<<endl;

				fsResult<<arrayResampleOptimParams<<endl;
			}

			if(arrayOptimParams_[1] >= 0)
			{
				dTrustEachLoop = (double)iSampleFit / iSampleSize * -1;
			}
			else
			{
				dTrustEachLoop = (double)iSampleFit / iSampleSize;
			}
			vecTrustEachDay.push_back(dTrustEachLoop);
			cout<<"Thrust "<<dTrustEachLoop<<endl;
		}

		// sort vecTrustForEachDay 
		dTrustMedian = getMedianFromVector(vecTrustEachDay);
		vecTrust.push_back(dTrustMedian);

		cout<<"-------------------------------------------------------"<<endl;
		cout<<"Day:   "<<*(vecDateTime.begin() + i - 1)<<endl;
		cout<<"Trust: "<<dTrustMedian<<endl;

		fsTrust<<*(vecDateTime.begin() + i - 1)<<" "<<dTrustMedian<<endl;
	}
	fsResult.close();
	fsTrust.close();
}