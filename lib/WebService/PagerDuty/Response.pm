#!/usr/bin/env perl -w

package WebService::PagerDuty::Response;
use strict;
use warnings;

use Any::Moose;
use URI;


no Any::Moose;

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

WebService::PagerDuty::Response - Aux object to represent PagerDuty responses.

=head1 SYNOPSIS

    my $response = WebService::PagerDuty::Request->post( ... );

=head1 DESCRIPTION

For internal use only.

=head1 SEE ALSO

L<WebService::PagerDuty>, L<http://PagerDuty.com>, L<oDesk.com>

=head1 AUTHOR

Oleg Kostyuk (cubuanic), C<< <cub@cpan.org> >>

=head1 LICENSE

Copyright E<copy> oDesk Inc., 2012

=cut

