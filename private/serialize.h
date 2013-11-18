/* Hidden mex API.
 */
#include "matrix.h"
mxArray* mxSerialize(const mxArray* arr);
mxArray* mxDeserialize(const void* data, size_t size);