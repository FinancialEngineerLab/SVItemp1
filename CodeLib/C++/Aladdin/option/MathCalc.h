
int isConsecutiveTrend(double* dInputVector, int iSize, int iPosOrNeg);

double random_uniform_0_1(void);
double random_std_normal(void);
double rand_normal(double mean, double stddev);
double sim_lognorm_var(double s, double r, double sigma, double time);

double find_max_then_replace(double dMax, double dCurrent);
double find_min_then_replace(double dMin, double dCurrent);
double* diff_series(double* dInputVector, int iSize);
double find_max_drawdown(double* dInputVector, int iSize,int iIsReturn, int iMode);

double cap_on_value(double dCap, double dValue);
double floor_on_value(double dFloor, double dValue);