
#ifdef  __MINGW32__
#ifndef __USE_MINGW_ANSI_STDIO
#define __USE_MINGW_ANSI_STDIO 1
#endif
#endif

#define PERL_NO_GET_CONTEXT 1

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>

#ifndef _MSC_VER
#include <inttypes.h>
#include <limits.h>
#ifdef _DO_COMPLEX_H
#include <complex.h>
#endif
#endif

#include <gmp.h>
#include <mpfr.h>
#include <mpc.h>

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

#define MY_CXT_KEY "Math::MPC::_guts" XS_VERSION

typedef struct {
  mp_prec_t _perl_default_prec_re;
  mp_prec_t _perl_default_prec_im;
  mpc_rnd_t _perl_default_rounding_mode;
} my_cxt_t;

START_MY_CXT

#define DEFAULT_PREC MY_CXT._perl_default_prec_re,MY_CXT._perl_default_prec_im
#define DEFAULT_PREC_RE MY_CXT._perl_default_prec_re
#define DEFAULT_PREC_IM MY_CXT._perl_default_prec_im
#define DEFAULT_ROUNDING_MODE MY_CXT._perl_default_rounding_mode

/* These (CXT) values set at boot ... MPC_RNDNN == 0 */
/*
mpc_rnd_t _perl_default_rounding_mode = MPC_RNDNN;
mp_prec_t _perl_default_prec_re = 53;
mp_prec_t _perl_default_prec_im = 53;
*/



/* This function is used by overload_mul and overload_mul_eq whenn           */
/* USE_64_BIT_INT is defined.                                                */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_mul_sj (mpc_ptr rop, mpc_ptr op, intmax_t i, mpc_rnd_t rnd) {

#ifdef USE_64_BIT_INT

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(intmax_t) * CHAR_BIT);
   mpfr_set_sj (x, i, GMP_RNDN);

   inex = mpc_mul_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_mul_sj not implememnted on this build of perl");
}

#endif


/* This function is used by overload_mul and overload_mul_eq whenn           */
/* USE_LONG_DOUBLE is defined.                                               */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_mul_ld (mpc_ptr rop, mpc_ptr op, long double i, mpc_rnd_t rnd) {

#ifdef USE_LONG_DOUBLE

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(long double) * CHAR_BIT);
   mpfr_set_ld (x, i, GMP_RNDN);

   inex = mpc_mul_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_mul_ld not implememnted on this build of perl");
}

#endif


/* This function is used by overload_mul and overload_mul_eq.                */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_mul_d (mpc_ptr rop, mpc_ptr op, double i, mpc_rnd_t rnd) {
   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(double) * CHAR_BIT);
   mpfr_set_d (x, i, GMP_RNDN);

   inex = mpc_mul_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}


/* This function is used by overload_div and overload_div_eq whenn           */
/* USE_64_BIT_INT is defined.                                                */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_div_sj (mpc_ptr rop, mpc_ptr op, intmax_t i, mpc_rnd_t rnd) {

#ifdef USE_64_BIT_INT

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(intmax_t) * CHAR_BIT);
   mpfr_set_sj (x, i, GMP_RNDN);

   inex = mpc_div_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_div_sj not implememnted on this build of perl");
}

#endif


/* This function is used by overload_div and overload_div_eq whenn           */
/* USE_64_BIT_INT is defined.                                                */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_sj_div (mpc_ptr rop, intmax_t i, mpc_ptr op, mpc_rnd_t rnd) {

#ifdef USE_64_BIT_INT

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(intmax_t) * CHAR_BIT);
   mpfr_set_sj (x, i, GMP_RNDN);

   inex = mpc_fr_div (rop, x, op, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_sj_div not implememnted on this build of perl");
}

#endif


/* This function is used by overload_div and overload_div_eq whenn           */
/* USE_LONG_DOUBLE is defined.                                               */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_div_ld (mpc_ptr rop, mpc_ptr op, long double i, mpc_rnd_t rnd) {

#ifdef USE_LONG_DOUBLE

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(long double) * CHAR_BIT);
   mpfr_set_ld (x, i, GMP_RNDN);

   inex = mpc_div_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_div_ld not implememnted on this build of perl");
}

#endif


/* This function is used by overload_div and overload_div_eq whenn           */
/* USE_LONG_DOUBLE is defined.                                               */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_ld_div (mpc_ptr rop, long double i, mpc_ptr op, mpc_rnd_t rnd) {

#ifdef USE_LONG_DOUBLE

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(long double) * CHAR_BIT);
   mpfr_set_ld (x, i, GMP_RNDN);

   inex = mpc_fr_div (rop, x, op, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_ld_div not implememnted on this build of perl");
}

#endif

/* This function is used by overload_div and overload_div_eq.                */
/* It is based on some code posted by Philippe Theveny.                      */
int _mpc_div_d (mpc_ptr rop, mpc_ptr op, double i, mpc_rnd_t rnd) {
   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(double) * CHAR_BIT);
   mpfr_set_d (x, i, GMP_RNDN);

   inex = mpc_div_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}


/* This function is used by overload_div and overload_div_eq.                */
/* It is based on some code posted by Philippe Theveny.                      */
int _mpc_d_div (mpc_ptr rop, double i, mpc_ptr op, mpc_rnd_t rnd) {
   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(double) * CHAR_BIT);
   mpfr_set_d (x, i, GMP_RNDN);

   inex = mpc_fr_div (rop, x, op, rnd);

   mpfr_clear (x);
   return inex;
}

void Rmpc_set_default_rounding_mode(pTHX_ SV * round) {
     dMY_CXT;
     DEFAULT_ROUNDING_MODE = (mpc_rnd_t)SvUV(round);
}

SV * Rmpc_get_default_rounding_mode(pTHX) {
     dMY_CXT;
     return newSVuv(DEFAULT_ROUNDING_MODE);
}

void Rmpc_set_default_prec(pTHX_ SV * prec) {
     dMY_CXT;
     DEFAULT_PREC_RE = (mp_prec_t)SvUV(prec);
     DEFAULT_PREC_IM = (mp_prec_t)SvUV(prec);
}

void Rmpc_set_default_prec2(pTHX_ SV * prec_re, SV * prec_im) {
     dMY_CXT;
     DEFAULT_PREC_RE = (mp_prec_t)SvUV(prec_re);
     DEFAULT_PREC_IM = (mp_prec_t)SvUV(prec_im);
}

SV * Rmpc_get_default_prec(pTHX) {
     dMY_CXT;
     if(DEFAULT_PREC_RE == DEFAULT_PREC_IM)
       return newSVuv(DEFAULT_PREC_RE);
     return newSVuv(0);
}

void Rmpc_get_default_prec2(void) {
     dTHX;
     dXSARGS;
     dMY_CXT;
     EXTEND(SP, 2);
     ST(0) = sv_2mortal(newSVuv(DEFAULT_PREC_RE));
     ST(1) = sv_2mortal(newSVuv(DEFAULT_PREC_IM));
     XSRETURN(2);
}

void Rmpc_set_prec(pTHX_ mpc_t * p, SV * prec) {
     mpc_set_prec(*p, SvUV(prec));
}

void Rmpc_set_re_prec(pTHX_ mpc_t * p, SV * prec) {
     mpfr_set_prec(MPC_RE(*p), SvUV(prec));
}

void Rmpc_set_im_prec(pTHX_ mpc_t * p, SV * prec) {
     mpfr_set_prec(MPC_IM(*p), SvUV(prec));
}

SV * Rmpc_get_prec(pTHX_ mpc_t * x) {
     return newSVuv(mpc_get_prec(*x));
}

void Rmpc_get_prec2(pTHX_ mpc_t * x) {
     dXSARGS;
     mp_prec_t re, im;
     mpc_get_prec2(&re, &im, *x);
     /* sp = mark; *//* not needed */
     EXTEND(SP, 2);
     ST(0) = sv_2mortal(newSVuv(re));
     ST(1) = sv_2mortal(newSVuv(im));
     /* PUTBACK; *//* not needed */
     XSRETURN(2);
}

SV * Rmpc_get_im_prec(pTHX_ mpc_t * x) {
     return newSVuv(mpfr_get_prec(MPC_IM(*x)));
}

SV * Rmpc_get_re_prec(pTHX_ mpc_t * x) {
     return newSVuv(mpfr_get_prec(MPC_RE(*x)));
}

void RMPC_RE(mpfr_t * fr, mpc_t * x) {
     mp_prec_t precision = mpfr_get_prec(MPC_RE(*x));
     mpfr_set_prec(*fr, precision);
     mpfr_set(*fr, MPC_RE(*x), GMP_RNDN); /* No rounding will be done, anyway */
}

void RMPC_IM(mpfr_t * fr, mpc_t * x) {
     mp_prec_t precision = mpfr_get_prec(MPC_IM(*x));
     mpfr_set_prec(*fr, precision);
     mpfr_set(*fr, MPC_IM(*x), GMP_RNDN); /* No rounding will be done, anyway */
}

SV * RMPC_INEX_RE(pTHX_ SV * x) {
     return newSViv(MPC_INEX_RE(SvIV(x)));
}

SV * RMPC_INEX_IM(pTHX_ SV * x) {
     return newSViv(MPC_INEX_IM(SvIV(x)));
}

void DESTROY(pTHX_ mpc_t * p) {
     mpc_clear(*p);
     Safefree(p);
}

void Rmpc_clear(pTHX_ mpc_t * p) {
     mpc_clear(*p);
     Safefree(p);
}

void Rmpc_clear_mpc(mpc_t * p) {
     mpc_clear(*p);
}

void Rmpc_clear_ptr(pTHX_ mpc_t * p) {
     Safefree(p);
}

SV * Rmpc_init2(pTHX_ SV * prec) {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init2 function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init2 (*mpc_t_obj, SvUV(prec));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpc_init3(pTHX_ SV * prec_r, SV * prec_i) {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init3 function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3 (*mpc_t_obj, SvUV(prec_r), SvUV(prec_i));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpc_init2_nobless(pTHX_ SV * prec) {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init2_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     mpc_init2 (*mpc_t_obj, SvUV(prec));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpc_init3_nobless(pTHX_ SV * prec_r, SV * prec_i) {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init3_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     mpc_init3 (*mpc_t_obj, SvUV(prec_r), SvUV(prec_i));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpc_set(pTHX_ mpc_t * p, mpc_t * q, SV * round) {
     return newSViv(mpc_set(*p, *q, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_ui(pTHX_ mpc_t * p, SV * q, SV * round) {
     return newSViv(mpc_set_ui(*p, SvUV(q), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_si(pTHX_ mpc_t * p, SV * q, SV * round) {
     return newSViv(mpc_set_si(*p, SvIV(q), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_ld(pTHX_ mpc_t * p, SV * q, SV * round) {
#ifdef USE_LONG_DOUBLE
     return newSViv(mpc_set_ld(*p, SvNV(q), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_ld not implemented for this build of perl");
#endif
}

SV * Rmpc_set_uj(pTHX_ mpc_t * p, SV * q, SV * round) {
#ifdef USE_64_BIT_INT
     return newSViv(mpc_set_uj(*p, SvUV(q), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_uj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_sj(pTHX_ mpc_t * p, SV * q, SV * round) {
#ifdef USE_64_BIT_INT
     return newSViv(mpc_set_sj(*p, SvIV(q), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_sj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_z(pTHX_ mpc_t * p, mpz_t * q, SV * round) {
     return newSViv(mpc_set_z(*p, *q, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_f(pTHX_ mpc_t * p, mpf_t * q, SV * round) {
     return newSViv(mpc_set_f(*p, *q, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_q(pTHX_ mpc_t * p, mpq_t * q, SV * round) {
     return newSViv(mpc_set_q(*p, *q, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_d(pTHX_ mpc_t * p, SV * q, SV * round) {
     return newSViv(mpc_set_d(*p, SvNV(q), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_fr(pTHX_ mpc_t * p, mpfr_t * q, SV * round) {
     return newSViv(mpc_set_fr(*p, *q, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_ui_ui(pTHX_ mpc_t * p, SV * q_r, SV * q_i, SV * round) {
     return newSViv(mpc_set_ui_ui(*p, (unsigned long)SvUV(q_r), (unsigned long)SvUV(q_i), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_si_si(pTHX_ mpc_t * p, SV * q_r, SV * q_i, SV * round) {
     return newSViv(mpc_set_si_si(*p, (long)SvIV(q_r), (long)SvIV(q_i), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_d_d(pTHX_ mpc_t * p, SV * q_r, SV * q_i, SV * round) {
     return newSViv(mpc_set_d_d(*p, (double)SvNV(q_r), (double)SvNV(q_i), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_ld_ld(pTHX_ mpc_t * mpc, SV * ld1, SV * ld2, SV * round) {
#ifdef USE_LONG_DOUBLE
     return newSViv(mpc_set_ld_ld(*mpc, SvNV(ld1), SvNV(ld2), (mpc_rnd_t) SvUV(round)));
#else
     croak("Rmpc_set_ld_ld not implemented for this build of perl");
#endif
}

SV * Rmpc_set_z_z(pTHX_ mpc_t * p, mpz_t * q_r, mpz_t * q_i, SV * round) {
     return newSViv(mpc_set_z_z(*p, *q_r, *q_i, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_q_q(pTHX_ mpc_t * p, mpq_t * q_r, mpq_t * q_i, SV * round) {
     return newSViv(mpc_set_q_q(*p, *q_r, *q_i, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_f_f(pTHX_ mpc_t * p, mpf_t * q_r, mpf_t * q_i, SV * round) {
     return newSViv(mpc_set_f_f(*p, *q_r, *q_i, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_fr_fr(pTHX_ mpc_t * p, mpfr_t * q_r, mpfr_t * q_i, SV * round) {
     return newSViv(mpc_set_fr_fr(*p, *q_r, *q_i, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_d_ui(pTHX_ mpc_t * mpc, SV * d, SV * ui, SV * round) {
     SV_MPC_SET_X_Y(d, ui, *mpc, (double)SvNV(d), (unsigned long int)SvUV(ui), (mpc_rnd_t)SvUV(round));
}

SV * Rmpc_set_d_si(pTHX_ mpc_t * mpc, SV * d, SV * si, SV * round) {
     SV_MPC_SET_X_Y(d, si, *mpc, (double)SvNV(d), (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_d_fr(pTHX_ mpc_t * mpc, SV * d, mpfr_t * mpfr, SV * round) {
     SV_MPC_SET_X_Y(d, fr, *mpc, (double)SvNV(d), *mpfr, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_ui_d(pTHX_ mpc_t * mpc, SV * ui, SV * d, SV * round) {
     SV_MPC_SET_X_Y(ui, d, *mpc, (unsigned long)SvUV(ui), (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_ui_si(pTHX_ mpc_t * mpc, SV * ui, SV * si, SV * round) {
     SV_MPC_SET_X_Y(ui, si, *mpc, (unsigned long)SvUV(ui), (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_ui_fr(pTHX_ mpc_t * mpc, SV * ui, mpfr_t * mpfr, SV * round) {
     SV_MPC_SET_X_Y(ui, fr, *mpc, (unsigned long)SvUV(ui), *mpfr, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_si_d(pTHX_ mpc_t * mpc, SV * si, SV * d, SV * round) {
     SV_MPC_SET_X_Y(si, d, *mpc, (signed long int)SvIV(si), (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_si_ui(pTHX_ mpc_t * mpc, SV * si, SV * ui, SV * round) {
     SV_MPC_SET_X_Y(si, ui, *mpc, (signed long int)SvIV(si), (unsigned long)SvUV(ui), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_si_fr(pTHX_ mpc_t * mpc, SV * si, mpfr_t * mpfr, SV * round) {
     SV_MPC_SET_X_Y(si, fr, *mpc, (signed long int)SvIV(si), *mpfr, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_fr_d(pTHX_ mpc_t * mpc, mpfr_t * mpfr, SV * d, SV * round) {
     SV_MPC_SET_X_Y(fr, d, *mpc, *mpfr, (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_fr_ui(pTHX_ mpc_t * mpc, mpfr_t * mpfr, SV * ui, SV * round) {
     SV_MPC_SET_X_Y(fr, ui, *mpc, *mpfr, (unsigned long)SvUV(ui), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_fr_si(pTHX_ mpc_t * mpc, mpfr_t * mpfr, SV * si, SV * round) {
     SV_MPC_SET_X_Y(fr, si, *mpc, *mpfr , (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_ld_ui(pTHX_ mpc_t * mpc, SV * d, SV * ui, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(ld, ui, *mpc, SvNV(d), (unsigned long)SvUV(ui), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_ui not implemented for this build of perl");
#endif
}

SV * Rmpc_set_ld_si(pTHX_ mpc_t * mpc, SV * d, SV * si, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(ld, si, *mpc, SvNV(d), (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_si not implemented for this build of perl");
#endif
}

SV * Rmpc_set_ld_fr(pTHX_ mpc_t * mpc, SV * d, mpfr_t * mpfr, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(ld, fr, *mpc, SvNV(d), *mpfr, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_fr not implemented for this build of perl");
#endif
}

SV * Rmpc_set_ui_ld(pTHX_ mpc_t * mpc, SV * ui, SV * d, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(ui, ld, *mpc, (unsigned long)SvUV(ui), SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ui_ld not implemented for this build of perl");
#endif
}

SV * Rmpc_set_si_ld(pTHX_ mpc_t * mpc, SV * si, SV * d, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(si, ld, *mpc, (signed long int)SvIV(si), SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_si_ld not implemented for this build of perl");
#endif
}

SV * Rmpc_set_fr_ld(pTHX_ mpc_t * mpc, mpfr_t * mpfr, SV * d, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(fr, ld, *mpc, *mpfr, SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_fr_ld not implemented for this build of perl");
#endif
}

SV * Rmpc_set_d_uj(pTHX_ mpc_t * mpc, SV * d, SV * ui, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(d, uj, *mpc, (double)SvNV(d), SvUV(ui), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_d_uj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_d_sj(pTHX_ mpc_t * mpc, SV * d, SV * si, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(d, sj, *mpc, (double)SvNV(d), SvIV(si), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_d_sj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_sj_d(pTHX_ mpc_t * mpc, SV * si, SV * d, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(sj, d, *mpc, SvIV(si), (double)SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_d not implemented for this build of perl");
#endif
}

SV * Rmpc_set_uj_d(pTHX_ mpc_t * mpc, SV * ui, SV * d, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(uj, d, *mpc, SvUV(ui), (double)SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_d not implemented for this build of perl");
#endif
}

SV * Rmpc_set_uj_fr(pTHX_ mpc_t * mpc, SV * ui, mpfr_t * mpfr, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(uj, fr, *mpc, SvUV(ui), *mpfr, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_fr not implemented for this build of perl");
#endif
}

SV * Rmpc_set_sj_fr(pTHX_ mpc_t * mpc, SV * si, mpfr_t * mpfr, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(sj, fr, *mpc, SvIV(si), *mpfr, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_fr not implemented for this build of perl");
#endif
}

SV * Rmpc_set_fr_uj(pTHX_ mpc_t * mpc, mpfr_t * mpfr, SV * ui, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(fr, uj, *mpc, *mpfr, SvUV(ui), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_fr_uj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_fr_sj(pTHX_ mpc_t * mpc, mpfr_t * mpfr, SV * si, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(fr, sj, *mpc, *mpfr , SvIV(si), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_fr_sj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_uj_sj(pTHX_ mpc_t * mpc, SV * ui, SV * si, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(uj, sj, *mpc, SvUV(ui), SvIV(si), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_si, Rmpc_set_ui_sj and Rmpc_set_uj_sj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_sj_uj(pTHX_ mpc_t * mpc, SV * si, SV * ui, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(sj, uj, *mpc, SvIV(si), SvUV(ui), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_ui, Rmpc_set_si_uj and Rmpc_set_sj_uj not implemented for this build of perl");
#endif
}


SV * Rmpc_set_ld_uj(pTHX_ mpc_t * mpc, SV * d, SV * ui, SV * round) {
#ifdef USE_64_BIT_INT
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(ld, uj, *mpc, SvNV(d), SvUV(ui), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_uj not implemented for this build of perl");
#endif
#else
     croak("Rmpc_set_ld_uj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_ld_sj(pTHX_ mpc_t * mpc, SV * d, SV * si, SV * round) {
#ifdef USE_64_BIT_INT
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(ld, sj, *mpc, SvNV(d), SvIV(si), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_sj not implemented for this build of perl");
#endif
#else
     croak("Rmpc_set_ld_sj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_uj_ld(pTHX_ mpc_t * mpc, SV * ui, SV * d, SV * round) {
#ifdef USE_64_BIT_INT
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(uj, ld, *mpc, SvUV(ui), SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_ld not implemented for this build of perl");
#endif
#else
     croak("Rmpc_set_uj_ld not implemented for this build of perl");
#endif
}

SV * Rmpc_set_sj_ld(pTHX_ mpc_t * mpc, SV * si, SV * d, SV * round) {
#ifdef USE_64_BIT_INT
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(sj, ld, *mpc, SvIV(si), SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_ld not implemented for this build of perl");
#endif
#else
     croak("Rmpc_set_sj_ld not implemented for this build of perl");
#endif
}

SV * Rmpc_set_f_ui(pTHX_ mpc_t * mpc, mpf_t * mpf, SV * ui, SV * round) {
     SV_MPC_SET_X_Y(f, ui, *mpc, *mpf, (unsigned long int)SvUV(ui), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_q_ui(pTHX_ mpc_t * mpc, mpq_t * mpq, SV * ui, SV * round) {
     SV_MPC_SET_X_Y(q, ui, *mpc, *mpq, (unsigned long int)SvUV(ui), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_z_ui(pTHX_ mpc_t * mpc, mpz_t * mpz, SV * ui, SV * round) {
     SV_MPC_SET_X_Y(z, ui, *mpc, *mpz, (unsigned long int)SvUV(ui), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_f_si(pTHX_ mpc_t * mpc, mpf_t * mpf, SV * si, SV * round) {
     SV_MPC_SET_X_Y(f, si, *mpc, *mpf, (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_q_si(pTHX_ mpc_t * mpc, mpq_t * mpq, SV * si, SV * round) {
     SV_MPC_SET_X_Y(q, si, *mpc, *mpq, (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_z_si(pTHX_ mpc_t * mpc, mpz_t * mpz, SV * si, SV * round) {
     SV_MPC_SET_X_Y(z, si, *mpc, *mpz, (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_f_d(pTHX_ mpc_t * mpc, mpf_t * mpf, SV * d, SV * round) {
     SV_MPC_SET_X_Y(f, d, *mpc, *mpf, (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_q_d(pTHX_ mpc_t * mpc, mpq_t * mpq, SV * d, SV * round) {
     SV_MPC_SET_X_Y(q, d, *mpc, *mpq, (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_z_d(pTHX_ mpc_t * mpc, mpz_t * mpz, SV * d, SV * round) {
     SV_MPC_SET_X_Y(z, d, *mpc, *mpz, (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_f_uj(pTHX_ mpc_t * mpc, mpf_t * mpf, SV * uj, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(f, uj, *mpc, *mpf, (unsigned long long)SvUV(uj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_f_uj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_q_uj(pTHX_ mpc_t * mpc, mpq_t * mpq, SV * uj, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(q, uj, *mpc, *mpq, (unsigned long long)SvUV(uj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_q_uj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_z_uj(pTHX_ mpc_t * mpc, mpz_t * mpz, SV * uj, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(z, uj, *mpc, *mpz, (unsigned long long)SvUV(uj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_z_uj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_f_sj(pTHX_ mpc_t * mpc, mpf_t * mpf, SV * sj, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(f, sj, *mpc, *mpf, (signed long long)SvIV(sj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_f_sj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_q_sj(pTHX_ mpc_t * mpc, mpq_t * mpq, SV * sj, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(q, sj, *mpc, *mpq, (signed long long)SvIV(sj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_q_sj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_z_sj(pTHX_ mpc_t * mpc, mpz_t * mpz, SV * sj, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(z, sj, *mpc, *mpz, (signed long long)SvIV(sj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_z_sj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_f_ld(pTHX_ mpc_t * mpc, mpf_t * mpf, SV * ld, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(f, ld, *mpc, *mpf, (long double)SvNV(ld), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_f_ld not implemented for this build of perl");
#endif
}

SV * Rmpc_set_q_ld(pTHX_ mpc_t * mpc, mpq_t * mpq, SV * ld, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(q, ld, *mpc, *mpq, (long double)SvNV(ld), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_q_ld not implemented for this build of perl");
#endif
}

SV * Rmpc_set_z_ld(pTHX_ mpc_t * mpc, mpz_t * mpz, SV * ld, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(z, ld, *mpc, *mpz, (long double)SvNV(ld), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_z_ld not implemented for this build of perl");
#endif
}

/*
##############################
##############################
*/

SV * Rmpc_set_ui_f(pTHX_ mpc_t * mpc, SV * ui, mpf_t * mpf, SV * round) {
     SV_MPC_SET_X_Y(ui, f, *mpc, (unsigned long int)SvUV(ui), *mpf, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_ui_q(pTHX_ mpc_t * mpc, SV * ui, mpq_t * mpq, SV * round) {
     SV_MPC_SET_X_Y(ui, q, *mpc, (unsigned long int)SvUV(ui), *mpq, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_ui_z(pTHX_ mpc_t * mpc, SV * ui, mpz_t * mpz, SV * round) {
     SV_MPC_SET_X_Y(ui, z, *mpc, (unsigned long int)SvUV(ui), *mpz, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_si_f(pTHX_ mpc_t * mpc, SV * si, mpf_t * mpf, SV * round) {
     SV_MPC_SET_X_Y(si, f, *mpc, (signed long int)SvIV(si), *mpf, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_si_q(pTHX_ mpc_t * mpc, SV * si, mpq_t * mpq, SV * round) {
     SV_MPC_SET_X_Y(si, q, *mpc, (signed long int)SvIV(si), *mpq, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_si_z(pTHX_ mpc_t * mpc, SV * si, mpz_t * mpz, SV * round) {
     SV_MPC_SET_X_Y(si, z, *mpc, (signed long int)SvIV(si), *mpz, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_d_f(pTHX_ mpc_t * mpc, SV * d, mpf_t * mpf, SV * round) {
     SV_MPC_SET_X_Y(d, f, *mpc, (double)SvNV(d), *mpf, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_d_q(pTHX_ mpc_t * mpc, SV * d, mpq_t * mpq, SV * round) {
     SV_MPC_SET_X_Y(d, q, *mpc, (double)SvNV(d), *mpq, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_d_z(pTHX_ mpc_t * mpc, SV * d, mpz_t * mpz, SV * round) {
     SV_MPC_SET_X_Y(d, z, *mpc, (double)SvNV(d), *mpz, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_uj_f(pTHX_ mpc_t * mpc, SV * uj, mpf_t * mpf, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(uj, f, *mpc, (unsigned long long)SvUV(uj), *mpf, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_f not implemented for this build of perl");
#endif
}

SV * Rmpc_set_uj_q(pTHX_ mpc_t * mpc, SV * uj, mpq_t * mpq, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(uj, q, *mpc, (unsigned long long)SvUV(uj), *mpq, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_q not implemented for this build of perl");
#endif
}

SV * Rmpc_set_uj_z(pTHX_ mpc_t * mpc, SV * uj, mpz_t * mpz, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(uj, z, *mpc, (unsigned long long)SvUV(uj), *mpz, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_z not implemented for this build of perl");
#endif
}

SV * Rmpc_set_sj_f(pTHX_ mpc_t * mpc, SV * sj, mpf_t * mpf, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(sj, f, *mpc, (signed long long)SvIV(sj), *mpf, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_f not implemented for this build of perl");
#endif
}

SV * Rmpc_set_sj_q(pTHX_ mpc_t * mpc, SV * sj, mpq_t * mpq, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(sj, q, *mpc, (signed long long)SvIV(sj), *mpq, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_q not implemented for this build of perl");
#endif
}

SV * Rmpc_set_sj_z(pTHX_ mpc_t * mpc, SV * sj, mpz_t * mpz, SV * round) {
#ifdef USE_64_BIT_INT
     SV_MPC_SET_X_Y(sj, z, *mpc, (signed long long)SvIV(sj), *mpz, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_z not implemented for this build of perl");
#endif
}

SV * Rmpc_set_ld_f(pTHX_ mpc_t * mpc, SV * ld, mpf_t * mpf, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(ld, f, *mpc, (long double)SvNV(ld), *mpf, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_f not implemented for this build of perl");
#endif
}

SV * Rmpc_set_ld_q(pTHX_ mpc_t * mpc, SV * ld, mpq_t * mpq, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(ld, q, *mpc, (long double)SvNV(ld), *mpq, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_q not implemented for this build of perl");
#endif
}

SV * Rmpc_set_ld_z(pTHX_ mpc_t * mpc, SV * ld, mpz_t * mpz, SV * round) {
#ifdef USE_LONG_DOUBLE
     SV_MPC_SET_X_Y(ld, z, *mpc, (long double)SvNV(ld), *mpz, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_z not implemented for this build of perl");
#endif
}

/*
##############################
##############################
*/

SV * Rmpc_set_f_q(pTHX_ mpc_t * mpc, mpf_t * mpf, mpq_t * mpq, SV * round) {
     SV_MPC_SET_X_Y(f, q, *mpc, *mpf, *mpq, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_q_f(pTHX_ mpc_t * mpc, mpq_t * mpq, mpf_t * mpf, SV * round) {
     SV_MPC_SET_X_Y(q, f, *mpc, *mpq, *mpf, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_f_z(pTHX_ mpc_t * mpc, mpf_t * mpf, mpz_t * mpz, SV * round) {
     SV_MPC_SET_X_Y(f, z, *mpc, *mpf, *mpz, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_z_f(pTHX_ mpc_t * mpc, mpz_t * mpz, mpf_t * mpf, SV * round) {
     SV_MPC_SET_X_Y(z, f, *mpc, *mpz, *mpf, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_q_z(pTHX_ mpc_t * mpc, mpq_t * mpq, mpz_t * mpz, SV * round) {
     SV_MPC_SET_X_Y(q, z, *mpc, *mpq, *mpz, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_z_q(pTHX_ mpc_t * mpc, mpz_t * mpz, mpq_t * mpq, SV * round) {
     SV_MPC_SET_X_Y(z, q, *mpc, *mpz, *mpq, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_f_fr(pTHX_ mpc_t * mpc, mpf_t * mpf, mpfr_t * mpfr, SV * round) {
     SV_MPC_SET_X_Y(f, fr, *mpc, *mpf, *mpfr, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_fr_f(pTHX_ mpc_t * mpc, mpfr_t * mpfr, mpf_t * mpf, SV * round) {
     SV_MPC_SET_X_Y(fr, f, *mpc, *mpfr, *mpf, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_q_fr(pTHX_ mpc_t * mpc, mpq_t * mpq, mpfr_t * mpfr, SV * round) {
     SV_MPC_SET_X_Y(q, fr, *mpc, *mpq, *mpfr, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_fr_q(pTHX_ mpc_t * mpc, mpfr_t * mpfr, mpq_t * mpq, SV * round) {
     SV_MPC_SET_X_Y(fr, q, *mpc, *mpfr, *mpq, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_z_fr(pTHX_ mpc_t * mpc, mpz_t * mpz, mpfr_t * mpfr, SV * round) {
     SV_MPC_SET_X_Y(z, fr, *mpc, *mpz, *mpfr, (mpc_rnd_t) SvUV(round));
}

SV * Rmpc_set_fr_z(pTHX_ mpc_t * mpc, mpfr_t * mpfr, mpz_t * mpz, SV * round) {
     SV_MPC_SET_X_Y(fr, z, *mpc, *mpfr, *mpz, (mpc_rnd_t) SvUV(round));
}


/*
##############################
##############################
*/

SV * Rmpc_set_uj_uj(pTHX_ mpc_t * mpc, SV * uj1, SV * uj2, SV * round) {
#ifdef USE_64_BIT_INT
     return newSViv(mpc_set_uj_uj(*mpc, (unsigned long long)SvUV(uj1),
                    (unsigned long long)SvUV(uj2), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_ui_uj, Rmpc_set_uj_ui and Rmpc_set_uj_uj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_sj_sj(pTHX_ mpc_t * mpc, SV * sj1, SV * sj2, SV * round) {
#ifdef USE_64_BIT_INT
     return newSViv(mpc_set_sj_sj(*mpc, (signed long long)SvIV(sj1),
                    (signed long long)SvIV(sj2), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_si_sj, Rmpc_set_sj_si and Rmpc_set_sj_sj not implemented for this build of perl");
#endif
}

SV * Rmpc_add(pTHX_ mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_add(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_add_ui(pTHX_ mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_add_ui(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_add_fr(pTHX_ mpc_t * a, mpc_t * b, mpfr_t * c, SV * round){
     return newSViv(mpc_add_fr(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_sub(pTHX_ mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_sub(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_sub_ui(pTHX_ mpc_t * a, mpc_t * b, SV * c, SV * round) {
     return newSViv(mpc_sub_ui(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_ui_sub(pTHX_ mpc_t * a, SV * b, mpc_t * c, SV * round) {
     return newSViv(mpc_ui_sub(*a, SvUV(b), *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_ui_ui_sub(pTHX_ mpc_t * a, SV * b_r, SV * b_i, mpc_t * c, SV * round) {
     return newSViv(mpc_ui_ui_sub(*a, SvUV(b_r), SvUV(b_i), *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_mul(pTHX_ mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_mul(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_mul_ui(pTHX_ mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_mul_ui(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_mul_si(pTHX_ mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_mul_si(*a, *b, SvIV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_mul_fr(pTHX_ mpc_t * a, mpc_t * b, mpfr_t * c, SV * round){
     return newSViv(mpc_mul_fr(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_mul_i(pTHX_ mpc_t * a, mpc_t * b, SV * sign, SV * round){
     return newSViv(mpc_mul_i(*a, *b, SvIV(sign), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_sqr(pTHX_ mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_sqr(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_div(pTHX_ mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_div(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_div_ui(pTHX_ mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_div_ui(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_ui_div(pTHX_ mpc_t * a, SV * b, mpc_t * c, SV * round) {
     return newSViv(mpc_ui_div(*a, SvUV(b), *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_div_fr(pTHX_ mpc_t * a, mpc_t * b, mpfr_t * c, SV * round){
     return newSViv(mpc_div_fr(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_sqrt(pTHX_ mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_sqrt(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow(pTHX_ mpc_t * a, mpc_t * b, mpc_t * pow, SV * round) {
     return newSViv(mpc_pow(*a, *b, *pow, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow_d(pTHX_ mpc_t * a, mpc_t * b, SV * pow, SV * round) {
     return newSViv(mpc_pow_d(*a, *b, SvNV(pow), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow_ld(pTHX_ mpc_t * a, mpc_t * b, SV * pow, SV * round) {
#ifdef USE_LONG_DOUBLE
     return newSViv(mpc_pow_ld(*a, *b, SvNV(pow), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_pow_ld not implemented on this build of perl");
#endif
}

SV * Rmpc_pow_si(pTHX_ mpc_t * a, mpc_t * b, SV * pow, SV * round) {
     return newSViv(mpc_pow_si(*a, *b, SvIV(pow), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow_ui(pTHX_ mpc_t * a, mpc_t * b, SV * pow, SV * round) {
     return newSViv(mpc_pow_ui(*a, *b, SvUV(pow), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow_z(pTHX_ mpc_t * a, mpc_t * b, mpz_t * pow, SV * round) {
     return newSViv(mpc_pow_z(*a, *b, *pow, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow_fr(pTHX_ mpc_t * a, mpc_t * b, mpfr_t * pow, SV * round) {
     return newSViv(mpc_pow_fr(*a, *b, *pow, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_neg(pTHX_ mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_neg(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_abs(pTHX_ mpfr_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_abs(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_conj(pTHX_ mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_conj(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_norm(pTHX_ mpfr_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_norm(*a, *b, (mpc_rnd_t)SvUV(round)));
}

/* Beginning mpc-1.0, mpc_mul_2exp and mpc_div_2exp were
*  renamed mpc_mul_2ui and mpc_div_2ui
*/

SV * Rmpc_mul_2ui(pTHX_ mpc_t * a, mpc_t * b, SV * c, SV * round) {
#if MPC_VERSION < 65536
     return newSViv(mpc_mul_2exp(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
#else
     return newSViv(mpc_mul_2ui(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
#endif
}

SV * Rmpc_div_2ui(pTHX_ mpc_t * a, mpc_t * b, SV * c, SV * round) {
#if MPC_VERSION < 65536
     return newSViv(mpc_div_2exp(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
#else
     return newSViv(mpc_div_2ui(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
#endif
}

SV * Rmpc_cmp(pTHX_ mpc_t * a, mpc_t * b) {
     return newSViv(mpc_cmp(*a, *b));
}

SV * Rmpc_cmp_si(pTHX_ mpc_t * a, SV * b) {
     return newSViv(mpc_cmp_si(*a, SvIV(b)));
}

SV * Rmpc_cmp_si_si(pTHX_ mpc_t * a, SV * b, SV * c) {
     return newSViv(mpc_cmp_si_si(*a, SvIV(b), SvIV(c)));
}

SV * Rmpc_exp(pTHX_ mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_exp(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_log(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_log(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * _Rmpc_out_str(pTHX_ FILE * stream, SV * base, SV * dig, mpc_t * p, SV * round) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("2nd argument supplied to Rmpc_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, (mpc_rnd_t)SvUV(round));
     fflush(stream);
     return newSVuv(ret);
}

SV * _Rmpc_out_strS(pTHX_ FILE * stream, SV * base, SV * dig, mpc_t * p, SV * round, SV * suff) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("2nd argument supplied to Rmpc_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, (mpc_rnd_t)SvUV(round));
     fflush(stream);
     fprintf(stream, "%s", SvPV_nolen(suff));
     fflush(stream);
     return newSVuv(ret);
}

SV * _Rmpc_out_strP(pTHX_ SV * pre, FILE * stream, SV * base, SV * dig, mpc_t * p, SV * round) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("3rd argument supplied to Rmpc_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     fprintf(stream, "%s", SvPV_nolen(pre));
     fflush(stream);
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, (mpc_rnd_t)SvUV(round));
     fflush(stream);
     return newSVuv(ret);
}

SV * _Rmpc_out_strPS(pTHX_ SV * pre, FILE * stream, SV * base, SV * dig, mpc_t * p, SV * round, SV * suff) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("3rd argument supplied to Rmpc_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     fprintf(stream, "%s", SvPV_nolen(pre));
     fflush(stream);
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, (mpc_rnd_t)SvUV(round));
     fflush(stream);
     fprintf(stream, "%s", SvPV_nolen(suff));
     fflush(stream);
     return newSVuv(ret);
}


SV * Rmpc_inp_str(pTHX_ mpc_t * p, FILE * stream, SV * base, SV * round) {
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("3rd argument supplied to TRmpfr_inp_str is out of allowable range (must be between 2 and 36 inclusive)");
     return newSViv(mpc_inp_str(*p, stream, NULL, (int)SvIV(base), (mpc_rnd_t)SvUV(round)));
}

/* Removed in mpc-0.7
void Rmpc_random(mpc_t * p) {
     mpc_random(*p);
}
*/

/* Removed in mpc-0.7
void Rmpc_random2(mpc_t * p, SV * s, SV * exp) {
     mpc_random2(*p, SvIV(s), SvUV(exp));
}
*/

SV * Rmpc_sin(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_sin(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_cos(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_cos(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_tan(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_tan(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_sinh(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_sinh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_cosh(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_cosh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_tanh(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_tanh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_asin(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_asin(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_acos(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_acos(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_atan(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_atan(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_asinh(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_asinh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_acosh(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_acosh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_atanh(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_atanh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * overload_true(pTHX_ mpc_t *a, SV *second, SV * third) {
     if(
       ( mpfr_nan_p(MPC_RE(*a)) || !mpfr_cmp_ui(MPC_RE(*a), 0) ) &&
       ( mpfr_nan_p(MPC_IM(*a)) || !mpfr_cmp_ui(MPC_IM(*a), 0) )
       ) return newSVuv(0);
     return newSVuv(1);
}

/********************************/
/********************************/
/********************************/
/********************************/
/********************************/
/********************************/
/********************************/
/********************************/

SV * overload_mul(pTHX_ mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_mul function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_mul(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(SvIOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
       mpc_mul(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
#else
       /* mpc_set_sj(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE); */
       _mpc_mul_sj(*mpc_t_obj, *a, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       /* mpc_mul(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE); */
       return obj_ref;
     }

#else
     if(SvUOK(b)) {
       mpc_mul_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpc_mul_si(*mpc_t_obj, *a, SvIV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       _mpc_mul_ld(*mpc_t_obj, *a, (long double)SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       _mpc_mul_d(*mpc_t_obj,*a, (double)SvNV(b), DEFAULT_ROUNDING_MODE);
#endif

      return obj_ref;
     }

     if(SvPOK(b)) {
       if(mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1)
         croak("Invalid string supplied to Math::MPC::overload_mul");
       mpc_mul(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         mpc_mul(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_mul");
}

SV * overload_add(pTHX_ mpc_t* a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_add function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_add(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(SvIOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_add(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

#else

     if(SvUOK(b)) {
       mpc_add_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_add_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       mpc_sub_ui(*mpc_t_obj, *a, SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_set_ld(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
       mpc_add(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
       mpc_add(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
#endif

       return obj_ref;
     }

     if(SvPOK(b)) {
       if(mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1)
         croak("Invalid string supplied to Math::MPC::overload_add");
       mpc_add(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         mpc_add(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_add");
}

SV * overload_sub(pTHX_ mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_sub function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }
#else
     if(SvUOK(b)) {
       if(third == &PL_sv_yes) mpc_ui_sub(*mpc_t_obj, SvUV(b), *a, DEFAULT_ROUNDING_MODE);
       else mpc_sub_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         if(third == &PL_sv_yes) mpc_ui_sub(*mpc_t_obj, SvUV(b), *a, DEFAULT_ROUNDING_MODE);
         else mpc_sub_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       mpc_add_ui(*mpc_t_obj, *a, SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       if(third == &PL_sv_yes) mpc_neg(*mpc_t_obj, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_set_ld(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvPOK(b)) {
       if(mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1)
         croak("Invalid string supplied to Math::MPC::overload_sub");
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         mpc_sub(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_sub function");
}

SV * overload_div(pTHX_ mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_div function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
       if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
#else
       /* mpc_set_sj(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE); */
       if(third == &PL_sv_yes) _mpc_sj_div(*mpc_t_obj, SvIV(b), *a, DEFAULT_ROUNDING_MODE);
       else _mpc_div_sj(*mpc_t_obj, *a, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       /* if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE); */
       return obj_ref;
       }
#else
     if(SvUOK(b)) {
       if(third == &PL_sv_yes) mpc_ui_div(*mpc_t_obj, SvUV(b), *a, DEFAULT_ROUNDING_MODE);
       else mpc_div_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         if(third == &PL_sv_yes) mpc_ui_div(*mpc_t_obj, SvUV(b), *a, DEFAULT_ROUNDING_MODE);
         else mpc_div_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       if(third == &PL_sv_yes) mpc_ui_div(*mpc_t_obj, SvIV(b) * -1, *a, DEFAULT_ROUNDING_MODE);
       else mpc_div_ui(*mpc_t_obj, *a, SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       mpc_neg(*mpc_t_obj, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       /* mpc_set_ld(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE); */
       if(third == &PL_sv_yes) _mpc_ld_div(*mpc_t_obj, (long double)SvNV(b), *a, DEFAULT_ROUNDING_MODE);
       else _mpc_div_ld(*mpc_t_obj, *a, (long double)SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       /* mpc_set_d(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE); */
       if(third == &PL_sv_yes) _mpc_d_div(*mpc_t_obj, (double)SvNV(b), *a, DEFAULT_ROUNDING_MODE);
       else _mpc_div_d(*mpc_t_obj, *a, (double)SvNV(b), DEFAULT_ROUNDING_MODE);
#endif
       /* if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE); */
       /* else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE); */
       return obj_ref;
       }

     if(SvPOK(b)) {
       if(mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1)
         croak("Invalid string supplied to Math::MPC::overload_div");
       if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         mpc_div(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_div function");

}


SV * overload_div_eq(pTHX_ SV * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t temp;

     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvIOK(b)) {
       /* mpc_init3(temp, DEFAULT_PREC); */
#ifdef _MSC_VER
       mpc_init3(temp, DEFAULT_PREC);
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
       mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
#else
       /* mpc_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE); */
       _mpc_div_sj(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       /* mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp); */
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_div_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_div_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
         return a;
         }
       mpc_div_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       mpc_neg(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), DEFAULT_ROUNDING_MODE);
       return a;
       }
#endif

     if(SvNOK(b)) {
       /* mpc_init3(temp, DEFAULT_PREC); */
#ifdef USE_LONG_DOUBLE
       _mpc_div_ld(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), (long double)SvNV(b), DEFAULT_ROUNDING_MODE);
       /* mpc_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE); */
#else
       _mpc_div_d(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), (double)SvNV(b), DEFAULT_ROUNDING_MODE);
       /* mpc_set_d(temp, SvNV(b), DEFAULT_ROUNDING_MODE); */
#endif
       /* mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE); */
       /* mpc_clear(temp); */
       return a;
       }

     if(SvPOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
       if(mpc_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_div_eq");
         }
       mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_div_eq function");

}

SV * overload_sub_eq(pTHX_ SV * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t temp;

     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvIOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_sub_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_sub_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
         return a;
         }
       mpc_add_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       return a;
       }
#endif

     if(SvNOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);

#ifdef USE_LONG_DOUBLE
       mpc_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d(temp, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvPOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
       if(mpc_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_sub_eq");
         }
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_sub_eq function");

}

SV * overload_add_eq(pTHX_ SV * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t temp;
     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_add(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvIOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
 #ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_add(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_add_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_add_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
         return a;
         }
       mpc_sub_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       return a;
       }
#endif

     if(SvNOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef USE_LONG_DOUBLE
       mpc_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d(temp, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_add(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvPOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
       if(mpc_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_add_eq");
         }
       mpc_add(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         mpc_add(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_add_eq");
}

SV * overload_mul_eq(pTHX_ SV * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t temp;

     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvIOK(b)) {
       /* mpc_init3(temp, DEFAULT_PREC); */
#ifdef _MSC_VER
       mpc_init3(temp, DEFAULT_PREC);
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
       mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
#else
       /* mpc_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE); */
       _mpc_mul_sj(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       /* mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp); */
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_mul_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
       }

     if(SvIOK(b)) {
       mpc_mul_si(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
       }

#endif

     if(SvNOK(b)) {
       /* mpc_init3(temp, DEFAULT_PREC); */
#ifdef USE_LONG_DOUBLE
       _mpc_mul_ld(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), (long double)SvNV(b), DEFAULT_ROUNDING_MODE);
       /* mpc_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE); */
#else
       _mpc_mul_d(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), (double)SvNV(b), DEFAULT_ROUNDING_MODE);
       /* mpc_set_d(temp, SvNV(b), DEFAULT_ROUNDING_MODE); */
#endif
       /* mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE); */
       /* mpc_clear(temp); */
       return a;
       }

     if(SvPOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
       if(mpc_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_mul_eq");
         }
       mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_mul_eq");
}

SV * overload_pow(pTHX_ mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_pow function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_pow(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(SvIOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_pow(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

#else
     if(SvUOK(b)) {
       mpc_pow_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpc_pow_si(*mpc_t_obj, *a, SvIV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_pow_ld(*mpc_t_obj, *a, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_pow_d(*mpc_t_obj, *a, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif

     return obj_ref;
     }

     if(SvPOK(b)) {
       if(mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1)
         croak("Invalid string supplied to Math::MPC::overload_pow");
       mpc_pow(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         mpc_pow(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
     }

     croak("Invalid argument supplied to Math::MPC::overload_pow");
}

SV * overload_pow_eq(pTHX_ SV * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t temp;

     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_pow(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
     }

     if(SvIOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_pow(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
     }
#else
     if(SvUOK(b)) {
       mpc_pow_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
     }

     if(SvIOK(b)) {
       mpc_pow_si(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b), DEFAULT_ROUNDING_MODE);
       return a;
     }

#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_pow_ld(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_pow_d(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvNV(b), DEFAULT_ROUNDING_MODE);
#endif
       return a;
     }

     if(SvPOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
       if(mpc_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_pow_eq");
       }
       mpc_pow(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         mpc_pow(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return a;
       }
     }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_pow_eq");
}

SV * overload_equiv(pTHX_ mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpfr_t temp;
     mpc_t t;
     int ret;

     if(mpfr_nan_p(MPC_RE(*a)) || mpfr_nan_p(MPC_IM(*a))) return newSViv(0);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui(t, SvUV(b), DEFAULT_ROUNDING_MODE);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpc_cmp_si(*a, SvIV(b));
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpfr_init2(temp, DEFAULT_PREC_RE);
       mpfr_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE & 3);
       if(mpfr_nan_p(temp)) {
         mpfr_clear(temp);
         return newSViv(0);
       }
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
#else
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_d(t, SvNV(b), DEFAULT_ROUNDING_MODE);
       if(mpfr_nan_p(MPC_RE(t))) ret = 1;
       else ret = mpc_cmp(*a, t);
       mpc_clear(t);
#endif
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
       if(mpfr_set_str(temp, (char *)SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE & 3))
         croak("Invalid string supplied to Math::MPC::overload_equiv");
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         if(mpfr_nan_p(MPC_RE(*(INT2PTR(mpc_t *, SvIV(SvRV(b)))))) ||
            mpfr_nan_p(MPC_IM(*(INT2PTR(mpc_t *, SvIV(SvRV(b))))))) return newSViv(0);
         ret = mpc_cmp(*a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))));
         if(ret == 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_equiv");
}

SV * overload_not_equiv(pTHX_ mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpfr_t temp;
     mpc_t t;
     int ret;

     if(mpfr_nan_p(MPC_RE(*a)) || mpfr_nan_p(MPC_IM(*a))) return newSViv(1);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }
#else
     if(SvUOK(b)) {
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui(t, SvUV(b), DEFAULT_ROUNDING_MODE);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }

     if(SvIOK(b)) {
       ret = mpc_cmp_si(*a, SvIV(b));
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpfr_init2(temp, DEFAULT_PREC_RE);
       mpfr_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE & 3);
       if(mpfr_nan_p(temp)) {
         mpfr_clear(temp);
         return newSViv(1);
       }
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
#else
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_d(t, SvNV(b), DEFAULT_ROUNDING_MODE);
       if(mpfr_nan_p(MPC_RE(t))) ret = 1;
       else ret = mpc_cmp(*a, t);
       mpc_clear(t);
#endif
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
       if(mpfr_set_str(temp, (char *)SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE & 3))
         croak("Invalid string supplied to Math::MPC::overload_not_equiv");
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPC")) {
         if(mpfr_nan_p(MPC_RE(*(INT2PTR(mpc_t *, SvIV(SvRV(b)))))) ||
            mpfr_nan_p(MPC_IM(*(INT2PTR(mpc_t *, SvIV(SvRV(b))))))) return newSViv(1);
         if(mpc_cmp(*a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))))) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_not_equiv");
}

SV * overload_not(pTHX_ mpc_t * a, SV * second, SV * third) {
     if(mpfr_nan_p(MPC_RE(*a)) || mpfr_nan_p(MPC_IM(*a))) return newSViv(1); /* Thanks Jean-Louis Morel */
     if(mpc_cmp_si_si(*a, 0, 0)) return newSViv(0);
     return newSViv(1);
}

SV * overload_sqrt(pTHX_ mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_sqrt function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_sqrt(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

void overload_copy(pTHX_ mpc_t * p, SV * second, SV * third) {
     dXSARGS;
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     mp_prec_t re, im;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_copy function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");

     mpc_get_prec2(&re, &im, *p);
     mpc_init3(*mpc_t_obj, re, im);
     mpc_set(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     ST(0) = sv_2mortal(obj_ref);
     /* PUTBACK; *//* not needed */
     XSRETURN(1);
}

SV * overload_abs(pTHX_ mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpfr_t * mpfr_t_obj;
     SV * obj_ref, * obj;

     New(1, mpfr_t_obj, 1, mpfr_t);
     if(mpfr_t_obj == NULL) croak("Failed to allocate memory in overload_abs function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPFR");
     mpfr_init(*mpfr_t_obj);

     mpc_abs(*mpfr_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpfr_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_exp(pTHX_ mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_exp function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_exp(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_log(pTHX_ mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_exp function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_log(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_sin(pTHX_ mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_sin function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_sin(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_cos(pTHX_ mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_sin function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_cos(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

void _get_r_string(pTHX_ mpc_t * p, SV * base, SV * n_digits, SV * round) {
     dXSARGS;
     char * out;
     mp_exp_t ptr;
     unsigned long b = SvUV(base);

     if(b < 2 || b > 36) croak("Second argument supplied to r_string() is not in acceptable range");

     out = mpfr_get_str(0, &ptr, b, SvUV(n_digits), MPC_RE(*p), (mpc_rnd_t)SvUV(round) & 3);

     if(out == NULL) croak("An error occurred in _get_r_string(aTHX)");

     /* sp = mark; *//* not needed */
     ST(0) = sv_2mortal(newSVpv(out, 0));
     mpfr_free_str(out);
     ST(1) = sv_2mortal(newSViv(ptr));
     /* PUTBACK; *//* not needed */
     XSRETURN(2);
}

void _get_i_string(pTHX_ mpc_t * p, SV * base, SV * n_digits, SV * round) {
     dXSARGS;
     char * out;
     mp_exp_t ptr;
     unsigned long b = SvUV(base);

     if(b < 2 || b > 36) croak("Second argument supplied to i_string() is not in acceptable range");

     out = mpfr_get_str(0, &ptr, b, SvUV(n_digits), MPC_IM(*p), (mpc_rnd_t)SvUV(round) & 3);

     if(out == NULL) croak("An error occurred in _get_i_string(aTHX)");

     /* sp = mark; *//* not needed */
     ST(0) = sv_2mortal(newSVpv(out, 0));
     mpfr_free_str(out);
     ST(1) = sv_2mortal(newSViv(ptr));
     /* PUTBACK; *//* not needed */
     XSRETURN(2);
}


/* ########################################
   ########################################
   ########################################
   ########################################
   ########################################
   ######################################## */



SV * _itsa(pTHX_ SV * a) {
     if(SvUOK(a)) return newSVuv(1);
     if(SvIOK(a)) return newSVuv(2);
     if(SvNOK(a)) return newSVuv(3);
     if(SvPOK(a)) return newSVuv(4);
     if(sv_isobject(a)) {
       const char *h = HvNAME(SvSTASH(SvRV(a)));
       if(strEQ(h, "Math::MPFR")) return newSVuv(5);
       if(strEQ(h, "Math::GMPf")) return newSVuv(6);
       if(strEQ(h, "Math::GMPq")) return newSVuv(7);
       if(strEQ(h, "Math::GMPz")) return newSVuv(8);
       if(strEQ(h, "Math::GMP")) return newSVuv(9);
       if(strEQ(h, "Math::MPC")) return newSVuv(10);
       }
     return newSVuv(0);
}

SV * _new_real(pTHX_ SV * b) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     mpfr_t temp;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in _new_real function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_set_fr(*mpc_t_obj, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(SvIOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_set_fr(*mpc_t_obj, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

#else
     if(SvUOK(b)) {
       mpc_set_ui(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpc_set_si(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_set_ld(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif

     return obj_ref;
     }

     if(SvPOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE & 3))
         croak("Invalid string supplied to Math::MPC::new");
       mpc_set_fr(*mpc_t_obj, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPFR")) {
         mpc_set_fr(*mpc_t_obj, *(INT2PTR(mpfr_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
       if(strEQ(h, "Math::GMPf")) {
         mpc_set_f(*mpc_t_obj, *(INT2PTR(mpf_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
       if(strEQ(h, "Math::GMPq")) {
         mpc_set_q(*mpc_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
       if(strEQ(h, "Math::GMP") ||
          strEQ(h, "Math::GMPz"))  {
         mpc_set_z(*mpc_t_obj, *(INT2PTR(mpz_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
     }

     croak("Invalid argument supplied to Math::MPC::_new_real");
}

SV * _new_im(pTHX_ SV * b) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     mpfr_t temp;
     SV * obj_ref, * obj;
     int ret;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_IM);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE / 16);
#else
       mpfr_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE / 16);
#endif
       VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(SvIOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_IM);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE / 16);
#else
       mpfr_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE / 16);
#endif
       VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

#else
     if(SvUOK(b)) {
       mpc_set_ui_ui(*mpc_t_obj, 0, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpc_set_si_si(*mpc_t_obj, 0, SvIV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_set_ld_ld(*mpc_t_obj, 0, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d_d(*mpc_t_obj, 0, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif

     return obj_ref;
     }

     if(SvPOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_IM);
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE / 16))
         croak("Invalid string supplied to Math::MPC::new");
       VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       const char *h = HvNAME(SvSTASH(SvRV(b)));
       if(strEQ(h, "Math::MPFR")) {
         VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, *(INT2PTR(mpfr_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
       if(strEQ(h, "Math::GMPf")) {
         mpfr_init2(temp, DEFAULT_PREC_IM);
         mpfr_set_f(temp, *(INT2PTR(mpf_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE / 16);
         VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
         mpfr_clear(temp);
         return obj_ref;
       }
       if(strEQ(h, "Math::GMPq")) {
         mpfr_init2(temp, DEFAULT_PREC_IM);
         mpfr_set_q(temp, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE / 16);
         VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
         mpfr_clear(temp);
         return obj_ref;
       }
       if(strEQ(h, "Math::GMP") ||
          strEQ(h, "Math::GMPz"))  {
         mpfr_init2(temp, DEFAULT_PREC_IM);
         mpfr_set_z(temp, *(INT2PTR(mpz_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE / 16);
         VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
         mpfr_clear(temp);
         return obj_ref;
       }
     }

     croak("Invalid argument supplied to Math::MPC::_new_im");
}

int _has_longlong(void) {
#ifdef USE_64_BIT_INT
    return 1;
#else
    return 0;
#endif
}

int _has_longdouble(void) {
#ifdef USE_LONG_DOUBLE
    return 1;
#else
    return 0;
#endif
}

/* Has inttypes.h been included ?
              &&
 Do we have USE_64_BIT_INT ? */

int _has_inttypes() {
#ifdef _MSC_VER
return 0;
#else
#if defined USE_64_BIT_INT
return 1;
#else
return 0;
#endif
#endif
}

SV * gmp_v(pTHX) {
#if __GNU_MP_VERSION >= 4
     return newSVpv(gmp_version, 0);
#else
     warn("From Math::MPC::gmp_v(aTHX): 'gmp_version' is not implemented - returning '0'");
     return newSVpv("0", 0);
#endif
}

SV * mpfr_v(pTHX) {
     return newSVpv(mpfr_get_version(), 0);
}

/* Not yet available
SV * RMPC_MAX_PREC(mpc_t * a) {
     return newSVuv(MPC_MAX_PREC(*a));
}
*/

SV * _MPC_VERSION_MAJOR(pTHX) {
     return newSVuv(MPC_VERSION_MAJOR);
}

SV * _MPC_VERSION_MINOR(pTHX) {
     return newSVuv(MPC_VERSION_MINOR);
}

SV * _MPC_VERSION_PATCHLEVEL(pTHX) {
     return newSVuv(MPC_VERSION_PATCHLEVEL);
}

SV * _MPC_VERSION(pTHX) {
     return newSVuv(MPC_VERSION);
}

SV * _MPC_VERSION_NUM(pTHX_ SV * x, SV * y, SV * z) {
     return newSVuv(MPC_VERSION_NUM((unsigned long)SvUV(x), (unsigned long)SvUV(y), (unsigned long)SvUV(z)));
}

SV * _MPC_VERSION_STRING(pTHX) {
     return newSVpv(MPC_VERSION_STRING, 0);
}

SV * Rmpc_get_version(pTHX) {
     return newSVpv(mpc_get_version(), 0);
}

SV * Rmpc_real(pTHX_ mpfr_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_real(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_imag(pTHX_ mpfr_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_imag(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_arg(pTHX_ mpfr_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_arg(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_proj(pTHX_ mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_proj(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_get_str(pTHX_ SV * base, SV * dig, mpc_t * op, SV * round) {
     char * out;
     SV * outsv;
     out = mpc_get_str((int)SvIV(base), (size_t)SvUV(dig), *op, (mpc_rnd_t)SvUV(round));
     outsv = newSVpv(out, 0);
     mpc_free_str(out);
     return outsv;
}

SV * Rmpc_set_str(pTHX_ mpc_t * rop, SV * str, SV * base, SV * round) {
     return newSViv(mpc_set_str(*rop, SvPV_nolen(str), (int)SvIV(base), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_strtoc(pTHX_ mpc_t * rop, SV * str, SV * base, SV * round) {
     return newSViv(mpc_strtoc(*rop, SvPV_nolen(str), NULL, (int)SvIV(base), (mpc_rnd_t)SvUV(round)));
}

void Rmpc_set_nan(mpc_t * a) {
     mpc_set_nan(*a);
}

void Rmpc_swap(mpc_t * a, mpc_t * b) {
     mpc_swap(*a, *b);
}

/* atan2(x, y) = atan(x / y) */
SV * overload_atan2(pTHX_ mpc_t * p, mpc_t * q, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_atan2 function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_div(*mpc_t_obj, *p, *q, DEFAULT_ROUNDING_MODE);

     mpc_atan(*mpc_t_obj, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpc_sin_cos(pTHX_ mpc_t * rop_sin, mpc_t * rop_cos, mpc_t * op, SV * rnd_sin, SV * rnd_cos) {
#ifdef SIN_COS_AVAILABLE
     return newSViv(mpc_sin_cos(*rop_sin, *rop_cos, *op, (mpc_rnd_t)SvUV(rnd_sin), (mpc_rnd_t)SvUV(rnd_cos)));
#else
     croak("Rmpc_­sin_cos() not supported by your version (%s) of the mpc library", MPC_VERSION_STRING);
#endif
}

void Rmpc_get_dc(pTHX_ SV * crop, mpc_t * op, SV * round) {
#ifdef _DO_COMPLEX_H
     if(sv_isobject(crop)) {
       const char *h = HvNAME(SvSTASH(SvRV(crop)));
       if(strNE(h, "Math::Complex_C"))
         croak("1st arg to Rmpc_get_dc is a %s object - needs to be a Math::Complex_C object", h);
     }
     else croak("1st arg to Rmpc_get_dc needs to be a Math::Complex_C object");
     *(INT2PTR(double _Complex *, SvIV(SvRV(crop)))) = mpc_get_dc(*op, (mpc_rnd_t)SvUV(round));
#else
     croak("Rmpc_get_dc(aTHX) not implemented");
#endif
}

void Rmpc_get_ldc(pTHX_ SV * crop, mpc_t * op, SV * round) {
#ifdef _DO_COMPLEX_H
     if(sv_isobject(crop)) {
       const char *h = HvNAME(SvSTASH(SvRV(crop)));
       if(strNE(h, "Math::Complex_C::Long"))
         croak("1st arg to Rmpc_get_ldc is a %s object - needs to be a Math::Complex_C::Long object", h);
     }
     else croak("1st arg to Rmpc_get_ldc needs to be a Math::Complex_C::Long object");
     *(INT2PTR(long double _Complex *, SvIV(SvRV(crop)))) = mpc_get_ldc(*op, (mpc_rnd_t)SvUV(round));
#else
     croak("Rmpc_get_ldc(aTHX) not implemented");
#endif
}

SV * Rmpc_set_dc(pTHX_ mpc_t * op, SV * crop, SV * round) {
#ifdef _DO_COMPLEX_H
     if(sv_isobject(crop)) {
       const char *h = HvNAME(SvSTASH(SvRV(crop)));
       if(strNE(h, "Math::Complex_C"))
         croak("2nd arg to Rmpc_set_dc is a %s object - needs to be a Math::Complex_C object", h);
     }
     else croak("2nd arg to Rmpc_set_dc needs to be a Math::Complex_C object");
     return newSViv(mpc_set_dc(*op, *(INT2PTR(double _Complex *, SvIV(SvRV(crop)))), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_dc(aTHX) not implemented");
#endif
}

SV * Rmpc_set_ldc(pTHX_ mpc_t * op, SV * crop, SV * round) {
#ifdef _DO_COMPLEX_H
     if(sv_isobject(crop)) {
       const char *h = HvNAME(SvSTASH(SvRV(crop)));
       if(strNE(h, "Math::Complex_C::Long"))
       croak("2nd arg to Rmpc_set_ldc is a %s object - needs ti be a Math::Complex_C::Long object", h);
     }
     else croak("2nd arg to Rmpc_set_ldc needs to be a Math::Complex_C::Long object");
     return newSViv(mpc_set_ldc(*op, *(INT2PTR(long double _Complex *, SvIV(SvRV(crop)))), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_ldc(aTHX) not implemented");
#endif
}

int _have_Complex_h(void) {
#ifdef _DO_COMPLEX_H
     return 1;
#else
     return 0;
#endif
}

SV * _mpfr_buildopt_tls_p(pTHX) {
#if MPFR_VERSION_MAJOR >= 3
     return newSViv(mpfr_buildopt_tls_p());
#else
     croak("Math::MPC::_mpfr_buildopt_tls_p not implemented with this version of the mpfr library - we have %s but need at least 3.0.0", MPFR_VERSION_STRING);
#endif
}

SV * _get_xs_version(pTHX) {
     return newSVpv(XS_VERSION, 0);
}

SV * _wrap_count(pTHX) {
     return newSVuv(PL_sv_count);
}

/* Beginning mpc-1.0, mpc_mul_2si and mpc_div_2si were added */

SV * Rmpc_mul_2si(pTHX_ mpc_t * a, mpc_t * b, SV * c, SV * round) {
#if MPC_VERSION >= 65536
     return newSViv(mpc_mul_2si(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
# else
     croak("mpc_mul_2si not implemented until mpc-1.0. We have version %d", MPC_VERSION);
#endif
}

SV * Rmpc_div_2si(pTHX_ mpc_t * a, mpc_t * b, SV * c, SV * round) {
#if MPC_VERSION >= 65536
     return newSViv(mpc_div_2si(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
# else
     croak("mpc_div_2si not implemented until mpc-1.0. We have version %d", MPC_VERSION);
#endif
}

SV * Rmpc_log10(pTHX_ mpc_t * rop, mpc_t *op, SV * round) {
#if MPC_VERSION >= 65536
     return newSViv(mpc_log10(*rop, *op, (mpc_rnd_t)SvUV(round)));
# else
     croak("mpc_log10 not implemented until mpc-1.0. We have version %d", MPC_VERSION);
#endif
}

/* I think the CLONE function needs to come at the very end ... not sure */

void CLONE(pTHX_ SV * x, ...) {
   MY_CXT_CLONE;
}



MODULE = Math::MPC  PACKAGE = Math::MPC

PROTOTYPES: DISABLE


int
_mpc_mul_sj (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	intmax_t	i
	mpc_rnd_t	rnd

int
_mpc_mul_ld (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	long double	i
	mpc_rnd_t	rnd

int
_mpc_mul_d (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	double	i
	mpc_rnd_t	rnd

int
_mpc_div_sj (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	intmax_t	i
	mpc_rnd_t	rnd

int
_mpc_sj_div (rop, i, op, rnd)
	mpc_ptr	rop
	intmax_t	i
	mpc_ptr	op
	mpc_rnd_t	rnd

int
_mpc_div_ld (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	long double	i
	mpc_rnd_t	rnd

int
_mpc_ld_div (rop, i, op, rnd)
	mpc_ptr	rop
	long double	i
	mpc_ptr	op
	mpc_rnd_t	rnd

int
_mpc_div_d (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	double	i
	mpc_rnd_t	rnd

int
_mpc_d_div (rop, i, op, rnd)
	mpc_ptr	rop
	double	i
	mpc_ptr	op
	mpc_rnd_t	rnd

void
Rmpc_set_default_rounding_mode (round)
	SV *	round
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_set_default_rounding_mode(aTHX_ round);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

SV *
Rmpc_get_default_rounding_mode ()
CODE:
  RETVAL = Rmpc_get_default_rounding_mode (aTHX);
OUTPUT:  RETVAL


void
Rmpc_set_default_prec (prec)
	SV *	prec
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_set_default_prec(aTHX_ prec);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpc_set_default_prec2 (prec_re, prec_im)
	SV *	prec_re
	SV *	prec_im
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_set_default_prec2(aTHX_ prec_re, prec_im);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

SV *
Rmpc_get_default_prec ()
CODE:
  RETVAL = Rmpc_get_default_prec (aTHX);
OUTPUT:  RETVAL


void
Rmpc_get_default_prec2 ()

        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_get_default_prec2();
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpc_set_prec (p, prec)
	mpc_t *	p
	SV *	prec
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_set_prec(aTHX_ p, prec);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpc_set_re_prec (p, prec)
	mpc_t *	p
	SV *	prec
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_set_re_prec(aTHX_ p, prec);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpc_set_im_prec (p, prec)
	mpc_t *	p
	SV *	prec
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_set_im_prec(aTHX_ p, prec);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

SV *
Rmpc_get_prec (x)
	mpc_t *	x
CODE:
  RETVAL = Rmpc_get_prec (aTHX_ x);
OUTPUT:  RETVAL

void
Rmpc_get_prec2 (x)
	mpc_t *	x
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_get_prec2(aTHX_ x);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

SV *
Rmpc_get_im_prec (x)
	mpc_t *	x
CODE:
  RETVAL = Rmpc_get_im_prec (aTHX_ x);
OUTPUT:  RETVAL

SV *
Rmpc_get_re_prec (x)
	mpc_t *	x
CODE:
  RETVAL = Rmpc_get_re_prec (aTHX_ x);
OUTPUT:  RETVAL

void
RMPC_RE (fr, x)
	mpfr_t *	fr
	mpc_t *	x
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        RMPC_RE(fr, x);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
RMPC_IM (fr, x)
	mpfr_t *	fr
	mpc_t *	x
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        RMPC_IM(fr, x);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

SV *
RMPC_INEX_RE (x)
	SV *	x
CODE:
  RETVAL = RMPC_INEX_RE (aTHX_ x);
OUTPUT:  RETVAL

SV *
RMPC_INEX_IM (x)
	SV *	x
CODE:
  RETVAL = RMPC_INEX_IM (aTHX_ x);
OUTPUT:  RETVAL

void
DESTROY (p)
	mpc_t *	p
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        DESTROY(aTHX_ p);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpc_clear (p)
	mpc_t *	p
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_clear(aTHX_ p);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpc_clear_mpc (p)
	mpc_t *	p
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_clear_mpc(p);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpc_clear_ptr (p)
	mpc_t *	p
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_clear_ptr(aTHX_ p);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

SV *
Rmpc_init2 (prec)
	SV *	prec
CODE:
  RETVAL = Rmpc_init2 (aTHX_ prec);
OUTPUT:  RETVAL

SV *
Rmpc_init3 (prec_r, prec_i)
	SV *	prec_r
	SV *	prec_i
CODE:
  RETVAL = Rmpc_init3 (aTHX_ prec_r, prec_i);
OUTPUT:  RETVAL

SV *
Rmpc_init2_nobless (prec)
	SV *	prec
CODE:
  RETVAL = Rmpc_init2_nobless (aTHX_ prec);
OUTPUT:  RETVAL

SV *
Rmpc_init3_nobless (prec_r, prec_i)
	SV *	prec_r
	SV *	prec_i
CODE:
  RETVAL = Rmpc_init3_nobless (aTHX_ prec_r, prec_i);
OUTPUT:  RETVAL

SV *
Rmpc_set (p, q, round)
	mpc_t *	p
	mpc_t *	q
	SV *	round
CODE:
  RETVAL = Rmpc_set (aTHX_ p, q, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ui (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round
CODE:
  RETVAL = Rmpc_set_ui (aTHX_ p, q, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_si (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round
CODE:
  RETVAL = Rmpc_set_si (aTHX_ p, q, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ld (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round
CODE:
  RETVAL = Rmpc_set_ld (aTHX_ p, q, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_uj (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round
CODE:
  RETVAL = Rmpc_set_uj (aTHX_ p, q, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_sj (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round
CODE:
  RETVAL = Rmpc_set_sj (aTHX_ p, q, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_z (p, q, round)
	mpc_t *	p
	mpz_t *	q
	SV *	round
CODE:
  RETVAL = Rmpc_set_z (aTHX_ p, q, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_f (p, q, round)
	mpc_t *	p
	mpf_t *	q
	SV *	round
CODE:
  RETVAL = Rmpc_set_f (aTHX_ p, q, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_q (p, q, round)
	mpc_t *	p
	mpq_t *	q
	SV *	round
CODE:
  RETVAL = Rmpc_set_q (aTHX_ p, q, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_d (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round
CODE:
  RETVAL = Rmpc_set_d (aTHX_ p, q, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_fr (p, q, round)
	mpc_t *	p
	mpfr_t *	q
	SV *	round
CODE:
  RETVAL = Rmpc_set_fr (aTHX_ p, q, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ui_ui (p, q_r, q_i, round)
	mpc_t *	p
	SV *	q_r
	SV *	q_i
	SV *	round
CODE:
  RETVAL = Rmpc_set_ui_ui (aTHX_ p, q_r, q_i, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_si_si (p, q_r, q_i, round)
	mpc_t *	p
	SV *	q_r
	SV *	q_i
	SV *	round
CODE:
  RETVAL = Rmpc_set_si_si (aTHX_ p, q_r, q_i, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_d_d (p, q_r, q_i, round)
	mpc_t *	p
	SV *	q_r
	SV *	q_i
	SV *	round
CODE:
  RETVAL = Rmpc_set_d_d (aTHX_ p, q_r, q_i, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ld_ld (mpc, ld1, ld2, round)
	mpc_t *	mpc
	SV *	ld1
	SV *	ld2
	SV *	round
CODE:
  RETVAL = Rmpc_set_ld_ld (aTHX_ mpc, ld1, ld2, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_z_z (p, q_r, q_i, round)
	mpc_t *	p
	mpz_t *	q_r
	mpz_t *	q_i
	SV *	round
CODE:
  RETVAL = Rmpc_set_z_z (aTHX_ p, q_r, q_i, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_q_q (p, q_r, q_i, round)
	mpc_t *	p
	mpq_t *	q_r
	mpq_t *	q_i
	SV *	round
CODE:
  RETVAL = Rmpc_set_q_q (aTHX_ p, q_r, q_i, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_f_f (p, q_r, q_i, round)
	mpc_t *	p
	mpf_t *	q_r
	mpf_t *	q_i
	SV *	round
CODE:
  RETVAL = Rmpc_set_f_f (aTHX_ p, q_r, q_i, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_fr_fr (p, q_r, q_i, round)
	mpc_t *	p
	mpfr_t *	q_r
	mpfr_t *	q_i
	SV *	round
CODE:
  RETVAL = Rmpc_set_fr_fr (aTHX_ p, q_r, q_i, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_d_ui (mpc, d, ui, round)
	mpc_t *	mpc
	SV *	d
	SV *	ui
	SV *	round
CODE:
  RETVAL = Rmpc_set_d_ui (aTHX_ mpc, d, ui, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_d_si (mpc, d, si, round)
	mpc_t *	mpc
	SV *	d
	SV *	si
	SV *	round
CODE:
  RETVAL = Rmpc_set_d_si (aTHX_ mpc, d, si, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_d_fr (mpc, d, mpfr, round)
	mpc_t *	mpc
	SV *	d
	mpfr_t *	mpfr
	SV *	round
CODE:
  RETVAL = Rmpc_set_d_fr (aTHX_ mpc, d, mpfr, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ui_d (mpc, ui, d, round)
	mpc_t *	mpc
	SV *	ui
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_ui_d (aTHX_ mpc, ui, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ui_si (mpc, ui, si, round)
	mpc_t *	mpc
	SV *	ui
	SV *	si
	SV *	round
CODE:
  RETVAL = Rmpc_set_ui_si (aTHX_ mpc, ui, si, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ui_fr (mpc, ui, mpfr, round)
	mpc_t *	mpc
	SV *	ui
	mpfr_t *	mpfr
	SV *	round
CODE:
  RETVAL = Rmpc_set_ui_fr (aTHX_ mpc, ui, mpfr, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_si_d (mpc, si, d, round)
	mpc_t *	mpc
	SV *	si
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_si_d (aTHX_ mpc, si, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_si_ui (mpc, si, ui, round)
	mpc_t *	mpc
	SV *	si
	SV *	ui
	SV *	round
CODE:
  RETVAL = Rmpc_set_si_ui (aTHX_ mpc, si, ui, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_si_fr (mpc, si, mpfr, round)
	mpc_t *	mpc
	SV *	si
	mpfr_t *	mpfr
	SV *	round
CODE:
  RETVAL = Rmpc_set_si_fr (aTHX_ mpc, si, mpfr, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_fr_d (mpc, mpfr, d, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_fr_d (aTHX_ mpc, mpfr, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_fr_ui (mpc, mpfr, ui, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	ui
	SV *	round
CODE:
  RETVAL = Rmpc_set_fr_ui (aTHX_ mpc, mpfr, ui, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_fr_si (mpc, mpfr, si, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	si
	SV *	round
CODE:
  RETVAL = Rmpc_set_fr_si (aTHX_ mpc, mpfr, si, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ld_ui (mpc, d, ui, round)
	mpc_t *	mpc
	SV *	d
	SV *	ui
	SV *	round
CODE:
  RETVAL = Rmpc_set_ld_ui (aTHX_ mpc, d, ui, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ld_si (mpc, d, si, round)
	mpc_t *	mpc
	SV *	d
	SV *	si
	SV *	round
CODE:
  RETVAL = Rmpc_set_ld_si (aTHX_ mpc, d, si, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ld_fr (mpc, d, mpfr, round)
	mpc_t *	mpc
	SV *	d
	mpfr_t *	mpfr
	SV *	round
CODE:
  RETVAL = Rmpc_set_ld_fr (aTHX_ mpc, d, mpfr, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ui_ld (mpc, ui, d, round)
	mpc_t *	mpc
	SV *	ui
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_ui_ld (aTHX_ mpc, ui, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_si_ld (mpc, si, d, round)
	mpc_t *	mpc
	SV *	si
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_si_ld (aTHX_ mpc, si, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_fr_ld (mpc, mpfr, d, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_fr_ld (aTHX_ mpc, mpfr, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_d_uj (mpc, d, ui, round)
	mpc_t *	mpc
	SV *	d
	SV *	ui
	SV *	round
CODE:
  RETVAL = Rmpc_set_d_uj (aTHX_ mpc, d, ui, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_d_sj (mpc, d, si, round)
	mpc_t *	mpc
	SV *	d
	SV *	si
	SV *	round
CODE:
  RETVAL = Rmpc_set_d_sj (aTHX_ mpc, d, si, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_sj_d (mpc, si, d, round)
	mpc_t *	mpc
	SV *	si
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_sj_d (aTHX_ mpc, si, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_uj_d (mpc, ui, d, round)
	mpc_t *	mpc
	SV *	ui
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_uj_d (aTHX_ mpc, ui, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_uj_fr (mpc, ui, mpfr, round)
	mpc_t *	mpc
	SV *	ui
	mpfr_t *	mpfr
	SV *	round
CODE:
  RETVAL = Rmpc_set_uj_fr (aTHX_ mpc, ui, mpfr, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_sj_fr (mpc, si, mpfr, round)
	mpc_t *	mpc
	SV *	si
	mpfr_t *	mpfr
	SV *	round
CODE:
  RETVAL = Rmpc_set_sj_fr (aTHX_ mpc, si, mpfr, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_fr_uj (mpc, mpfr, ui, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	ui
	SV *	round
CODE:
  RETVAL = Rmpc_set_fr_uj (aTHX_ mpc, mpfr, ui, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_fr_sj (mpc, mpfr, si, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	si
	SV *	round
CODE:
  RETVAL = Rmpc_set_fr_sj (aTHX_ mpc, mpfr, si, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_uj_sj (mpc, ui, si, round)
	mpc_t *	mpc
	SV *	ui
	SV *	si
	SV *	round
CODE:
  RETVAL = Rmpc_set_uj_sj (aTHX_ mpc, ui, si, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_sj_uj (mpc, si, ui, round)
	mpc_t *	mpc
	SV *	si
	SV *	ui
	SV *	round
CODE:
  RETVAL = Rmpc_set_sj_uj (aTHX_ mpc, si, ui, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ld_uj (mpc, d, ui, round)
	mpc_t *	mpc
	SV *	d
	SV *	ui
	SV *	round
CODE:
  RETVAL = Rmpc_set_ld_uj (aTHX_ mpc, d, ui, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ld_sj (mpc, d, si, round)
	mpc_t *	mpc
	SV *	d
	SV *	si
	SV *	round
CODE:
  RETVAL = Rmpc_set_ld_sj (aTHX_ mpc, d, si, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_uj_ld (mpc, ui, d, round)
	mpc_t *	mpc
	SV *	ui
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_uj_ld (aTHX_ mpc, ui, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_sj_ld (mpc, si, d, round)
	mpc_t *	mpc
	SV *	si
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_sj_ld (aTHX_ mpc, si, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_f_ui (mpc, mpf, ui, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	ui
	SV *	round
CODE:
  RETVAL = Rmpc_set_f_ui (aTHX_ mpc, mpf, ui, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_q_ui (mpc, mpq, ui, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	ui
	SV *	round
CODE:
  RETVAL = Rmpc_set_q_ui (aTHX_ mpc, mpq, ui, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_z_ui (mpc, mpz, ui, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	ui
	SV *	round
CODE:
  RETVAL = Rmpc_set_z_ui (aTHX_ mpc, mpz, ui, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_f_si (mpc, mpf, si, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	si
	SV *	round
CODE:
  RETVAL = Rmpc_set_f_si (aTHX_ mpc, mpf, si, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_q_si (mpc, mpq, si, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	si
	SV *	round
CODE:
  RETVAL = Rmpc_set_q_si (aTHX_ mpc, mpq, si, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_z_si (mpc, mpz, si, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	si
	SV *	round
CODE:
  RETVAL = Rmpc_set_z_si (aTHX_ mpc, mpz, si, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_f_d (mpc, mpf, d, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_f_d (aTHX_ mpc, mpf, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_q_d (mpc, mpq, d, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_q_d (aTHX_ mpc, mpq, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_z_d (mpc, mpz, d, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	d
	SV *	round
CODE:
  RETVAL = Rmpc_set_z_d (aTHX_ mpc, mpz, d, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_f_uj (mpc, mpf, uj, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	uj
	SV *	round
CODE:
  RETVAL = Rmpc_set_f_uj (aTHX_ mpc, mpf, uj, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_q_uj (mpc, mpq, uj, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	uj
	SV *	round
CODE:
  RETVAL = Rmpc_set_q_uj (aTHX_ mpc, mpq, uj, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_z_uj (mpc, mpz, uj, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	uj
	SV *	round
CODE:
  RETVAL = Rmpc_set_z_uj (aTHX_ mpc, mpz, uj, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_f_sj (mpc, mpf, sj, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	sj
	SV *	round
CODE:
  RETVAL = Rmpc_set_f_sj (aTHX_ mpc, mpf, sj, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_q_sj (mpc, mpq, sj, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	sj
	SV *	round
CODE:
  RETVAL = Rmpc_set_q_sj (aTHX_ mpc, mpq, sj, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_z_sj (mpc, mpz, sj, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	sj
	SV *	round
CODE:
  RETVAL = Rmpc_set_z_sj (aTHX_ mpc, mpz, sj, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_f_ld (mpc, mpf, ld, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	ld
	SV *	round
CODE:
  RETVAL = Rmpc_set_f_ld (aTHX_ mpc, mpf, ld, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_q_ld (mpc, mpq, ld, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	ld
	SV *	round
CODE:
  RETVAL = Rmpc_set_q_ld (aTHX_ mpc, mpq, ld, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_z_ld (mpc, mpz, ld, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	ld
	SV *	round
CODE:
  RETVAL = Rmpc_set_z_ld (aTHX_ mpc, mpz, ld, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ui_f (mpc, ui, mpf, round)
	mpc_t *	mpc
	SV *	ui
	mpf_t *	mpf
	SV *	round
CODE:
  RETVAL = Rmpc_set_ui_f (aTHX_ mpc, ui, mpf, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ui_q (mpc, ui, mpq, round)
	mpc_t *	mpc
	SV *	ui
	mpq_t *	mpq
	SV *	round
CODE:
  RETVAL = Rmpc_set_ui_q (aTHX_ mpc, ui, mpq, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ui_z (mpc, ui, mpz, round)
	mpc_t *	mpc
	SV *	ui
	mpz_t *	mpz
	SV *	round
CODE:
  RETVAL = Rmpc_set_ui_z (aTHX_ mpc, ui, mpz, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_si_f (mpc, si, mpf, round)
	mpc_t *	mpc
	SV *	si
	mpf_t *	mpf
	SV *	round
CODE:
  RETVAL = Rmpc_set_si_f (aTHX_ mpc, si, mpf, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_si_q (mpc, si, mpq, round)
	mpc_t *	mpc
	SV *	si
	mpq_t *	mpq
	SV *	round
CODE:
  RETVAL = Rmpc_set_si_q (aTHX_ mpc, si, mpq, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_si_z (mpc, si, mpz, round)
	mpc_t *	mpc
	SV *	si
	mpz_t *	mpz
	SV *	round
CODE:
  RETVAL = Rmpc_set_si_z (aTHX_ mpc, si, mpz, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_d_f (mpc, d, mpf, round)
	mpc_t *	mpc
	SV *	d
	mpf_t *	mpf
	SV *	round
CODE:
  RETVAL = Rmpc_set_d_f (aTHX_ mpc, d, mpf, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_d_q (mpc, d, mpq, round)
	mpc_t *	mpc
	SV *	d
	mpq_t *	mpq
	SV *	round
CODE:
  RETVAL = Rmpc_set_d_q (aTHX_ mpc, d, mpq, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_d_z (mpc, d, mpz, round)
	mpc_t *	mpc
	SV *	d
	mpz_t *	mpz
	SV *	round
CODE:
  RETVAL = Rmpc_set_d_z (aTHX_ mpc, d, mpz, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_uj_f (mpc, uj, mpf, round)
	mpc_t *	mpc
	SV *	uj
	mpf_t *	mpf
	SV *	round
CODE:
  RETVAL = Rmpc_set_uj_f (aTHX_ mpc, uj, mpf, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_uj_q (mpc, uj, mpq, round)
	mpc_t *	mpc
	SV *	uj
	mpq_t *	mpq
	SV *	round
CODE:
  RETVAL = Rmpc_set_uj_q (aTHX_ mpc, uj, mpq, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_uj_z (mpc, uj, mpz, round)
	mpc_t *	mpc
	SV *	uj
	mpz_t *	mpz
	SV *	round
CODE:
  RETVAL = Rmpc_set_uj_z (aTHX_ mpc, uj, mpz, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_sj_f (mpc, sj, mpf, round)
	mpc_t *	mpc
	SV *	sj
	mpf_t *	mpf
	SV *	round
CODE:
  RETVAL = Rmpc_set_sj_f (aTHX_ mpc, sj, mpf, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_sj_q (mpc, sj, mpq, round)
	mpc_t *	mpc
	SV *	sj
	mpq_t *	mpq
	SV *	round
CODE:
  RETVAL = Rmpc_set_sj_q (aTHX_ mpc, sj, mpq, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_sj_z (mpc, sj, mpz, round)
	mpc_t *	mpc
	SV *	sj
	mpz_t *	mpz
	SV *	round
CODE:
  RETVAL = Rmpc_set_sj_z (aTHX_ mpc, sj, mpz, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ld_f (mpc, ld, mpf, round)
	mpc_t *	mpc
	SV *	ld
	mpf_t *	mpf
	SV *	round
CODE:
  RETVAL = Rmpc_set_ld_f (aTHX_ mpc, ld, mpf, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ld_q (mpc, ld, mpq, round)
	mpc_t *	mpc
	SV *	ld
	mpq_t *	mpq
	SV *	round
CODE:
  RETVAL = Rmpc_set_ld_q (aTHX_ mpc, ld, mpq, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ld_z (mpc, ld, mpz, round)
	mpc_t *	mpc
	SV *	ld
	mpz_t *	mpz
	SV *	round
CODE:
  RETVAL = Rmpc_set_ld_z (aTHX_ mpc, ld, mpz, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_f_q (mpc, mpf, mpq, round)
	mpc_t *	mpc
	mpf_t *	mpf
	mpq_t *	mpq
	SV *	round
CODE:
  RETVAL = Rmpc_set_f_q (aTHX_ mpc, mpf, mpq, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_q_f (mpc, mpq, mpf, round)
	mpc_t *	mpc
	mpq_t *	mpq
	mpf_t *	mpf
	SV *	round
CODE:
  RETVAL = Rmpc_set_q_f (aTHX_ mpc, mpq, mpf, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_f_z (mpc, mpf, mpz, round)
	mpc_t *	mpc
	mpf_t *	mpf
	mpz_t *	mpz
	SV *	round
CODE:
  RETVAL = Rmpc_set_f_z (aTHX_ mpc, mpf, mpz, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_z_f (mpc, mpz, mpf, round)
	mpc_t *	mpc
	mpz_t *	mpz
	mpf_t *	mpf
	SV *	round
CODE:
  RETVAL = Rmpc_set_z_f (aTHX_ mpc, mpz, mpf, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_q_z (mpc, mpq, mpz, round)
	mpc_t *	mpc
	mpq_t *	mpq
	mpz_t *	mpz
	SV *	round
CODE:
  RETVAL = Rmpc_set_q_z (aTHX_ mpc, mpq, mpz, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_z_q (mpc, mpz, mpq, round)
	mpc_t *	mpc
	mpz_t *	mpz
	mpq_t *	mpq
	SV *	round
CODE:
  RETVAL = Rmpc_set_z_q (aTHX_ mpc, mpz, mpq, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_f_fr (mpc, mpf, mpfr, round)
	mpc_t *	mpc
	mpf_t *	mpf
	mpfr_t *	mpfr
	SV *	round
CODE:
  RETVAL = Rmpc_set_f_fr (aTHX_ mpc, mpf, mpfr, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_fr_f (mpc, mpfr, mpf, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	mpf_t *	mpf
	SV *	round
CODE:
  RETVAL = Rmpc_set_fr_f (aTHX_ mpc, mpfr, mpf, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_q_fr (mpc, mpq, mpfr, round)
	mpc_t *	mpc
	mpq_t *	mpq
	mpfr_t *	mpfr
	SV *	round
CODE:
  RETVAL = Rmpc_set_q_fr (aTHX_ mpc, mpq, mpfr, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_fr_q (mpc, mpfr, mpq, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	mpq_t *	mpq
	SV *	round
CODE:
  RETVAL = Rmpc_set_fr_q (aTHX_ mpc, mpfr, mpq, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_z_fr (mpc, mpz, mpfr, round)
	mpc_t *	mpc
	mpz_t *	mpz
	mpfr_t *	mpfr
	SV *	round
CODE:
  RETVAL = Rmpc_set_z_fr (aTHX_ mpc, mpz, mpfr, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_fr_z (mpc, mpfr, mpz, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	mpz_t *	mpz
	SV *	round
CODE:
  RETVAL = Rmpc_set_fr_z (aTHX_ mpc, mpfr, mpz, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_uj_uj (mpc, uj1, uj2, round)
	mpc_t *	mpc
	SV *	uj1
	SV *	uj2
	SV *	round
CODE:
  RETVAL = Rmpc_set_uj_uj (aTHX_ mpc, uj1, uj2, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_sj_sj (mpc, sj1, sj2, round)
	mpc_t *	mpc
	SV *	sj1
	SV *	sj2
	SV *	round
CODE:
  RETVAL = Rmpc_set_sj_sj (aTHX_ mpc, sj1, sj2, round);
OUTPUT:  RETVAL

SV *
Rmpc_add (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpc_t *	c
	SV *	round
CODE:
  RETVAL = Rmpc_add (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_add_ui (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round
CODE:
  RETVAL = Rmpc_add_ui (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_add_fr (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpfr_t *	c
	SV *	round
CODE:
  RETVAL = Rmpc_add_fr (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_sub (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpc_t *	c
	SV *	round
CODE:
  RETVAL = Rmpc_sub (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_sub_ui (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round
CODE:
  RETVAL = Rmpc_sub_ui (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_ui_sub (a, b, c, round)
	mpc_t *	a
	SV *	b
	mpc_t *	c
	SV *	round
CODE:
  RETVAL = Rmpc_ui_sub (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_ui_ui_sub (a, b_r, b_i, c, round)
	mpc_t *	a
	SV *	b_r
	SV *	b_i
	mpc_t *	c
	SV *	round
CODE:
  RETVAL = Rmpc_ui_ui_sub (aTHX_ a, b_r, b_i, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_mul (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpc_t *	c
	SV *	round
CODE:
  RETVAL = Rmpc_mul (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_mul_ui (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round
CODE:
  RETVAL = Rmpc_mul_ui (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_mul_si (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round
CODE:
  RETVAL = Rmpc_mul_si (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_mul_fr (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpfr_t *	c
	SV *	round
CODE:
  RETVAL = Rmpc_mul_fr (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_mul_i (a, b, sign, round)
	mpc_t *	a
	mpc_t *	b
	SV *	sign
	SV *	round
CODE:
  RETVAL = Rmpc_mul_i (aTHX_ a, b, sign, round);
OUTPUT:  RETVAL

SV *
Rmpc_sqr (a, b, round)
	mpc_t *	a
	mpc_t *	b
	SV *	round
CODE:
  RETVAL = Rmpc_sqr (aTHX_ a, b, round);
OUTPUT:  RETVAL

SV *
Rmpc_div (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpc_t *	c
	SV *	round
CODE:
  RETVAL = Rmpc_div (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_div_ui (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round
CODE:
  RETVAL = Rmpc_div_ui (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_ui_div (a, b, c, round)
	mpc_t *	a
	SV *	b
	mpc_t *	c
	SV *	round
CODE:
  RETVAL = Rmpc_ui_div (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_div_fr (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpfr_t *	c
	SV *	round
CODE:
  RETVAL = Rmpc_div_fr (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_sqrt (a, b, round)
	mpc_t *	a
	mpc_t *	b
	SV *	round
CODE:
  RETVAL = Rmpc_sqrt (aTHX_ a, b, round);
OUTPUT:  RETVAL

SV *
Rmpc_pow (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	mpc_t *	pow
	SV *	round
CODE:
  RETVAL = Rmpc_pow (aTHX_ a, b, pow, round);
OUTPUT:  RETVAL

SV *
Rmpc_pow_d (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	SV *	pow
	SV *	round
CODE:
  RETVAL = Rmpc_pow_d (aTHX_ a, b, pow, round);
OUTPUT:  RETVAL

SV *
Rmpc_pow_ld (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	SV *	pow
	SV *	round
CODE:
  RETVAL = Rmpc_pow_ld (aTHX_ a, b, pow, round);
OUTPUT:  RETVAL

SV *
Rmpc_pow_si (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	SV *	pow
	SV *	round
CODE:
  RETVAL = Rmpc_pow_si (aTHX_ a, b, pow, round);
OUTPUT:  RETVAL

SV *
Rmpc_pow_ui (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	SV *	pow
	SV *	round
CODE:
  RETVAL = Rmpc_pow_ui (aTHX_ a, b, pow, round);
OUTPUT:  RETVAL

SV *
Rmpc_pow_z (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	mpz_t *	pow
	SV *	round
CODE:
  RETVAL = Rmpc_pow_z (aTHX_ a, b, pow, round);
OUTPUT:  RETVAL

SV *
Rmpc_pow_fr (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	mpfr_t *	pow
	SV *	round
CODE:
  RETVAL = Rmpc_pow_fr (aTHX_ a, b, pow, round);
OUTPUT:  RETVAL

SV *
Rmpc_neg (a, b, round)
	mpc_t *	a
	mpc_t *	b
	SV *	round
CODE:
  RETVAL = Rmpc_neg (aTHX_ a, b, round);
OUTPUT:  RETVAL

SV *
Rmpc_abs (a, b, round)
	mpfr_t *	a
	mpc_t *	b
	SV *	round
CODE:
  RETVAL = Rmpc_abs (aTHX_ a, b, round);
OUTPUT:  RETVAL

SV *
Rmpc_conj (a, b, round)
	mpc_t *	a
	mpc_t *	b
	SV *	round
CODE:
  RETVAL = Rmpc_conj (aTHX_ a, b, round);
OUTPUT:  RETVAL

SV *
Rmpc_norm (a, b, round)
	mpfr_t *	a
	mpc_t *	b
	SV *	round
CODE:
  RETVAL = Rmpc_norm (aTHX_ a, b, round);
OUTPUT:  RETVAL

SV *
Rmpc_mul_2ui (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round
CODE:
  RETVAL = Rmpc_mul_2ui (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_div_2ui (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round
CODE:
  RETVAL = Rmpc_div_2ui (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_cmp (a, b)
	mpc_t *	a
	mpc_t *	b
CODE:
  RETVAL = Rmpc_cmp (aTHX_ a, b);
OUTPUT:  RETVAL

SV *
Rmpc_cmp_si (a, b)
	mpc_t *	a
	SV *	b
CODE:
  RETVAL = Rmpc_cmp_si (aTHX_ a, b);
OUTPUT:  RETVAL

SV *
Rmpc_cmp_si_si (a, b, c)
	mpc_t *	a
	SV *	b
	SV *	c
CODE:
  RETVAL = Rmpc_cmp_si_si (aTHX_ a, b, c);
OUTPUT:  RETVAL

SV *
Rmpc_exp (a, b, round)
	mpc_t *	a
	mpc_t *	b
	SV *	round
CODE:
  RETVAL = Rmpc_exp (aTHX_ a, b, round);
OUTPUT:  RETVAL

SV *
Rmpc_log (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_log (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
_Rmpc_out_str (stream, base, dig, p, round)
	FILE *	stream
	SV *	base
	SV *	dig
	mpc_t *	p
	SV *	round
CODE:
  RETVAL = _Rmpc_out_str (aTHX_ stream, base, dig, p, round);
OUTPUT:  RETVAL

SV *
_Rmpc_out_strS (stream, base, dig, p, round, suff)
	FILE *	stream
	SV *	base
	SV *	dig
	mpc_t *	p
	SV *	round
	SV *	suff
CODE:
  RETVAL = _Rmpc_out_strS (aTHX_ stream, base, dig, p, round, suff);
OUTPUT:  RETVAL

SV *
_Rmpc_out_strP (pre, stream, base, dig, p, round)
	SV *	pre
	FILE *	stream
	SV *	base
	SV *	dig
	mpc_t *	p
	SV *	round
CODE:
  RETVAL = _Rmpc_out_strP (aTHX_ pre, stream, base, dig, p, round);
OUTPUT:  RETVAL

SV *
_Rmpc_out_strPS (pre, stream, base, dig, p, round, suff)
	SV *	pre
	FILE *	stream
	SV *	base
	SV *	dig
	mpc_t *	p
	SV *	round
	SV *	suff
CODE:
  RETVAL = _Rmpc_out_strPS (aTHX_ pre, stream, base, dig, p, round, suff);
OUTPUT:  RETVAL

SV *
Rmpc_inp_str (p, stream, base, round)
	mpc_t *	p
	FILE *	stream
	SV *	base
	SV *	round
CODE:
  RETVAL = Rmpc_inp_str (aTHX_ p, stream, base, round);
OUTPUT:  RETVAL

SV *
Rmpc_sin (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_sin (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_cos (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_cos (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_tan (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_tan (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_sinh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_sinh (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_cosh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_cosh (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_tanh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_tanh (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_asin (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_asin (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_acos (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_acos (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_atan (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_atan (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_asinh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_asinh (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_acosh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_acosh (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_atanh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_atanh (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
overload_true (a, second, third)
	mpc_t *	a
	SV *	second
	SV *	third
CODE:
  RETVAL = overload_true (aTHX_ a, second, third);
OUTPUT:  RETVAL

SV *
overload_mul (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_mul (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_add (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_add (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_sub (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_sub (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_div (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_div (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_div_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_div_eq (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_sub_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_sub_eq (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_add_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_add_eq (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_mul_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_mul_eq (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_pow (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_pow (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_pow_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_pow_eq (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_equiv (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_equiv (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_not_equiv (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third
CODE:
  RETVAL = overload_not_equiv (aTHX_ a, b, third);
OUTPUT:  RETVAL

SV *
overload_not (a, second, third)
	mpc_t *	a
	SV *	second
	SV *	third
CODE:
  RETVAL = overload_not (aTHX_ a, second, third);
OUTPUT:  RETVAL

SV *
overload_sqrt (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third
CODE:
  RETVAL = overload_sqrt (aTHX_ p, second, third);
OUTPUT:  RETVAL

void
overload_copy (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        overload_copy(aTHX_ p, second, third);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

SV *
overload_abs (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third
CODE:
  RETVAL = overload_abs (aTHX_ p, second, third);
OUTPUT:  RETVAL

SV *
overload_exp (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third
CODE:
  RETVAL = overload_exp (aTHX_ p, second, third);
OUTPUT:  RETVAL

SV *
overload_log (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third
CODE:
  RETVAL = overload_log (aTHX_ p, second, third);
OUTPUT:  RETVAL

SV *
overload_sin (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third
CODE:
  RETVAL = overload_sin (aTHX_ p, second, third);
OUTPUT:  RETVAL

SV *
overload_cos (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third
CODE:
  RETVAL = overload_cos (aTHX_ p, second, third);
OUTPUT:  RETVAL

void
_get_r_string (p, base, n_digits, round)
	mpc_t *	p
	SV *	base
	SV *	n_digits
	SV *	round
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        _get_r_string(aTHX_ p, base, n_digits, round);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
_get_i_string (p, base, n_digits, round)
	mpc_t *	p
	SV *	base
	SV *	n_digits
	SV *	round
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        _get_i_string(aTHX_ p, base, n_digits, round);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

SV *
_itsa (a)
	SV *	a
CODE:
  RETVAL = _itsa (aTHX_ a);
OUTPUT:  RETVAL

SV *
_new_real (b)
	SV *	b
CODE:
  RETVAL = _new_real (aTHX_ b);
OUTPUT:  RETVAL

SV *
_new_im (b)
	SV *	b
CODE:
  RETVAL = _new_im (aTHX_ b);
OUTPUT:  RETVAL

int
_has_longlong ()


int
_has_longdouble ()


int
_has_inttypes ()

SV *
gmp_v ()
CODE:
  RETVAL = gmp_v (aTHX);
OUTPUT:  RETVAL


SV *
mpfr_v ()
CODE:
  RETVAL = mpfr_v (aTHX);
OUTPUT:  RETVAL


SV *
_MPC_VERSION_MAJOR ()
CODE:
  RETVAL = _MPC_VERSION_MAJOR (aTHX);
OUTPUT:  RETVAL


SV *
_MPC_VERSION_MINOR ()
CODE:
  RETVAL = _MPC_VERSION_MINOR (aTHX);
OUTPUT:  RETVAL


SV *
_MPC_VERSION_PATCHLEVEL ()
CODE:
  RETVAL = _MPC_VERSION_PATCHLEVEL (aTHX);
OUTPUT:  RETVAL


SV *
_MPC_VERSION ()
CODE:
  RETVAL = _MPC_VERSION (aTHX);
OUTPUT:  RETVAL


SV *
_MPC_VERSION_NUM (x, y, z)
	SV *	x
	SV *	y
	SV *	z
CODE:
  RETVAL = _MPC_VERSION_NUM (aTHX_ x, y, z);
OUTPUT:  RETVAL

SV *
_MPC_VERSION_STRING ()
CODE:
  RETVAL = _MPC_VERSION_STRING (aTHX);
OUTPUT:  RETVAL


SV *
Rmpc_get_version ()
CODE:
  RETVAL = Rmpc_get_version (aTHX);
OUTPUT:  RETVAL


SV *
Rmpc_real (rop, op, round)
	mpfr_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_real (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_imag (rop, op, round)
	mpfr_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_imag (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_arg (rop, op, round)
	mpfr_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_arg (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_proj (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_proj (aTHX_ rop, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_get_str (base, dig, op, round)
	SV *	base
	SV *	dig
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_get_str (aTHX_ base, dig, op, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_str (rop, str, base, round)
	mpc_t *	rop
	SV *	str
	SV *	base
	SV *	round
CODE:
  RETVAL = Rmpc_set_str (aTHX_ rop, str, base, round);
OUTPUT:  RETVAL

SV *
Rmpc_strtoc (rop, str, base, round)
	mpc_t *	rop
	SV *	str
	SV *	base
	SV *	round
CODE:
  RETVAL = Rmpc_strtoc (aTHX_ rop, str, base, round);
OUTPUT:  RETVAL

void
Rmpc_set_nan (a)
	mpc_t *	a
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_set_nan(a);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpc_swap (a, b)
	mpc_t *	a
	mpc_t *	b
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_swap(a, b);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

SV *
overload_atan2 (p, q, third)
	mpc_t *	p
	mpc_t *	q
	SV *	third
CODE:
  RETVAL = overload_atan2 (aTHX_ p, q, third);
OUTPUT:  RETVAL

SV *
Rmpc_sin_cos (rop_sin, rop_cos, op, rnd_sin, rnd_cos)
	mpc_t *	rop_sin
	mpc_t *	rop_cos
	mpc_t *	op
	SV *	rnd_sin
	SV *	rnd_cos
CODE:
  RETVAL = Rmpc_sin_cos (aTHX_ rop_sin, rop_cos, op, rnd_sin, rnd_cos);
OUTPUT:  RETVAL

void
Rmpc_get_dc (crop, op, round)
	SV *	crop
	mpc_t *	op
	SV *	round
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_get_dc(aTHX_ crop, op, round);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpc_get_ldc (crop, op, round)
	SV *	crop
	mpc_t *	op
	SV *	round
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpc_get_ldc(aTHX_ crop, op, round);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

SV *
Rmpc_set_dc (op, crop, round)
	mpc_t *	op
	SV *	crop
	SV *	round
CODE:
  RETVAL = Rmpc_set_dc (aTHX_ op, crop, round);
OUTPUT:  RETVAL

SV *
Rmpc_set_ldc (op, crop, round)
	mpc_t *	op
	SV *	crop
	SV *	round
CODE:
  RETVAL = Rmpc_set_ldc (aTHX_ op, crop, round);
OUTPUT:  RETVAL

int
_have_Complex_h ()


SV *
_mpfr_buildopt_tls_p ()
CODE:
  RETVAL = _mpfr_buildopt_tls_p (aTHX);
OUTPUT:  RETVAL


SV *
_get_xs_version ()
CODE:
  RETVAL = _get_xs_version (aTHX);
OUTPUT:  RETVAL


SV *
_wrap_count ()
CODE:
  RETVAL = _wrap_count (aTHX);
OUTPUT:  RETVAL


SV *
Rmpc_mul_2si (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round
CODE:
  RETVAL = Rmpc_mul_2si (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_div_2si (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round
CODE:
  RETVAL = Rmpc_div_2si (aTHX_ a, b, c, round);
OUTPUT:  RETVAL

SV *
Rmpc_log10 (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
CODE:
  RETVAL = Rmpc_log10 (aTHX_ rop, op, round);
OUTPUT:  RETVAL

void
CLONE (x, ...)
	SV *	x
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        CLONE(aTHX_ x);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

BOOT:

  {
  MY_CXT_INIT;
  MY_CXT._perl_default_prec_re = 53;
  MY_CXT._perl_default_prec_im = 53;
  MY_CXT._perl_default_rounding_mode = 0;
  }

