/* Deserialize mxArray into byte stream using hidden mex API
 */
#include "serialize.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  if (nrhs != 1)
      mexErrMsgIdAndTxt("deserialize:invalidArg",
                        "Wrong number of arguments: %d for 1.", nrhs);
  if (nlhs > 1)
      mexErrMsgIdAndTxt("deserialize:invalidArg",
                        "Too many outputs: %d for 1.", nlhs);
  if (!mxIsInt8(prhs[0]) && !mxIsUint8(prhs[0]))
      mexErrMsgIdAndTxt("deserialize:invalidArg",
                        "Input must be a UINT8 array.");
  plhs[0] = (mxArray*)mxDeserialize(mxGetData(prhs[0]),
                                    mxGetNumberOfElements(prhs[0]));
}
