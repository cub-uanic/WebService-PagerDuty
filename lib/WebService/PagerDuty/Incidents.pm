#!/usr/bin/env perl -w

## workaround for PkgVersion
## no critic
package WebService::PagerDuty::Incidents;
## use critic
use strict;
use warnings;

use Mouse;
use URI;
use WebService::PagerDuty::Request;

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

    return WebService::PagerDuty::Request->new->get(
        url      => URI->new( $self->url . '/count' ),
        user     => $self->user,
        password => $self->password,
        params   => \%params,
    );
}

sub query {
    my ( $self, %params ) = @_;

    return WebService::PagerDuty::Request->new->get(
        url      => $self->url,
        user     => $self->user,
        password => $self->password,
        params   => \%params,
    );
}
*list = \&query;

no Mouse;

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

Copyright by oDesk Inc., 2012

All development sponsored by oDesk.

=cut

