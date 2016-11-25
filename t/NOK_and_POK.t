use strict;
use warnings;
use Math::MPC qw(:mpc);
use Math::MPFR qw(:mpfr);

print "1..63\n";

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

if($z != $r) {
  warn "$z != $r\n";
  print "not ok 2\n";
}
else {print "ok 2\n"}

my $inf = 999**(999**999); # value is inf, NOK flag is set.
my $nan = $inf / $inf; # value is nan, NOK flag is set.
my $ninf = $inf * -1;

my $discard = eval{"$inf" }; # POK flag is now also set for $inf  (mostly)
$discard    = eval{"$nan" }; # POK flag is now also set for $nan  (mostly)
$discard    = eval{"$ninf"}; # POK flag is now also set for $ninf (mostly)


$z = Math::MPC->new($inf);

my $check = Math::MPFR->new();

RMPC_RE($check, $z);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 3\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 3\n";
}

if($z == $inf) {print "ok 4\n"}
else {
  warn "$z != inf\n";
  print "not ok 4\n";
}

my $z2 = Math::MPC->new($nan);

RMPC_RE($check, $z2);

if(Rmpfr_nan_p($check)) {print "ok 5\n"}
else {
  warn "\n Expected nan\n Got $check\n";
  print "not ok 5\n";
}

my $fr = Math::MPC->new(10);



my $ret = $fr * $inf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 6\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 6\n";
}

$ret = $fr + $inf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 7\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 7\n";
}

$ret = $fr - $inf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check < 0) {print "ok 8\n"}
else {
  warn "\n Expected -ve inf\n Got $ret\n";
  print "not ok 8\n";
}

$ret = $fr / $inf;

RMPC_RE($check, $ret);

if(Rmpfr_zero_p($check)) {print "ok 9\n"}
else {
  warn "\n Expected 0\n Got $ret\n";
  print "not ok 9\n";
}

$ret = $inf ** $fr;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 10\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 10\n";
}

$fr *= $inf;

RMPC_RE($check, $fr);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 11\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 11\n";
}

$fr += $inf;

RMPC_RE($check, $fr);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 12\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 12\n";
}

$fr -= $inf;

RMPC_RE($check, $fr);

if(Rmpfr_nan_p($check)) {print "ok 13\n"}
else {
  warn "\n Expected nan\n Got $ret\n";
  print "not ok 13\n";
}

$fr /= $inf;

RMPC_RE($check, $fr);

if(Rmpfr_nan_p($check)) {print "ok 14\n"}
else {
  warn "\n Expected nan\n Got $ret\n";
  print "not ok 14\n";
}

$inf **= Math::MPC->new(1);

RMPC_RE($check, $inf);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 15\n"}
else {
  warn "\n Expected +ve inf\n Got $ret\n";
  print "not ok 15\n";
}

if($z != $n) {print "ok 16\n"}
else {
  warn "\n$z == $n\n";
  print "not ok 16\n";
}

if($z == $n) {
  warn "\n$z == $n\n";
  print "not ok 17\n";
}
else {
  print "ok 17\n";
}

my $ret2 = Math::MPC->new();

$ret = Math::MPC->new(1.2) *  $nan;

RMPC_RE($check, $ret);

if(Rmpfr_nan_p($check)) {print "ok 18\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 18\n";
}

$ret = Math::MPC->new(1.2) +  $nan;

RMPC_RE($check, $ret);

if(Rmpfr_nan_p($check)) {print "ok 19\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 19\n";
}

$ret = Math::MPC->new(1.2) -  $nan;

RMPC_RE($check, $ret);

if(Rmpfr_nan_p($check)) {print "ok 20\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 20\n";
}

$ret = Math::MPC->new(1.2) /  $nan;

RMPC_RE($check, $ret);

if(Rmpfr_nan_p($check)) {print "ok 21\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 21\n";
}

$ret = Math::MPC->new(1.2) ** $nan;

RMPC_RE($check, $ret);

if(Rmpfr_nan_p($check)) {print "ok 22\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 22\n";
}

$ret = $nan -  Math::MPC->new(1.2);

RMPC_RE($check, $ret);

if(Rmpfr_nan_p($check)) {print "ok 23\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 23\n";
}

$ret = $nan /  Math::MPC->new(1.2);

RMPC_RE($check, $ret);

if(Rmpfr_nan_p($check)) {print "ok 24\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 24\n";
}

$ret = $nan ** Math::MPC->new(1.2);

RMPC_RE($check, $ret);

if(Rmpfr_nan_p($check)) {print "ok 25\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 25\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 *=  $nan;

RMPC_RE($check, $ret2);

if(Rmpfr_nan_p($check)) {print "ok 26\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 26\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 +=  $nan;

RMPC_RE($check, $ret2);

if(Rmpfr_nan_p($check)) {print "ok 27\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 27\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 /=  $nan;

RMPC_RE($check, $ret2);

if(Rmpfr_nan_p($check)) {print "ok 28\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 28\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 -=  $nan;

RMPC_RE($check, $ret2);

if(Rmpfr_nan_p($check)) {print "ok 29\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 29\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 **= $nan;

RMPC_RE($check, $ret2);

if(Rmpfr_nan_p($check)) {print "ok 30\n"}
else {
  warn "\n Expected NaN\n Got $check\n";
  print "not ok 30\n";
}

##################################
##################################

$ret = Math::MPC->new(1.2) *  $inf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 31\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 31\n";
}

$ret = Math::MPC->new(1.2) +  $inf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 32\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 32\n";
}

$ret = Math::MPC->new(1.2) -  $inf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check < 0) {print "ok 33\n"}
else {
  warn "\n Expected -ve inf\n Got $check\n";
  print "not ok 33\n";
}


$ret = Math::MPC->new(1.2) /  $inf;

RMPC_RE($check, $ret);

if(Rmpfr_zero_p($check) && !Rmpfr_signbit($check)) {print "ok 34\n"}
else {
  warn "\n Expected 0\n Got $check\n";
  print "not ok 34\n";
}


$ret = Math::MPC->new(1.2) ** $inf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 35\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 35\n";
}


$ret = $inf -  Math::MPC->new(1.2);

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 36\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 36\n";
}

$ret = $inf /  Math::MPC->new(1.2);

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 37\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 37\n";
}

$ret = $inf ** Math::MPC->new(1.2);

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 38\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 38\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 *=  $inf;

RMPC_RE($check, $ret2);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 39\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 39\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 +=  $inf;

RMPC_RE($check, $ret2);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 40\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 40\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 /=  $inf;

RMPC_RE($check, $ret2);

if(Rmpfr_zero_p($check) && !Rmpfr_signbit($check)) {print "ok 41\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 41\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 -=  $inf;

RMPC_RE($check, $ret2);

if(Rmpfr_inf_p($check) && $check < 0) {print "ok 42\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 42\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 **= $inf;

RMPC_RE($check, $ret2);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 43\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 43\n";
}

##################################
##################################

$ret = Math::MPC->new(1.2) *  $ninf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check < 0) {print "ok 44\n"}
else {
  warn "\n Expected -ve inf\n Got $check\n";
  print "not ok 44\n";
}

$ret = Math::MPC->new(1.2) +  $ninf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check < 0) {print "ok 45\n"}
else {
  warn "\n Expected -ve inf\n Got $check\n";
  print "not ok 45\n";
}

$ret = Math::MPC->new(1.2) -  $ninf;

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 46\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 46\n";
}

$ret = Math::MPC->new(1.2) /  $ninf;

RMPC_RE($check, $ret);

if(Rmpfr_zero_p($check) && Rmpfr_signbit($check)) {print "ok 47\n"}
else {
  warn "\n Expected -0\n Got $check\n";
  print "not ok 47\n";
}

$ret = Math::MPC->new(1.2) ** $ninf;

RMPC_RE($check, $ret);

if($check == 0 && !Rmpfr_signbit($check)) {print "ok 48\n"}
else {
  warn "\n Expected 0\n Got $check\n";
  print "not ok 48\n";
}

$ret = $ninf -  Math::MPC->new(1.2);

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check < 0) {print "ok 49\n"}
else {
  warn "\n Expected -ve inf\n Got $check\n";
  print "not ok 49\n";
}

$ret = $ninf /  Math::MPC->new(1.2);

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check < 0) {print "ok 50\n"}
else {
  warn "\n Expected -ve inf\n Got $check\n";
  print "not ok 50\n";
}

$ret = $ninf ** Math::MPC->new(1.2);

RMPC_RE($check, $ret);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 51\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 51\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 *=  $ninf;

RMPC_RE($check, $ret2);

if(Rmpfr_inf_p($check) && $check < 0) {print "ok 52\n"}
else {
  warn "\n Expected -ve inf\n Got $check\n";
  print "not ok 52\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 +=  $ninf;

RMPC_RE($check, $ret2);

if(Rmpfr_inf_p($check) && $check < 0) {print "ok 53\n"}
else {
  warn "\n Expected -ve inf\n Got $check\n";
  print "not ok 53\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 /=  $ninf;

RMPC_RE($check, $ret2);

if(Rmpfr_zero_p($check) && Rmpfr_signbit($check)) {print "ok 54\n"}
else {
  warn "\n Expected -ve inf\n Got $check\n";
  print "not ok 54\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 -=  $ninf;

RMPC_RE($check, $ret2);

if(Rmpfr_inf_p($check) && $check > 0) {print "ok 55\n"}
else {
  warn "\n Expected +ve inf\n Got $check\n";
  print "not ok 55\n";
}

Rmpc_set_NV($ret2, 1.2, MPC_RNDNN);
$ret2 **= $ninf;

RMPC_RE($check, $ret2);

if($check == 0 && !Rmpfr_signbit($check)) {print "ok 56\n"}
else {
  warn "\n Expected 0\n Got $check\n";
  print "not ok 56\n";
}

###################################
###################################

$ret = (Math::MPC->new(0, '1.3') == $nan);

if($ret) {
  warn "\n(0, 1.3) == $nan\n";
  print "not ok 57\n";
}
else {print "ok 57\n"}

$ret = (Math::MPC->new(0, '1.3') != $nan);

if(!$ret) {
  warn "\n(0, 1.3) == $nan\n";
  print "not ok 58\n";
}
else {print "ok 58\n"}

$ret = (Math::MPC->new(0, '1.3') == $inf);

if($ret) {
  warn "\n(0, 1.3) == $inf\n";
  print "not ok 59\n";
}
else {print "ok 59\n"}

$ret = (Math::MPC->new(0, '1.3') != $inf);

if(!$ret) {
  warn "\n(0, 1.3) == $inf\n";
  print "not ok 60\n";
}
else {print "ok 60\n"}

$ret = (Math::MPC->new(0, '1.3') == $ninf);

if($ret) {
  warn "\n(0, 1.3) == $ninf\n";
  print "not ok 61\n";
}
else {print "ok 61\n"}

$ret = (Math::MPC->new(0, '1.3') != $ninf);

if(!$ret) {
  warn "\n(0, 1.3) == $ninf\n";
  print "not ok 62\n";
}
else {print "ok 62\n"}

eval{$ret = Math::MPC::_win32_infnanstring('hello');};

if($^O =~ /MSWin32/i && $] < 5.022) {
  if(!$@ && $ret == 0) {print "ok 63\n"}
  else {
    warn "\n\$\@: $@\n\$ret: $ret\n";
    print "not ok 63\n";
  }
}
else {
  if($@ =~ /^Math::MPC::_win32_infnanstring not implemented/) {print "ok 63\n"}
  else {
    warn "\n\$\@: $@\n";
    print "not ok 63\n";
  }
}
