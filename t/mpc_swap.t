use warnings;
use strict;
use Math::MPFR qw(:mpfr);
use Math::MPC qw(:mpc);

use Test::More;

my $mpc_ = Rmpc_init2(64);
my $mpc__ = Rmpc_init2(64);
my $mpc0 = Rmpc_init2(64);
my $mpc0_copy = Rmpc_init2(64);
my $mpc1 = Rmpc_init2(64);
my $mpc1_copy = Rmpc_init2(64);

my $mpc2 = Rmpc_init3(100, 150);
my $mpc2_copy = Rmpc_init3(100, 150);
my $mpc3 = Rmpc_init3(90, 70);
my $mpc3_copy = Rmpc_init3(90, 70);

Rmpc_set_d_d($mpc_, 123.5, 123.75, MPC_RNDNN);
Rmpc_set_d_d($mpc__, 123.5, 123.75, MPC_RNDNN);
Rmpc_set_d_d($mpc0, 1.5, 1.75, MPC_RNDNN);
Rmpc_set_d_d($mpc1, 2.5, 2.625, MPC_RNDNN);
Rmpc_set_d_d($mpc2, 1.31, 1.173, MPC_RNDNN);
Rmpc_set_d_d($mpc3, 2.59, 2.871, MPC_RNDNN);
Rmpc_set_d_d($mpc0_copy, 1.5, 1.75, MPC_RNDNN);
Rmpc_set_d_d($mpc1_copy, 2.5, 2.625, MPC_RNDNN);
Rmpc_set_d_d($mpc2_copy, 1.31, 1.173, MPC_RNDNN);
Rmpc_set_d_d($mpc3_copy, 2.59, 2.871, MPC_RNDNN);

cmp_ok($mpc_, '==', $mpc__, '$mpc_ == $mpc__');
Rmpc_swap($mpc__, $mpc_);
cmp_ok($mpc_, '==', $mpc__, '$mpc_ is still the same as $mpc__');

cmp_ok($mpc0, '==', $mpc0_copy, '$mpc0 == $mpc0_copy');
cmp_ok($mpc1, '==', $mpc1_copy, '$mpc1 == $mpc1_copy');

Rmpc_swap($mpc0, $mpc1);

cmp_ok($mpc0, '==', $mpc1_copy, '$mpc0 == $mpc1_copy');
cmp_ok($mpc1, '==', $mpc0_copy, '$mpc1 == $mpc0_copy');
########################################################
cmp_ok($mpc2, '==', $mpc2_copy, '$mpc2 == $mpc2_copy');
cmp_ok($mpc3, '==', $mpc3_copy, '$mpc3 == $mpc3_copy');

Rmpc_swap($mpc2, $mpc3);

cmp_ok($mpc2, '==', $mpc3_copy, '$mpc2 == $mpc3_copy');
cmp_ok($mpc3, '==', $mpc2_copy, '$mpc3 == $mpc2_copy');

done_testing();

