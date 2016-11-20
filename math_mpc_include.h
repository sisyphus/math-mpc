
#include <stdio.h>

#ifndef _MSC_VER
#include <inttypes.h>
#include <limits.h>
#ifdef _DO_COMPLEX_H
#include <complex.h>
#endif
#endif

#if defined(MPFR_WANT_FLOAT128) || defined(NV_IS_FLOAT128)
#include <quadmath.h>
#if defined(NV_IS_FLOAT128) && defined(MPFR_WANT_FLOAT128) && defined(MPFR_VERSION) && MPFR_VERSION >= MPFR_VERSION_NUM(4,0,0)
#define CAN_PASS_FLOAT128
#endif
#if defined(__MINGW32__) && !defined(__MINGW64__)
typedef __float128 float128 __attribute__ ((aligned(32)));
#elif defined(__MINGW64__) || (defined(DEBUGGING) && defined(NV_IS_DOUBLE))
typedef __float128 float128 __attribute__ ((aligned(8)));
#else
typedef __float128 float128;
#endif
#endif

#include <gmp.h>
#include <mpfr.h>
#include <mpc.h>

#include <float.h>

#if LDBL_MANT_DIG == 106
#define REQUIRED_LDBL_MANT_DIG 2098
#else
#define REQUIRED_LDBL_MANT_DIG LDBL_MANT_DIG
#endif

#ifndef _MPC_H_HAVE_COMPLEX
#ifndef _Complex_I
#undef _DO_COMPLEX_H
#endif
#endif

#ifdef _MSC_VER
#pragma warning(disable:4700 4715 4716)
#define intmax_t __int64
#endif

#ifdef OLDPERL
#define SvUOK SvIsUV
#endif

#ifndef Newx
#  define Newx(v,n,t) New(0,v,n,t)
#endif

#ifndef Newxz
#  define Newxz(v,n,t) Newz(0,v,n,t)
#endif

#if MPC_VERSION_MAJOR > 0 || MPC_VERSION_MINOR > 8
#define SIN_COS_AVAILABLE 1
#endif

#define MPC_RE(x) ((x)->re)
#define MPC_IM(x) ((x)->im)

#define VOID_MPC_SET_X_Y(real_t, imag_t, z, real_value, imag_value, rnd)     \
   {                                                                     \
     int _inex_re, _inex_im;                                             \
     _inex_re = (mpfr_set_ ## real_t) (MPC_RE (z), (real_value), MPC_RND_RE (rnd)); \
     _inex_im = (mpfr_set_ ## imag_t) (MPC_IM (z), (imag_value), MPC_RND_IM (rnd)); \
   }

#define SV_MPC_SET_X_Y(real_t, imag_t, z, real_value, imag_value, rnd)     \
  {                                                                     \
    int _inex_re, _inex_im;                                             \
    _inex_re = (mpfr_set_ ## real_t) (mpc_realref (z), (real_value), MPC_RND_RE (rnd)); \
    _inex_im = (mpfr_set_ ## imag_t) (mpc_imagref (z), (imag_value), MPC_RND_IM (rnd)); \
    return newSViv(MPC_INEX (_inex_re, _inex_im));                               \
  }

