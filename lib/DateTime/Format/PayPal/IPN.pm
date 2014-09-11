use strict;
use warnings;

package DateTime::Format::PayPal::IPN;

use Carp qw( croak );
use DateTime::TimeZone;
use DateTime::Format::Strptime;

my $pattern = '%H:%M:%S %b %d, %Y';
my $tz      = DateTime::TimeZone->new( name => 'America/Los_Angeles' );
my $strp    = DateTime::Format::Strptime->new(
    pattern   => $pattern,
    time_zone => $tz,
);

sub parse_timestamp {
    my $class = shift;
    my $date  = shift;

    my $orig = $date;
    $date =~ s{ (PST|PDT)\z}{};

    my $dt = $strp->parse_datetime( $date );
    croak 'could not parse string: ' . $orig unless $dt;

    return $dt;
}

sub format_timestamp {
    my $class = shift;
    my $dt    = shift;

    my $stamp = $dt->strftime( $pattern, $dt );
    $stamp .= $dt->is_dst ? ' PDT' : ' PST';
    return $stamp;
}

1;

__END__

# ABSTRACT: Parse PayPal IPN timestamps

=head1 SYNOPSIS

    use DateTime::Format::PayPal::IPN;

    my $dt = DateTime::Format::PayPal::IPN->parse_timestamp( '02:35:35 Feb 16, 2010 PST' );

    # 2010-02-16 02:35:35
    # DateTime::Format::PayPal::IPN->format_timestamp($dt);

=head1 DESCRIPTION

This module parses and formats timestamps returned by PayPal's IPN (Instant
Payment Notification) system.

=head1 METHODS

=over 4

=item * parse_timestamp($string)

Given a value of the appropriate type, this method will return a new
L<DateTime> object.  The time zone for this object will always be the
'America/Los_Angeles' as all IPN data which I have seen is sent in this time
zone format.

If given an improperly formatted string, this method should die.

=item * format_timestamp($datetime)

Given a C<DateTime> object, this methods returns an appropriately
formatted string.

=back

=head1 ACKNOWLEDGEMENTS

Most of the Pod was directly lifted from Dave Rolsky's L<DateTime::Format::MySQL>.

=cut
