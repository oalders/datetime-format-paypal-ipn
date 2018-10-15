use strict;
use warnings;

use Test::Most;
use Test::Fatal;

use DateTime::Format::PayPal::IPN;

like(
  exception { DateTime::Format::PayPal::IPN->parse_timestamp; },
  qr/missing date string with timestamp/,
  'parse_timestamp() died when no date string passed',
);

my $date = '02:35:35 Feb 16, 2010 PST';

my $dt = DateTime::Format::PayPal::IPN->parse_timestamp( $date );
is( $dt, '2010-02-16T02:35:35', 'stringifies correctly' );

is( DateTime::Format::PayPal::IPN->format_timestamp( $dt ),
    $date, 'formats back to original string' );

done_testing();
