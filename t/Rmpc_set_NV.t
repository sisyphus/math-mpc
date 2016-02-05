use warnings;
use strict;
use Config;
use Math::MPC qw(:mpc);
use Math::MPFR qw(:mpfr);

print "# Using mpfr version ", MPFR_VERSION_STRING, "\n";
print "# Using mpc library version ", MPC_VERSION_STRING, "\n";

my $prec;

if(Math::MPC::_can_pass_float128()) {$prec = 113}
elsif(Math::MPC::_has_longdouble()) {
  if($Config{nvsize} == 8) {$prec = 53}
  elsif((1.0 + (2 ** -1000)) > 1.0) {$prec = 106} # double-double NV
  else {$prec = 64}
}
else                                {$prec = 53 }

my $approximate = 0;

if($Config{nvtype} eq '__float128' && $prec != 113) {
  warn "\nNot passing __float128 - approximating __float128 as long double\n";
  $approximate = 1;
}

print "1..4\n";
warn "\nusing precision: $prec\n";
Rmpc_set_default_prec2($prec, $prec);
Rmpfr_set_default_prec($prec);

my $mpc  = Math::MPC->new();
my $real = Math::MPFR->new();
my $imag = Math::MPFR->new();
Rmpc_set_NV($mpc, -3.0,  MPC_RNDNN);
Rmpc_sqrt  ($mpc, $mpc, MPC_RNDNN);

RMPC_RE($real, $mpc);
RMPC_IM($imag, $mpc);

if($approximate == 0) {
  if($real == 0) {print "ok 1\n"}
  else {
    warn "\nexpected 0, got $real\n";
    print "not ok 1\n";
  }

  if($imag == sqrt(3.0)) {print "ok 2\n"}
  else {
    warn "\nexpected ", sqrt(3.0), ", got $imag\n";
    print "not ok 2\n";
  }

  $mpc += Math::MPC->new('101.1', '-14.9');

  Rmpc_set_NV_NV($mpc, 0, sqrt(3.0), MPC_RNDNN);

  $mpc **= 2;

  RMPC_RE($real, $mpc);
  RMPC_IM($imag, $mpc);

  my $re_expected = (sqrt(3.0) ** 2) * -1.0;

  if($real == $re_expected) {print "ok 3\n"}
  else {
    warn "\nexpected $re_expected, got $real\n";
    print "not ok 3\n";
  }

  if($imag == 0) {print "ok 4\n"}
  else {
    warn "\nexpected 0 got $imag\n";
    print "not ok 4\n";
  }
}
else {
  if($real == 0) {print "ok 1\n"}
  else {
    warn "\nexpected 0, got $real\n";
    print "not ok 1\n";
  }

  if($imag != sqrt(3.0) && $imag > 1.7320508 && $imag < 1.73205081) {print "ok 2\n"}
  else {
    warn "\nexpected approx ", sqrt(3.0), ", got $imag\n";
    print "not ok 2\n";
  }

  $mpc += Math::MPC->new('101.1', '-14.9');

  Rmpc_set_NV_NV($mpc, 0, sqrt(3.0), MPC_RNDNN);

  $mpc **= 2;

  RMPC_RE($real, $mpc);
  RMPC_IM($imag, $mpc);

  my $re_expected = (sqrt(3.0) ** 2) * -1.0;

  if($real != $re_expected && $real > -3.0000001 && $real < -2.9999999 ) {print "ok 3\n"}
  else {
    warn "\nexpected aprroximately 3, got $real\n";
    print "not ok 3\n";
  }

  if($imag == 0) {print "ok 4\n"}
  else {
    warn "\nexpected 0 got $imag\n";
    print "not ok 4\n";
  }
}




