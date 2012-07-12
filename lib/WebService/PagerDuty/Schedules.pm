#!/usr/bin/env perl -w

package WebService::PagerDuty::Schedules;
use strict;
use warnings;

use Any::Moose;
use URI;
use Class::Load qw/ load_class /;

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

    my $id = $params{id} || $params{schedule_id} || undef;

    delete $params{id};
    delete $params{schedule_id};

    die('WebService::PagerDuty::Schedules::entries(): id or schedule_id is required') unless defined $id;

    load_class('WebService::PagerDuty::Request');
    return WebService::PagerDuty::Request->new->get(
        url      => URI->new( $self->url . '/' . $id . '/entries' ),
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

Copyright by oDesk Inc., 2012

All development sponsored by oDesk.

=cut

