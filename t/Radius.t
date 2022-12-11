use strict;
use warnings;
use Config;
use Math::MPC qw(:mpc);

use Test::More;

if(MPC_HEADER_V < 66304) {
  warn "\nRadius functions not implemented - needs mpc-1.3.0 but we have only mpc-", MPC_HEADER_V_STR, "\n";
  eval{Rmpcr_init();};
  like($@, qr/^Undefined subroutine &main::Rmpcr_init/, "Rmpcr_init() is unknown");

  eval{Math::MPC::Radius::Rmpcr_init();};
  like($@, qr/^Undefined subroutine &Math::MPC::Radius::Rmpcr_init/, "Math::MPC::Radius::Rmpcr_init() is unknown");

  done_testing();
  exit 0;
}

my $rop = Rmpcr_init();
my $chk = Rmpcr_init();
my $one = Rmpcr_init();
my $two = Rmpcr_init();
my $four = Rmpcr_init();
my $half = Rmpcr_init();
my $qtr = Rmpcr_init();
my $nbl = Rmpcr_init_nobless(); # no magic

Rmpcr_set_inf($rop);
Rmpcr_set_inf($nbl);

cmp_ok(ref($rop), 'eq', 'Math::MPC::Radius', 'isa Math::MPC::Radius object');
cmp_ok(ref($nbl), 'eq', 'SCALAR', 'ref() of unblessed object is SCALAR');

cmp_ok(Rmpcr_inf_p($rop), '!=', 0, "Object is Inf");
cmp_ok(Rmpcr_zero_p($nbl), '==', 0, "Object is not Zero");
cmp_ok(Rmpcr_cmp($rop, $nbl), '==', 0, "Objects are equivalent");
cmp_ok(Rmpcr_cmp($rop, $nbl), '==', Rmpcr_cmp($nbl, $rop), "Argument reversal does not destroy equivalence");

Rmpcr_set($chk, $nbl);
cmp_ok(Rmpcr_cmp($rop, $chk), '==', 0, "Rmpcr_set works");

Rmpcr_sqr($chk, $nbl);
cmp_ok(Rmpcr_cmp($rop, $nbl), '==', 0, "Inf ** 2 == Inf");

Rmpcr_sqrt($chk, $nbl);
cmp_ok(Rmpcr_cmp($rop, $nbl), '==', 0, "Inf ** 0.5 == Inf");

Rmpcr_set_one($chk);
Rmpcr_set_zero($nbl);

cmp_ok(Rmpcr_cmp($chk, $rop), '<', 0, "1 < Inf");
cmp_ok(Rmpcr_cmp($rop, $chk), '>', 0, "Inf > 1");

Rmpcr_set_one($one);
cmp_ok(Rmpcr_lt_half_p($one), '==', 0, "1 > 0.5");

Rmpcr_set_zero($nbl);
cmp_ok(Rmpcr_lt_half_p($nbl), '!=', 0, "0 < 0.5");

my $mpc1 = Math::MPC->new(3.0, -4.0);
my $mpc2 = Math::MPC->new(4.0, -3.0);
Rmpcr_c_abs_rnd($rop, $mpc1, 2); # MPFR_RNDU
Rmpcr_c_abs_rnd($chk, $mpc2, 2); # MPFR_RNDU
cmp_ok(Rmpcr_cmp($rop, $chk), '==', 0, "Rmpcr_c_abs_rnd is consistent");

Rmpcr_c_abs_rnd($chk, $mpc2, 3); # MPFR_RNDD
cmp_ok(Rmpcr_cmp($rop, $chk), '>', 0, "Value is lessened by rounding down");

Rmpcr_set_ui64_2si64($two , 2, 0);# 1073741824, -29);
Rmpcr_set_ui64_2si64($four, 4, 0);# 1073741824, -28);
Rmpcr_set_ui64_2si64($half, 1073741824, -31);
Rmpcr_set_ui64_2si64($qtr , 1073741824, -32);
Rmpcr_set_str_2str($chk, "1", "-1");
cmp_ok(Rmpcr_cmp($half, $chk), '==', 0, "Rmpcr_str_2str functions correctly");

#Rmpcr_out_str(*stdout, $one); print "\n";
#Rmpcr_print($one); print "\n";
#Rmpcr_say($one); print "OK\n";

Rmpcr_destroy($nbl); # $nbl is unblessed and must be specifically
                     # freed in order to avoid memory leak.
done_testing();
