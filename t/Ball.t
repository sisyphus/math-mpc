# Some basic testing of the "ball" functions.
# Requires mpc-1.3.0 or later.

use strict;
use warnings;
use Config;
use Math::MPC qw(:mpc);

use Test::More;

if(MPC_HEADER_V < 66304) {
  warn "\nBall functions not implemented - needs mpc-1.3.0 but we have only mpc-", MPC_HEADER_V_STR, "\n";
  eval{Rmpcb_init();};
  like($@, qr/^Undefined subroutine &main::Rmpcb_init/, "Rmpcb_init() is unknown");

  eval{Math::MPC::Radius::Rmpcb_init();};
  like($@, qr/^Undefined subroutine &Math::MPC::Radius::Rmpcb_init/, "Math::MPC::Radius::Rmpcr_init() is unknown");

  done_testing();
  exit 0;
}

my $mpcb = Rmpcb_init(); # Both real and imaginary components are NaN
                         # and Radius is Inf.
my $rop = Rmpcb_init();
my $unblessed = Rmpcb_init_nobless();
my $mpfr = Math::MPFR->new(0);

cmp_ok(ref($mpcb), 'eq', 'Math::MPC::Ball', 'isa Math::MPC::Ball object');
cmp_ok(ref($unblessed), 'eq', 'SCALAR', 'ref() of unblessed object is SCALAR');

my $c_rop = Math::MPC->new(1, 2); # Initial value is 1 + (i * 2);
my $r_rop = Rmpcr_init(); # Initial value is zero
my $r_rop_check = Rmpcr_init();

cmp_ok(Rmpcr_zero_p($r_rop), '!=', 0, 'Radius is zero');
Rmpcr_set_zero($r_rop); # Value should already be zero, anyway.

Rmpcb_retrieve($c_rop, $r_rop, $mpcb);

# The real and imaginary parts of $c_rop should now both be NaN
# $r_rop should now be Inf.

RMPC_RE($mpfr, $c_rop);
cmp_ok(Math::MPFR::Rmpfr_nan_p($mpfr), '!=', 0, 'real part of initialized Math::MPC::Ball object is NaN');

RMPC_IM($mpfr, $c_rop);
cmp_ok(Math::MPFR::Rmpfr_nan_p($mpfr), '!=', 0, 'imaginary part of initialized Math::MPC::Ball object is NaN');

cmp_ok(Rmpcr_inf_p($r_rop), '!=', 0, 'radius part of initialized Math::MPC::Ball object is Inf');

Rmpcb_set_ui_ui($mpcb, 600, 205, 42); # Set centre of $mpcb to 600 + (i * 205); precision = 42 bits.

cmp_ok(Rmpcb_get_prec($mpcb), '==', 42, "Rmpcb_get_prec works");

my @rounds = (
  MPC_RNDNN, MPC_RNDZN, MPC_RNDUN, MPC_RNDDN, MPC_RNDAN,
  MPC_RNDNZ, MPC_RNDZZ, MPC_RNDUZ, MPC_RNDDZ, MPC_RNDAZ,
  MPC_RNDNU, MPC_RNDZU, MPC_RNDUU, MPC_RNDDU, MPC_RNDAU,
  MPC_RNDND, MPC_RNDZD, MPC_RNDUD, MPC_RNDDD, MPC_RNDAD,
  MPC_RNDNA, MPC_RNDZA, MPC_RNDUA, MPC_RNDDA, MPC_RNDAA,
  );

Rmpc_set_default_prec2(10, 26);
my $mpc = Math::MPC->new();

for(@rounds) {
  cmp_ok(Rmpcb_can_round($mpcb, 10, 6, $_), '!=', 0, "can round - direction " . $_);
  cmp_ok(Rmpcb_round($mpc, $mpcb, $_), '==', 0, "exact rounding - direction " . $_);
}

Rmpcb_set($rop, $mpcb);
Rmpcb_retrieve($c_rop, $r_rop_check, $rop);

# If the next 5 tests pass then we know that
# Rmpcb_set worked as expected.
RMPC_RE($mpfr, $c_rop);
cmp_ok($mpfr, '==', 600, "same real value");
cmp_ok(Math::MPFR::Rmpfr_get_prec($mpfr), '==', 42, "same real prec");
RMPC_IM($mpfr, $c_rop);
cmp_ok($mpfr, '==', 205, "same imaginary value");
cmp_ok(Math::MPFR::Rmpfr_get_prec($mpfr), '==', 42, "same imaginary prec");
cmp_ok(Rmpcr_zero_p($r_rop_check), '!=', 0, "Rmpcb_set: zero radius");

my $inf = Rmpcb_init();
Rmpcb_set_inf($inf);
Rmpcb_retrieve($c_rop, $r_rop, $inf);

# Next 3 tests will confirm that Rmpcb_set_inf() worked.
cmp_ok(Rmpcr_inf_p($r_rop), '!=', 0, "infinite radius");
RMPC_RE($mpfr, $c_rop);
cmp_ok(Math::MPFR::Rmpfr_zero_p($mpfr), '!=', 0, "zero real value");
RMPC_IM($mpfr, $c_rop);
cmp_ok(Math::MPFR::Rmpfr_zero_p($mpfr), '!=', 0, "zero imaginary value");

my $mpc2 = Math::MPC->new(256, 128);
Rmpcb_set_c($rop, $mpc2, 50, 0, 0);

Rmpcb_retrieve($c_rop, $r_rop, $rop);
cmp_ok(Rmpcr_zero_p($r_rop), '!=', 0, "Rmpcb_set_c: zero radius");

RMPC_RE($mpfr, $c_rop);
cmp_ok($mpfr, '==', 256, "Rmpcb_set_c: real value is 256");
cmp_ok(Math::MPFR::Rmpfr_get_prec($mpfr), '==', 50, "Rmpcb_set_c: real prec is 50");
RMPC_IM($mpfr, $c_rop);
cmp_ok($mpfr, '==', 128, "Rmpcb_set_c: imaginary value is 128");
cmp_ok(Math::MPFR::Rmpfr_get_prec($mpfr), '==', 50, "Rmpcb_set_c: imaginary prec is 50");

Rmpcb_set_c($rop, $mpc2, 50, 5, 5);
Rmpcb_retrieve($c_rop, $r_rop, $rop);
cmp_ok(Rmpcr_zero_p($r_rop), '==', 0, "Rmpcb_set_c: non-zero radius");

Rmpcb_clear($unblessed); # must be explicitly freed to avoid memory leak.

done_testing();
