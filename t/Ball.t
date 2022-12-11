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
my $unblessed = Rmpcb_init_nobless();
my $mpfr = Math::MPFR->new(0);

cmp_ok(ref($mpcb), 'eq', 'Math::MPC::Ball', 'isa Math::MPC::Ball object');
cmp_ok(ref($unblessed), 'eq', 'SCALAR', 'ref() of unblessed object is SCALAR');

my $c_rop = Math::MPC->new(1, 2); # Initial value is 1 + (i * 2);
my $r_rop = Rmpcr_init(); # Initial value is zero

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

# TODO: more tests

done_testing();
