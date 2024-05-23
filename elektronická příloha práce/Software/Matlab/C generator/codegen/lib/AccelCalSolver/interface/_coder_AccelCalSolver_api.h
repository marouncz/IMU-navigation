/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_AccelCalSolver_api.h
 *
 * MATLAB Coder version            : 23.2
 * C/C++ source code generated on  : 21-Apr-2024 17:12:30
 */

#ifndef _CODER_ACCELCALSOLVER_API_H
#define _CODER_ACCELCALSOLVER_API_H

/* Include Files */
#include "emlrt.h"
#include "mex.h"
#include "tmwtypes.h"
#include <string.h>

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void AccelCalSolver(real_T accel[18], real_T gravityScalar, real_T x[6],
                    real_T fval[6]);

void AccelCalSolver_api(const mxArray *const prhs[2], int32_T nlhs,
                        const mxArray *plhs[2]);

void AccelCalSolver_atexit(void);

void AccelCalSolver_initialize(void);

void AccelCalSolver_terminate(void);

void AccelCalSolver_xil_shutdown(void);

void AccelCalSolver_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for _coder_AccelCalSolver_api.h
 *
 * [EOF]
 */
