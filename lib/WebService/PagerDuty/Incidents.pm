#!/usr/bin/env perl -w

package WebService::PagerDuty::Incidents;
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

sub count {
    my ( $self, %params ) = @_;

    my $url = $self->url->clone;
    $url->path( $url->path . "/count" );

    load_class('WebService::PagerDuty::Request');
    return WebService::PagerDuty::Request->get(
        url      => $url,
        user     => $self->user,
        password => $self->password,
        params   => \%params,
    );
}

sub query {
    my ( $self, %params ) = @_;

    load_class('WebService::PagerDuty::Request');
    return WebService::PagerDuty::Request->get(
        url      => $self->url,
        user     => $self->user,
        password => $self->password,
        params   => \%params,
    );
}
*list = \&query;

no Any::Moose;

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

WebService::PagerDuty::Incidents - A incidents object

=head1 SYNOPSIS

    my $pager_duty = WebService::PagerDuty->new;

    my $incidents = $pager_duty->incidents( ... );
    $incidents->count();
    $incidents->query();
    $incidents->list(); # same as above, synonym

=head1 DESCRIPTION

This class represents a basic incidents object, to get access
to count and list of existing incidents.

=head1 SEE ALSO

L<WebService::PagerDuty>, L<http://PagerDuty.com>, L<oDesk.com>

=head1 AUTHOR

Oleg Kostyuk (cubuanic), C<< <cub@cpan.org> >>

=head1 LICENSE

Copyright E<copy> oDesk Inc., 2012

=cut

