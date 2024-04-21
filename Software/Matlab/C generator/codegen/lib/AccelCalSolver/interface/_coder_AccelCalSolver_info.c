/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: _coder_AccelCalSolver_info.c
 *
 * MATLAB Coder version            : 23.2
 * C/C++ source code generated on  : 21-Apr-2024 17:12:30
 */

/* Include Files */
#include "_coder_AccelCalSolver_info.h"
#include "emlrt.h"
#include "tmwtypes.h"

/* Function Declarations */
static const mxArray *c_emlrtMexFcnResolvedFunctionsI(void);

/* Function Definitions */
/*
 * Arguments    : void
 * Return Type  : const mxArray *
 */
static const mxArray *c_emlrtMexFcnResolvedFunctionsI(void)
{
  const mxArray *nameCaptureInfo;
  const char_T *data[4] = {
      "789cc593cd4ec2401485a70689314159b966e54e12b7ee4c8504132a498b1bc7e0508652"
      "3b3fcd748aa0cf605cb8f4455cfa1cae7c1113694b29259994848077"
      "737bfa75e6ccb96d81d66a6b00802390d46739e995b9aecefb1ec8d72ad7143dad7d50ca"
      "ad4bf9dbbcdb9c493c91896088e2c5ca01a72e434c5a531f0381034e",
      "c6781093a14bb0e5526c2e0b2352b4b984162242d1b53ec2b66786148851909d902c8bc5"
      "3c7e14794b6bcee345318fea0abf6bdceb17b01b6011408a040f6147"
      "f047ecc9296c2381bd9acec32122b0d5ee9e3134761d245dcea0c987f269c6670f4982fa"
      "50af399861812417f0d2b631d11131a389893ad5f2377a8871d6b4d9",
      "792eafbf61dec382bc2977c42c849c36430672fe0f1bfa9795fe0919f0b04f70e6f7b5a1"
      "5f4fe997e75b78bfd908ebb4707ec76be651fdbf157010f7dff7ef18"
      "edcaef233c7ddda55f5affe53751ecb7eef778a2f0abaef0aeedd1ab566019b6e1f837c6"
      "b375cbaffd46768e4e814fd13980426f7bff3f4c0c969d",
      ""};
  nameCaptureInfo = NULL;
  emlrtNameCaptureMxArrayR2016a(&data[0], 1744U, &nameCaptureInfo);
  return nameCaptureInfo;
}

/*
 * Arguments    : void
 * Return Type  : mxArray *
 */
mxArray *emlrtMexFcnProperties(void)
{
  mxArray *xEntryPoints;
  mxArray *xInputs;
  mxArray *xResult;
  const char_T *propFieldName[9] = {"Version",
                                    "ResolvedFunctions",
                                    "Checksum",
                                    "EntryPoints",
                                    "CoverageInfo",
                                    "IsPolymorphic",
                                    "PropertyList",
                                    "UUID",
                                    "ClassEntryPointIsHandle"};
  const char_T *epFieldName[8] = {
      "Name",     "NumberOfInputs", "NumberOfOutputs", "ConstantInputs",
      "FullPath", "TimeStamp",      "Constructor",     "Visible"};
  xEntryPoints =
      emlrtCreateStructMatrix(1, 1, 8, (const char_T **)&epFieldName[0]);
  xInputs = emlrtCreateLogicalMatrix(1, 2);
  emlrtSetField(xEntryPoints, 0, "Name", emlrtMxCreateString("AccelCalSolver"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs",
                emlrtMxCreateDoubleScalar(2.0));
  emlrtSetField(xEntryPoints, 0, "NumberOfOutputs",
                emlrtMxCreateDoubleScalar(2.0));
  emlrtSetField(xEntryPoints, 0, "ConstantInputs", xInputs);
  emlrtSetField(
      xEntryPoints, 0, "FullPath",
      emlrtMxCreateString("C:\\Users\\marou\\Projekty\\Marek "
                          "Coufal\\IMU-navigation\\Software\\Matlab\\C "
                          "generator\\AccelCalSolver.m"));
  emlrtSetField(xEntryPoints, 0, "TimeStamp",
                emlrtMxCreateDoubleScalar(739363.71230324078));
  emlrtSetField(xEntryPoints, 0, "Constructor",
                emlrtMxCreateLogicalScalar(false));
  emlrtSetField(xEntryPoints, 0, "Visible", emlrtMxCreateLogicalScalar(true));
  xResult =
      emlrtCreateStructMatrix(1, 1, 9, (const char_T **)&propFieldName[0]);
  emlrtSetField(xResult, 0, "Version",
                emlrtMxCreateString("23.2.0.2515942 (R2023b) Update 7"));
  emlrtSetField(xResult, 0, "ResolvedFunctions",
                (mxArray *)c_emlrtMexFcnResolvedFunctionsI());
  emlrtSetField(xResult, 0, "Checksum",
                emlrtMxCreateString("sNUXMcqxXy8ntosg6ftKUG"));
  emlrtSetField(xResult, 0, "EntryPoints", xEntryPoints);
  return xResult;
}

/*
 * File trailer for _coder_AccelCalSolver_info.c
 *
 * [EOF]
 */
