#include "GeneralUtility.h"


#define SMALL_STRING_LEN 500

/*
void print_char_array(char* array[], int iNbRow)
{
	int i,j;

	for(i = 0;i < iNbRow; i++)
	{
		cout<<array[i]<<" "<<endl;	
	}

	cout<<endl;
}
*/

int **imatrix(int nrows, int ncolumns)
/* create a 2d dynamic allocated int array */
{

	int i;

	int **array = (int **)malloc(nrows * sizeof(int *));

	for(i = 0; i < nrows; i++)
	{

		array[i] = (int *)malloc(ncolumns * sizeof(int));
	}

	return array;

}

double **dmatrix(int nrows, int ncolumns)
{
	int i;

	double **array = (double **)malloc(nrows * sizeof(double *));

	for(i = 0; i < nrows; i++)
	{

		array[i] = (double *)malloc(ncolumns * sizeof(double));
	}

	return array;
}


double* dvector(int nrows)
{
	double* dVector = NULL;
	dVector = (double*) malloc( nrows * sizeof(double));
	return dVector;
}

void free_dvector(double* dInputVector)
{
	if(dInputVector)
	{
		free(dInputVector);//free memeory
	}

}

char **cvector(int nrows, int ncolumns)
/* create a 2d dynamic allocated char array */
{

	int i;

	char **array = (char **)malloc(nrows * sizeof(char *));

	for(i = 0; i < nrows; i++)
	{

		array[i] = (char *)malloc(ncolumns * sizeof(char));
	}

	return array;

}

void free_cvector(char** cInputVector, int nrows, int ncolumns)
{
	if(cInputVector)
	{
		for( int i = 0; i < ncolumns; i++)
		{
			free(cInputVector[i]);
		}
		free(cInputVector);
	}
}

void cvector_resize(char*** cInputVector,int iCurrentRow, int iNewRow)
{
	int iSize = 0;
	iSize = iNewRow - iCurrentRow;
	(*cInputVector) = (char**) realloc((*cInputVector),iNewRow*sizeof(char*));
	for( int i =0; i < iSize; i++)
	{
		(*cInputVector)[iCurrentRow + i] = (char *)malloc(SMALL_STRING_LEN * sizeof(char));
	}
	
	
}



int count_occur(int a[], char exists[], int num_elements, int value)
/* checks array a for number of occurrances of value */
{
    int i, count = 0;

    for (i = 0; i < num_elements; i++)
    {
        if (a[i] == value)
        {
            if (exists[i] != 0) return 0;
            ++count; /* it was found */
        }
    }
    return (count);
}

int is_element_in_the_array(char* a[],int iNumElement, char* cValue)
/* checks if the value is in the array */
{
	int i = 0;
	for( i ; i< iNumElement; i++)
	{
		if((a[i]!=NULL)&& !strcmp(a[i], cValue))
		{
			return 1;
		}
	}
	return 0;
}


char** get_unique_element_list(char* input_array[], int iInputNumElement, int* iOutputNumElement)
{
	char** output_array = NULL;
	int i = 0;
	int size_output_array = 0;
	
	output_array = cvector(1,SMALL_STRING_LEN);
	
	for(i; i < iInputNumElement; i++)
	{
		if(!is_element_in_the_array(output_array,size_output_array, input_array[i]))
		{
			size_output_array++;			
			if(size_output_array >1)
			{
				output_array = (char**) realloc(output_array, 	size_output_array*sizeof(char*));
				output_array[size_output_array - 1] = (char *)malloc(SMALL_STRING_LEN * sizeof(char));
				strcpy(output_array[size_output_array - 1], input_array[i]);
			}
			else
			{
				strcpy(output_array[size_output_array - 1], input_array[i]);
			}
		}
	}

	(*iOutputNumElement) = size_output_array;

	return output_array;
}



//----------------------------------------------------------------------
/* This function  extracts the meaingful part of a Pascal-style STRING value that is being returned by Excel API.
   The first BYTE stores the total characters in the string; then follows those characters(actual string), 
   followed by what seems like Excel garbage! 

*/
int  ExcelStr2CStr(const LPSTR  lpInStr, char* pcOutStr, const int cnOutBufLen )
{
    const int cnLen = lpInStr[0]; // get the length sotred in the first byte..(a Pascal-style String?)
    memset(pcOutStr, cnOutBufLen, '\0');
    int i=0;

    for ( i=1; i <= cnLen ; i++) // extract c-string out of Pascal-style String..
    {
        pcOutStr[i-1] = lpInStr[i];
    }
// null-terminate string to make it cmopatible with all string processing functions/requirements
    pcOutStr[i-1] ='\0'; 
    return i-1; // since we started counting at index 1, and not 0.
}

//----------------------------------------------------------------------
/* This function takes as input- an Excel CellRange(e.g. A2:A10), reads the values stored in each cell(in Pascal string format, I believe)
 and then, extracts the actual string content(for each ecll), and returns it in the 2nd input parame(vCellValues).
 It returns the number of strings extracted

 */

void get_range_values(OPERX oRange, char*** vCellValues, int* iOutputSize)
{
    static char buf[SMALL_STRING_LEN] ;
    int nStrLen = 0;
	int iSize = 0 ;
    (*vCellValues) = NULL ; // empty vector of current contents
      
	(*vCellValues) = cvector(1,SMALL_STRING_LEN);
      // SINGLE cell , and not a range. Therefore, it will hold a string value in the .str 
    if (oRange.xltype== xltypeStr) 
    {
        nStrLen = ExcelStr2CStr(oRange.val.str, buf, SMALL_STRING_LEN); // extract the actual value out of the "Pascal-style String"    
		strcpy((*vCellValues)[0], buf);
		iSize = 1;
    }
    else  // (if range such as A2: A5)
    {
        for (int i=0; i < (oRange.val.array.rows * oRange.val.array.columns); i++  )// iterate thru all rows in this columns(am unable to get the HTML escape sequence for '+', so apologies for the#43 bit in the for-loop
        {
                       // extract c-style string from pascal-style str returned by Excel
            ExcelStr2CStr(oRange.val.array.lparray[i].val.str, buf, SMALL_STRING_LEN); 
            iSize += 1;
			if( i >0)
			{
				cvector_resize(vCellValues,iSize-1,iSize);
			}
		
			strcpy((*vCellValues)[i], buf);
        }
    }

    (*iOutputSize) = iSize;
}


void convert_char_to_opex(OPERX* range, char** cInputVector, int iCharVectorSize)
{
	(*range).resize(iCharVectorSize,1);
	for(int i = 0; i < iCharVectorSize; i++)
	{
		(*range)(i,0) = cInputVector[i] ;
	}

}

void convert_opex_to_dvector(OPERX oRange, double** dInputVector, int iVectorSize)
{
	(*dInputVector) = dvector(iVectorSize);
	for(int i=0; i < iVectorSize; i++)
	{
		(*dInputVector)[i] = oRange(i,0);
	}
}

void convert_dvector_to_opex(OPERX* range, double* dInputVector, int iVectorSize)
{
	(*range).resize(iVectorSize,1);
	for(int i = 0; i < iVectorSize; i++)
	{
		(*range)(i,0) = dInputVector[i] ;
	}

}



