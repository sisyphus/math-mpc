use strict;
use warnings;
use Math::MPC qw(:mpc);
use Math::MPFR qw(:mpfr);

print "1..16\n";

my $n = '98765' x 80;
my $r = '98765' x 80;
my $z;

if($n > 0) { # sets NV slot to inf, and turns on the NOK flag
  $z = Math::MPC->new($n);
}


if($z == $r) {print "ok 1\n"}
else {
  warn "$z != $r\n";
  print "not ok 1\n";
}

my $inf = 999**(999**999); # value is inf, NOK flag is set.
my $nan = $inf / $inf; # value is nan, NOK flag is set.

my $discard = eval{"$inf"}; # POK flag is now also set for $inf (mostly)
$discard    = eval{"$nan"}; # POK flag is now also set for $nan (mostly)


$z = Math::MPC->new($inf);

my $check = Math::MPFR->new();

RMPC_RE($check, $z);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 2\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 2\n";
}

if($z == $inf) {print "ok 3\n"}
else {
  warn "$z != inf\n";
  print "not ok 3\n";
}

my $z2 = Math::MPC->new($nan);

RMPC_RE($check, $z2);

if(Rmpfr_nan_p($check)) {print "ok 4\n"}
else {
  warn "\n Expected nan\n Got $check\n";
  print "not ok 4\n";
}

my $fr = Math::MPC->new(10);



my $ret = $fr * $inf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 5\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 5\n";
}

$ret = $fr + $inf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 6\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 6\n";
}

$ret = $fr - $inf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check < 0) {print "ok 7\n"}
else {
  warn "\n Expected -ve inf\n Got $ret\n";
  print "not ok 7\n";
}

$ret = $fr / $inf;

RMPC_RE($check, $ret);

if(Rmpfr_zero_p($check)) {print "ok 8\n"}
else {
  warn "\n Expected 0\n Got $ret\n";
  print "not ok 8\n";
}

$ret = $inf ** $fr;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 9\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 9\n";
}

$fr *= $inf;

RMPC_RE($check, $fr);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 10\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 10\n";
}

$fr += $inf;

RMPC_RE($check, $fr);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 11\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 11\n";
}

$fr -= $inf;

RMPC_RE($check, $fr);

if(Rmpfr_nan_p($check)) {print "ok 12\n"}
else {
  warn "\n Expected nan\n Got $ret\n";
  print "not ok 12\n";
}

$fr /= $inf;

RMPC_RE($check, $fr);

if(Rmpfr_nan_p($check)) {print "ok 13\n"}
else {
  warn "\n Expected nan\n Got $ret\n";
  print "not ok 13\n";
}

$inf **= Math::MPC->new(1);

RMPC_RE($check, $inf);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 14\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 14\n";
}

if($z != $n) {print "ok 15\n"}
else {
  warn "\n$z == $n\n";
  print "not ok 15\n";
}

if($z == $n) {
  warn "\n$z == $n\n";
  print "not ok 16\n";
}
else {
  print "ok 16\n";
}



