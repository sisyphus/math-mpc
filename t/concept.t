# Check that mpc_imagref and mpc_realref return an mpfr_ptr.
# Also check that the returned mpfr_ptr works (inside XS code) as expected.
# We run these checks by calling Math::MPC::_concept_tests();

use strict;
use warnings;
use Math::MPC qw(:mpc);

use Test::More;

my $op = Rmpc_init2(53);
Rmpc_set_ui_ui($op, 2, 3, MPC_RNDNN);             # re != im
cmp_ok(Math::MPC::_concept_tests($op), '==', 255, "concept test ok");

Rmpc_set_ui_ui($op, 5, 5, MPC_RNDNN);            # re == im
cmp_ok(Math::MPC::_concept_tests($op), '==', 51, "concept test ok");

done_testing();

__END__
