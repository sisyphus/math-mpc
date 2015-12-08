use warnings;
use strict;
use Config;
use Math::MPC qw(:mpc);
use Math::MPFR qw(:mpfr);

print "# Using mpfr version ", MPFR_VERSION_STRING, "\n";
print "# Using mpc library version ", MPC_VERSION_STRING, "\n";

my $prec;

if(Math::MPC::_can_pass_float128()) {$prec = 113}
elsif(Math::MPC::_has_longdouble()) {$prec = 64 }
else                                {$prec = 53 }

if($Config{nvtype} eq '__float128' && $prec != 113) {
  print "1..1\n";
  warn "\nSkipping all tests - can't pass __float128 values\n";
  print "ok 1\n";
}

else {
  print "1..4\n";
  Rmpc_set_default_prec2($prec, $prec);
  Rmpfr_set_default_prec($prec);

  my $mpc  = Math::MPC->new();
  my $real = Math::MPFR->new();
  my $imag = Math::MPFR->new();
  Rmpc_set_NV($mpc, -2.0,  MPC_RNDNN);
  Rmpc_sqrt  ($mpc, $mpc, MPC_RNDNN);

  RMPC_RE($real, $mpc);
  RMPC_IM($imag, $mpc);

  if($real == 0) {print "ok 1\n"}
  else {
    warn "\nexpected 0, got $real\n";
    print "not ok 1\n";
  }

  if($imag == sqrt(2.0)) {print "ok 2\n"}
  else {
    warn "\nexpected ", sqrt(2.0), ", got $imag\n";
    print "not ok 2\n";
  }

  $mpc += Math::MPC->new('101.1', '-14.9');

  Rmpc_set_NV_NV($mpc, 0, sqrt(2.0), MPC_RNDNN);

  $mpc **= 2;

  RMPC_RE($real, $mpc);
  RMPC_IM($imag, $mpc);

  my $re_expected = (sqrt(2.0) ** 2) * -1.0;

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



