#include <ql/quantlib.hpp>
#include <vector>
using namespace QuantLib;
using namespace std;

class LPPLHelper
{
public:
	LPPLHelper(string strDataFilePath, int iNbCols = 1, int iSkipCols = 0):strDataFilePath_(strDataFilePath), iSkipCols_(iSkipCols),
		iNbCols_(iNbCols)
	{
		QL_REQUIRE(iNbCols_ >= 1.0, "Number of columns of data must be bigger than 1");
		QL_REQUIRE(iSkipCols >= 1.0, "Number of skipped columns of data must be bigger than 1");
	}

	void readDataFromTxt();
	void printOut2dVector();
	void printOut1dVector();
	vector<vector<double> > get2DVectorDataMatrix(){return dataMatrix_;};
	vector<double> get1DVectorFromDataMatrix(int iCol);
	vector<string> getDatetime(){return dateTime_;};

private:
	string strDataFilePath_;
	vector<vector<double> > dataMatrix_;
	vector<string > dateTime_;
	int iSkipCols_; // 初始若干列数据可以忽略  
	int iNbRows_;
	int iNbCols_;

};


class LPPLCalculator
{
public:
	LPPLCalculator(double dMLowerBound, 
		double dMUpBound,
		double dMStepSize, 
		double dTcLowerBound, 
		double dTcUpBound, 
		int iTcStepSize,
		double dOmegaLowerBound, 
		double dOmegaUpBound, 
		double dOmegaStepSize,
		std::vector<double> dataSeries,
		std::vector<string> dateTime,
		int iConfidenceTimeIntervalMin = 50,
		int iConfidenceTimeIntervalMax = 100,
		int iResampleTimes = 100,
		int iSeed = NULL ):dMStepSize_(dMStepSize), iTcStepSize_(iTcStepSize), dOmegaStepSize_(dOmegaStepSize),
		vecData(dataSeries), vecDateTime(dateTime), 
		iConfidenceTimeIntervalMin_(iConfidenceTimeIntervalMin),
		iConfidenceTimeIntervalMax_(iConfidenceTimeIntervalMax),
		iResampleTimes_(iResampleTimes), iSeed_(iSeed)
	{
		vecMBound.push_back(dMLowerBound);
		vecMBound.push_back(dMUpBound);

		vecTcBound.push_back(dTcLowerBound);
		vecTcBound.push_back(dTcUpBound);

		vecOmegaBound.push_back(dOmegaLowerBound);
		vecOmegaBound.push_back(dOmegaUpBound);

	}

	Matrix getLinearParamsFrom_Tc_M_Omega(double dM, int iTc, double dOmega);

	double FormulaLPPL(double dM, int iTc, double dOmega, int iCurrentTi);

	double FormulaLPPL(double A, double B, double C1, double C2, double dM, int iTc, double dOmega, int iCurrentTi);

	double FormulaFt(double dM, int iTc, int iCurrentTi)
	{
		return pow((iTc - iCurrentTi),dM);
	}

	double FormulaGt(double dM, int iTc, double dOmega, int iCurrentTi)
	{
		return FormulaFt(dM, iTc, iCurrentTi) * cos(dOmega * log((double)(iTc- iCurrentTi)));
	}

	double FormulaHt(double dM, int iTc, double dOmega, int iCurrentTi)
	{
		return FormulaFt(dM, iTc, iCurrentTi) * sin(dOmega * log((double)(iTc- iCurrentTi)));
	}

	double sumSquaredErr(double dM, int iTc, double dOmega);
	
	Array lpplCalibration();

	bool lpplCalibrationFilter();

	void resetDataVectorForComputation(vector<double>::iterator itBegin,vector<double>::iterator itEnd)
	{ 
		vecDataForTimeWindow.clear();
		vecDataForTimeWindow.insert(vecDataForTimeWindow.begin(), itBegin, itEnd);
	};

	void lpplConfidence();

	Array getOptimParams(){return arrayOptimParams_;}

	vector<double> getDampingVal(){return vecDamping;}

	vector<double> getConfidence(){return vecConfidence;}

	/* --------------------------------------LPPL Trust------------------------------------------- */
	void getResiduals(Array arrayOptimParams);

	vector<double> resampleDataVectorForComputation(Array arrayOptimParams, int iSeed);

	void lpplTrust();

	bool lpplTrustFilter(Array arrayResampleOptimParams);

	void setArrayOptimParams(Array arrayOptimParams){arrayOptimParams_ = arrayOptimParams;};

	double getMedianFromVector(vector<double> vecTrustForEachDay);

	vector<double> getTrust() {return vecTrust;};

private:
	Array       arrayOptimParams_; // A, B, C, Tc,m,Omega, phi
	double         dMStepSize_;
	int			   iTcStepSize_;
	double         dOmegaStepSize_;
	vector<double> vecDamping;
	vector<double> vecConfidence;
	vector<double> vecMBound;
	vector<double> vecTcBound;
	vector<double> vecOmegaBound;
	vector<double> vecData;  // 原始数据
	vector<double> vecDataForTimeWindow;  // 时间窗口对应的数据 
	vector<string> vecDateTime;
	int iConfidenceTimeIntervalMin_;
	int iConfidenceTimeIntervalMax_;
	int iResampleTimes_;
	int iSeed_;

	/* --------------------------------------LPPL Trust------------------------------------------- */
	vector<double> vecResiduals;             // 残差序列
	vector<double> vecDataForComputation;    // 用于拟合的数据
	vector<double> vecTrustEachDay;
	vector<double> vecTrust;
};



