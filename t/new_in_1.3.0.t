use strict;
use warnings;
use Math::MPC qw(:mpc);

use Test::More;

my $rop = Math::MPC->new();
my $op  = Math::MPC->new(-0.3, 1.2);
my $op2 = Math::MPC->new(6.2, -2.6);

if(MPC_VERSION < 66304) {
  eval{Rmpc_eta_fund($rop, $op, MPC_RNDAA);};
  like($@, qr/^Rmpc_eta_fund function requires mpc version 1\.3\.0/, "Function croaks in pre mpc-1.3.0");

  eval{Rmpc_agm($rop, $op, $op2, MPC_RNDAA);};
  like($@, qr/^Rmpc_agm function requires mpc version 1\.3\.0/, "Function croaks in pre mpc-1.3.0");
}
else {
  Rmpc_eta_fund($rop, $op, MPC_RNDNN);
  cmp_ok("$rop", 'eq', '(7.2829981913846153e-1 -5.6948215660904557e-2)', "Rmpc_eta_fund output is ok");

  my $inex = Rmpc_agm($rop, $op, $op2, MPC_RNDAA);
  cmp_ok("$rop", 'eq', '(2.7191494731957273 6.4237609338121771e-1)', "Rmpc_agm output is ok");
}

for( [0.49, -10], [-0.49, -10], [-0.49, 1], [-0.5, sqrt(0.8)], [0, 1.0001], [0.49, "Inf" + 0],
     [0.49, 0 - "Inf"]  ){
  my $bool = in_fund_dom(Math::MPC->new(@$_));
  cmp_ok($bool, '==', 1, "[@$_] inside fundamental  domain");
}

for( [0.51, 10], [-0.51, 10], [0.49, sqrt(0.75)], [0.51, sqrt(0.75)], [-0.5, sqrt(0.7)],
     ["NaN" + 0, 20.0], ["NaN" + 0, "Nan" + 0], [0.4, "NaN" + 0], ["NaN" + 0, "Inf" + 0],
     ["Inf" + 0, "NaN" + 0], ["Inf" + 0, 0.2] ){
  my $bool = in_fund_dom(Math::MPC->new(@$_));
  cmp_ok($bool, '==', 0, "[@$_] outside fundamental  domain");
}

done_testing();