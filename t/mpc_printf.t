# Test Rmpc_printf, Rmpc_printf_re, Rmpc_printf_im and
# Rmpc_get_str_ndigits.
# None of these functions exist in the mpc library - we simply
# use the mnpfr library for these implementations.

use strict;
use warnings;
use Math::MPC qw(:mpc);

use Test::More;

Rmpc_set_default_prec2(53, 113);

my $op = Math::MPC->new(0.1, -0.625);

my $ok = Rmpc_printf("(%.17Rg %Rb)\n", $op);
cmp_ok($ok, '==', 31, "Rmpc_printf apparently ok");

my($re_digs, $im_digs);

eval { ($re_digs, $im_digs) = Rmpc_get_str_ndigits2(10, $op);};

if(Math::MPFR::MPFR_VERSION() < 262400) { # less than mpfr-4.1.0
  like($@, qr/^Rmpc_get_str_ndigits2 requires version 4\.1\.0 of the mpfr library/, '$@ set as expected');
}
else {
  cmp_ok($re_digs, '==', 17, "real digits ok");
  cmp_ok($im_digs, '==', 36, "imaginary digits ok");
}

done_testing();

