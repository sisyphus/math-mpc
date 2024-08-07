
#ifdef  __MINGW32__
#ifndef __USE_MINGW_ANSI_STDIO
#define __USE_MINGW_ANSI_STDIO 1
#endif
#endif

#define PERL_NO_GET_CONTEXT 1

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <mpc.h>

/* Provide a duplicate of Math::MPC::_has_pv_nv_bug. *
 * This allows MPC.pm to determine the value of      *
 * the constant MPC_PV_NV_BUG at compile time.       */

int _has_pv_nv_bug(void) {
#if defined(MPC_PV_NV_BUG)
     return 1;
#else
     return 0;
#endif
}

int _is_NOK_and_POK(SV * in) {
  if(SvNOK(in) && SvPOK(in)) return 1;
  return 0;
}

/* Allow MPC.pm to determine the version of *
 * the mpc library (as specified by mpc.h)  *
 * at compile time.                         */

SV * _mpc_header_version(pTHX) {
  return newSVuv(MPC_VERSION);
}

SV * _mpc_header_version_str(pTHX) {
  return newSVpv(MPC_VERSION_STRING, 0);
}


MODULE = Math::MPC::Constant  PACKAGE = Math::MPC::Constant

PROTOTYPES: DISABLE


int
_has_pv_nv_bug ()


int
_is_NOK_and_POK (in)
	SV *	in

SV *
_mpc_header_version ()
CODE:
  RETVAL = _mpc_header_version (aTHX);
OUTPUT:  RETVAL


SV *
_mpc_header_version_str ()
CODE:
  RETVAL = _mpc_header_version_str (aTHX);
OUTPUT:  RETVAL


