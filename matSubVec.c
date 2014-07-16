#include "mex.h"
#include "matrix.h"


/*
 * Function to subtract a vector from a matrix without having to use
 * repmat.  Both have to be real for now.  Aligns the vector by
 * whichever dimension of tha matrix matches.  If both dimensions of
 * the matrix match, uses the current orientation of the vector.
 *
 * Copyright (C) 2005 Michael Mandel, mim at ee columbia edu;
 * distributable under GPL
 */

void doMath(int mM, int mN, int vM, int vN, 
	    double* mData, double* vData, double*rData);

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  if(nlhs > 1)
    mexErrMsgTxt("Requires at most 1 output argument.");
  if(nrhs != 2)
    mexErrMsgTxt("Requires 2 input arguments.");

  const mxArray *mat = prhs[0];
  const mxArray *vec = prhs[1];

  int mM = mxGetM(mat), mN = mxGetN(mat);
  int vM = mxGetM(vec), vN = mxGetN(vec);

  if(mM != vM && mM != vN && mN != vM && mN != vN)
    mexErrMsgTxt("Matrix not compatible with vector");

  /* Make return argument */
  mxArray *res;
  if(mxIsComplex(mat) || mxIsComplex(vec))
    res = mxCreateDoubleMatrix(mM, mN, mxCOMPLEX);
  else
    res = mxCreateDoubleMatrix(mM, mN, mxREAL);    
  plhs[0] = res;

  /* Always do real parts */
  doMath(mM,mN,vM,vN,mxGetPr(mat),mxGetPr(vec),mxGetPr(res));

  /* Figure out whether to do imaginary parts */
  if(mxIsComplex(mat) && !mxIsComplex(vec)) {
    /* Matrix complex, vector real, copy the matrix over to result */
    int i;
    double* mData = mxGetPi(mat);
    double* rData = mxGetPi(res);
    for(i = 0; i<mM*mN; i++)
      rData[i] = mData[i];
  } else if(mxIsComplex(vec) && !mxIsComplex(mat)) {
    /* Res is initialized to all 0s, right?  Matrix real, vector
       complex.  Subtract vector from a matrix of all zeros, i.e. the
       imaginary part of the result matrix. */
    doMath(mM,mN,vM,vN,mxGetPi(res),mxGetPi(vec),mxGetPi(res));
  } else if(mxIsComplex(res)) {
    /* Both matrix and vector are complex, easy to handle. */
    doMath(mM,mN,vM,vN,mxGetPi(mat),mxGetPi(vec),mxGetPi(res));
  }
}

void doMath(int mM, int mN, int vM, int vN, 
	    double* mData, double* vData, double*rData)
{
  int i,j;
  if(mM == mN) {
    /* Special case for square matrices */
    if(vM < vN) {
      /* row vector */
      for(j = 0; j < mN; j++)
	for(i = 0; i < mM; i++)
	  rData[i + j*mM] = mData[i + j*mM] - vData[j];
    } else {
      /* column vector */
      for(j = 0; j < mN; j++)
	for(i = 0; i < mM; i++)
	  rData[i + j*mM] = mData[i + j*mM] - vData[i];
    }
  } else {
    if(mM == vM || mM == vN) {
      /* Vector matches columns */
      for(j = 0; j < mN; j++)
	for(i = 0; i < mM; i++)
	  rData[i + j*mM] = mData[i + j*mM] - vData[i];
    } else {
      /* Vector matches rows */
      for(j = 0; j < mN; j++)
	for(i = 0; i < mM; i++)
	  rData[i + j*mM] = mData[i + j*mM] - vData[j];
    }
  }
}
