//
// File: main.cu
//
// MATLAB Coder version            : 4.1
// C/C++ source code generated on  : 20-Mar-2019 09:35:20
//

//***********************************************************************
// This is a modified main file created from the automatically generated 
// main.cu file.
//***********************************************************************
// Include Files
#include "rt_nonfinite.h"
#include "alexnet_predict.h"
#include "main.h"
#include "alexnet_predict_terminate.h"
#include "alexnet_predict_emxAPI.h"
#include "alexnet_predict_initialize.h"
#include <iostream>
#include <string.h>

using namespace std;

// Function Definitions

static emxArray_char_T *argInit_1xUnbounded_char_T(const char * file)
{
  emxArray_char_T *result;
  int32_T nameSize;
  // Set the size of the array.
  // Change this size to the value that the application requires.
  nameSize = strlen(file)+1;
  cout << nameSize << flush;
  result = emxCreate_char_T(1, nameSize);

  strcpy(result->data,file);

  return result;
}

static void main_alexnet_predict(emxArray_char_T *filename, char_T* out_data)
{
  int32_T out_size[2];
 
  // Call the entry-point 'alexnet_predict'.
  alexnet_predict(filename, out_data, out_size);
  emxDestroyArray_char_T(filename);
}

//
// Arguments    : int32_T argc
//                const char * const argv[]

// Return Type  : int32_T
//
int32_T main(int32_T argc, const char * argv[])
{
  char_T result[10473];
  emxArray_char_T *file;

  // Initialize the application.
  alexnet_predict_initialize();

  // convert string filename input to 'emxArray_char_T' type  
  file = argInit_1xUnbounded_char_T(argv[1]);

  // Invoke the entry-point functions.
  main_alexnet_predict(file,result);
  cout << result;

  // Terminate the application.
  alexnet_predict_terminate();
  return 0;
}

// [EOF]
//
