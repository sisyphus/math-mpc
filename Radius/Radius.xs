
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
#include <inttypes.h>

/*********************
 If the mpc library is not at version 1.3.0 or higher, then
 we allow this XS file to compile, by specifying the following
 typedef - even though every functions will croak() if called.
 TODO: Handle less insanely.
*********************/

#if MPC_VERSION < 66304
  typedef int mpcr_ptr;
#endif

SV * Rmpcr_init(pTHX) {
#if MPC_VERSION >= 66304
  mpcr_t * mpcr_t_obj;
  SV * obj_ref, * obj;

  New(1, mpcr_t_obj, 1, mpcr_t);
  if(mpcr_t_obj == NULL) croak("Failed to allocate memory in Rmpcr_init function");
  obj_ref = newSV(0);
  obj = newSVrv(obj_ref, "Math::MPC::Radius");

  sv_setiv(obj, INT2PTR(IV,mpcr_t_obj));
  SvREADONLY_on(obj);
  return obj_ref;
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

SV * Rmpcr_init_nobless(pTHX) {
#if MPC_VERSION >= 66304
  mpcr_t * mpcr_t_obj;
  SV * obj_ref, * obj;

  New(1, mpcr_t_obj, 1, mpcr_t);
  if(mpcr_t_obj == NULL) croak("Failed to allocate memory in Rmpcr_init_nobless function");
  obj_ref = newSV(0);
  obj = newSVrv(obj_ref, NULL);

  sv_setiv(obj, INT2PTR(IV,mpcr_t_obj));
  SvREADONLY_on(obj);
  return obj_ref;
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_set_str_2str(mpcr_ptr rop, char * mantissa, char* exponent) {
#if MPC_VERSION >= 66304
  int64_t m, e;
  char c;
  int scanned = sscanf(mantissa, "%" SCNd64 "%c", &m, &c);
  if(scanned < 1) croak("Scan of first input (%s) to Rmpc_set_str failed", mantissa);
  if(scanned > 1) warn("Extra data found in scan of first input (%s) to Rmpc_set_str", mantissa);

  scanned = sscanf(exponent, "%" SCNd64 "%c", &e, &c);
  if(scanned < 1) croak("Scan of second input (%s) to Rmpc_set_str failed", exponent);
  if(scanned > 1) warn("Extra data found in scan of second input (%s) to Rmpc_set_str", exponent);
  mpcr_set_ui64_2si64(rop, m, e);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_destroy(mpcr_ptr op) {
#if MPC_VERSION >= 66304
# ifdef MATH_MPC_DEBUG
  printf("Rmpcr_destroy()ing mpcr_ptr\n");
# endif
  Safefree(op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void DESTROY(mpcr_ptr op) {
#if MPC_VERSION >= 66304
# ifdef MATH_MPC_DEBUG
  printf("DESTROYing mpcr_ptr\n");
# endif
  Safefree(op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

int Rmpcr_inf_p(mpcr_ptr op) {
#if MPC_VERSION >= 66304
   return mpcr_inf_p(op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

int Rmpcr_zero_p(mpcr_ptr op) {
#if MPC_VERSION >= 66304
   return mpcr_zero_p(op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

int Rmpcr_lt_half_p(mpcr_ptr op) {
#if MPC_VERSION >= 66304
   return mpcr_lt_half_p(op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

int Rmpcr_cmp(mpcr_ptr op1, mpcr_ptr op2) {
#if MPC_VERSION >= 66304
   return mpcr_cmp(op1, op2);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_set_inf(mpcr_ptr op) {
#if MPC_VERSION >= 66304
  mpcr_set_inf(op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_set_zero(mpcr_ptr op) {
#if MPC_VERSION >= 66304
  mpcr_set_zero(op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_set_one(mpcr_ptr op) {
#if MPC_VERSION >= 66304
  mpcr_set_one(op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_set(mpcr_ptr rop, mpcr_ptr op) {
#if MPC_VERSION >= 66304
  mpcr_set(rop, op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_set_ui64_2si64(mpcr_ptr rop, IV mantissa, IV exponent) {
#if MPC_VERSION >= 66304
   mpcr_set_ui64_2si64(rop, (int64_t)mantissa, (int64_t)exponent);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_max (mpcr_ptr rop, mpcr_ptr op1, mpcr_ptr op2) {
#if MPC_VERSION >= 66304
   mpcr_max(rop, op1, op2);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

IV Rmpcr_get_exp (mpcr_ptr op) {
#if MPC_VERSION >= 66304
   return (IV)mpcr_get_exp(op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_out_str (pTHX_ FILE *stream, mpcr_ptr op) {
#if MPC_VERSION >= 66304
   mpcr_out_str(stream, op);
   fflush(stream);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_print (pTHX_ mpcr_ptr op) {
#if MPC_VERSION >= 66304
   mpcr_out_str(stdout, op);
   fflush(stdout);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_say (pTHX_ mpcr_ptr op) {
#if MPC_VERSION >= 66304
   mpcr_out_str(stdout, op);
   fflush(stdout);
   printf("\n");
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}


void Rmpcr_add (mpcr_ptr rop, mpcr_ptr op1, mpcr_ptr op2) {
#if MPC_VERSION >= 66304
   mpcr_add(rop, op1, op2);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_sub (mpcr_ptr rop, mpcr_ptr op1, mpcr_ptr op2) {
#if MPC_VERSION >= 66304
   mpcr_sub(rop, op1, op2);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_mul (mpcr_ptr rop, mpcr_ptr op1, mpcr_ptr op2) {
#if MPC_VERSION >= 66304
   mpcr_mul(rop, op1, op2);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_div (mpcr_ptr rop, mpcr_ptr op1, mpcr_ptr op2) {
#if MPC_VERSION >= 66304
   mpcr_div(rop, op1, op2);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_mul_2ui (mpcr_ptr rop, mpcr_ptr op, unsigned long int ui) {
#if MPC_VERSION >= 66304
   mpcr_mul_2ui(rop, op, ui);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_div_2ui (mpcr_ptr rop, mpcr_ptr op, unsigned long int ui) {
#if MPC_VERSION >= 66304
   mpcr_div_2ui(rop, op, ui);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_sqr (mpcr_ptr rop, mpcr_ptr op) {
#if MPC_VERSION >= 66304
   mpcr_sqr(rop, op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_sqrt (mpcr_ptr rop, mpcr_ptr op) {
#if MPC_VERSION >= 66304
   mpcr_sqrt(rop, op);
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_sub_rnd (pTHX_ mpcr_ptr rop, mpcr_ptr op1, mpcr_ptr op2, SV * round) {
#if MPC_VERSION >= 66304
   mpcr_sub_rnd(rop, op1, op2, (mpfr_rnd_t)SvUV(round));
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_c_abs_rnd (pTHX_ mpcr_ptr rop, mpc_ptr mpc_op, SV * round) { /* mpc_ptr arg */
#if MPC_VERSION >= 66304
   mpcr_c_abs_rnd(rop, mpc_op, (mpfr_rnd_t)SvUV(round));
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}

void Rmpcr_add_rounding_error (pTHX_ mpcr_ptr rop, SV * op, SV * round) {
#if MPC_VERSION >= 66304
   mpcr_add_rounding_error(rop, (mpfr_prec_t)SvUV(op), (mpfr_rnd_t)SvUV(round));
#else
  croak("Rmpcr_* functions need mpc-1.3.0. This is only mpc-%s", MPC_VERSION_STRING);
#endif
}


MODULE = Math::MPC::Radius  PACKAGE = Math::MPC::Radius

PROTOTYPES: DISABLE


SV *
Rmpcr_init ()
CODE:
  RETVAL = Rmpcr_init (aTHX);
OUTPUT:  RETVAL

SV *
Rmpcr_init_nobless ()
CODE:
  RETVAL = Rmpcr_init_nobless (aTHX);
OUTPUT:  RETVAL

void
Rmpcr_set_str_2str (rop, mantissa, exponent)
	mpcr_ptr	rop
	char *	mantissa
	char *	exponent
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_set_str_2str(rop, mantissa, exponent);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_destroy (op)
	mpcr_ptr	op
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_destroy(op);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
DESTROY (op)
	mpcr_ptr	op
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        DESTROY(op);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

int
Rmpcr_inf_p (op)
	mpcr_ptr	op

int
Rmpcr_zero_p (op)
	mpcr_ptr	op

int
Rmpcr_lt_half_p (op)
	mpcr_ptr	op

int
Rmpcr_cmp (op1, op2)
	mpcr_ptr	op1
	mpcr_ptr	op2

void
Rmpcr_set_inf (op)
	mpcr_ptr	op
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_set_inf(op);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_set_zero (op)
	mpcr_ptr	op
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_set_zero(op);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_set_one (op)
	mpcr_ptr	op
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_set_one(op);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_set (rop, op)
	mpcr_ptr	rop
	mpcr_ptr	op
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_set(rop, op);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_set_ui64_2si64 (rop, mantissa, exponent)
	mpcr_ptr	rop
	IV	mantissa
	IV	exponent
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_set_ui64_2si64(rop, mantissa, exponent);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_max (rop, op1, op2)
	mpcr_ptr	rop
	mpcr_ptr	op1
	mpcr_ptr	op2
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_max(rop, op1, op2);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

IV
Rmpcr_get_exp (op)
	mpcr_ptr	op

void
Rmpcr_out_str (stream, op)
	FILE *	stream
	mpcr_ptr	op
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_out_str(aTHX_ stream, op);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_print (op)
	mpcr_ptr	op
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_print(aTHX_ op);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_say (op)
	mpcr_ptr	op
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_say(aTHX_ op);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_add (rop, op1, op2)
	mpcr_ptr	rop
	mpcr_ptr	op1
	mpcr_ptr	op2
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_add(rop, op1, op2);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_sub (rop, op1, op2)
	mpcr_ptr	rop
	mpcr_ptr	op1
	mpcr_ptr	op2
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_sub(rop, op1, op2);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_mul (rop, op1, op2)
	mpcr_ptr	rop
	mpcr_ptr	op1
	mpcr_ptr	op2
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_mul(rop, op1, op2);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_div (rop, op1, op2)
	mpcr_ptr	rop
	mpcr_ptr	op1
	mpcr_ptr	op2
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_div(rop, op1, op2);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_sqr (rop, op)
	mpcr_ptr	rop
	mpcr_ptr	op
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_sqr(rop, op);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_sqrt (rop, op)
	mpcr_ptr	rop
	mpcr_ptr	op
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_sqrt(rop, op);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_sub_rnd (rop, op1, op2, round)
	mpcr_ptr	rop
	mpcr_ptr	op1
	mpcr_ptr	op2
	SV *	round
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_sub_rnd(aTHX_ rop, op1, op2, round);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_c_abs_rnd (rop, mpc_op, round)
	mpcr_ptr	rop
	mpc_ptr	mpc_op
	SV *	round
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_c_abs_rnd(aTHX_ rop, mpc_op, round);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

void
Rmpcr_add_rounding_error (rop, op, round)
	mpcr_ptr	rop
	SV *	op
	SV *	round
        PREINIT:
        I32* temp;
        PPCODE:
        temp = PL_markstack_ptr++;
        Rmpcr_add_rounding_error(aTHX_ rop, op, round);
        if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
          PL_markstack_ptr = temp;
          XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
        return; /* assume stack size is correct */

