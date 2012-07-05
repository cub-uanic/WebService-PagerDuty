#!/usr/bin/env perl -w

package WebService::PagerDuty::Schedules;
use strict;
use warnings;

use Any::Moose;
use URI;

has url => (
    is       => 'ro',
    isa      => 'URI',
    required => 1,
);
has user => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);
has password => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub entries {
    my ( $self, %params ) = @_;

    return WebService::PagerDuty::Request->get(
        url      => $self->url,
        user     => $self->user,
        password => $self->password,
        params   => \%params,
    );
}
*list = \&entries;

no Any::Moose;

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

WebService::PagerDuty::Schedules - A schedules object

=head1 SYNOPSIS

    my $pager_duty = WebService::PagerDuty->new;

    my $schedules = $pager_duty->schedules( ... );
    $schedules->entries();

=head1 DESCRIPTION

This class represents a basic schedules object, to get entries
of existing schedules.

=head1 SEE ALSO

L<http://PagerDuty.com>, L<oDesk.com>

=head1 AUTHOR

Oleg Kostyuk (cubuanic), C<< <cub@cpan.org> >>

=head1 LICENSE

Copyright E<copy> oDesk Inc., 2012

=cut

