#include <cstdlib>
#include <cstring>
#include "Aladdin\xll\oper.h"

//void print_char_array(char* array[], int iNbRow);

int **imatrix(int nrows, int ncolumns);
double **dmatrix(int nrows, int ncolumns);
double* dvector(int nrows);
void free_dvector(double* dInputVector);
char **cvector(int nrows, int ncolumns);
int count_occur(int a[], char exists[], int num_elements, int value);
int is_element_in_the_array(char* a[],int iNumElement, char* cValue);
char** get_unique_element_list(char* input_array[], int iInputNumElement, int* iOutputNumElement);

int  ExcelStr2CStr(const LPSTR  lpInStr, char* pcOutStr, const int cnOutBufLen );
void get_range_values(OPERX oRange, char*** vCellValues, int* iOutputSize);
void convert_char_to_opex(OPERX* range, char** cInputVector, int iCharVectorSize);
void convert_opex_to_dvector(OPERX oRange, double** dInputVector, int iVectorSize);
void convert_dvector_to_opex(OPERX* range, double* dInputVector, int iVectorSize);


