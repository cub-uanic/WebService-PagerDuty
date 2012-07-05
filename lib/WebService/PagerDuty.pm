#!/usr/bin/env perl -w

package WebService::PagerDuty;
use strict;
use warnings;

use Any::Moose;

no Any::Moose;

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

WebService::PagerDuty - Module to interface with the http://PagerDuty.com service

=head1 DESCRIPTION

WebService::PagerDuty - is a client library for http://PagerDuty.com

=head1 SEE ALSO

L<http://PagerDuty.com>, L<oDesk.com>

=head1 AUTHOR

Oleg Kostyuk (cubuanic), C<< <cub@cpan.org> >>

=head1 LICENSE

Copyright E<copy> oDesk Inc., 2012

=cut

