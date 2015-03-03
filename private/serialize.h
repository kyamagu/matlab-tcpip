/* Hidden mex API.
 *
 */
#include "mex.h"

/* MX_API_VER has unfortunately not changed between R2013b and R2014a,
 * so we use the new MATRIX_DLL_EXPORT_SYM as an ugly hack instead
 */
#if defined(__cplusplus) && defined(MATRIX_DLL_EXPORT_SYM)
  #define EXTERN_C extern
  namespace matrix{
    namespace detail{
      namespace noninlined{
        namespace mx_array_api{
#endif

EXTERN_C mxArray* mxSerialize(mxArray const *);
EXTERN_C mxArray* mxDeserialize(const void *, size_t);

#if defined(__cplusplus) && defined(MATRIX_DLL_EXPORT_SYM)
        }
      }
    }
  }
  using namespace matrix::detail::noninlined::mx_array_api;
#endif
