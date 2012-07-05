#!/usr/bin/env perl -w

package WebService::PagerDuty;
use strict;
use warnings;

use Any::Moose;
use URI;

our $VERSION = '0.01';

has user => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);
has password => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);
has subdomain => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);

has use_ssl => (
    is       => 'ro',
    isa      => 'Bool',
    required => 0,
    default  => 1,
);

has event_url => (
    is       => 'ro',
    isa      => 'URI',
    required => 0,
    default  => sub {
        my $self = shift;
        URI->new( ( $self->use_ssl ? 'https' : 'http' ) . '://events.pagerduty.com/generic/2010-04-15/create_event.json' );
    },
);
has incidents_url => (
    is       => 'ro',
    isa      => 'URI',
    required => 0,
    default  => sub {
        my $self = shift;
        URI->new( 'https://' . $self->subdomain . '.pagerduty.com/api/v1/incidents' );
    },
);
has schedules_url => (
    is       => 'ro',
    isa      => 'URI',
    required => 0,
    default  => sub {
        my $self = shift;
        URI->new( 'https://' . $self->subdomain . '.pagerduty.com/api/v1/schedules' );
    },
);

sub event {
    my $self = shift;
    return WebService::PagerDuty::Event->new(
        url => $self->event_url,
        @_
    );
}

sub incidents {
    my $self = shift;
    return WebService::PagerDuty::Incidents->new(
        url      => $self->incidents_url,
        user     => $self->user,
        password => $self->password,
        @_
    );
}

sub schedules {
    my $self = shift;
    return WebService::PagerDuty::Schedules->new(
        url      => $self->schedules_url,
        user     => $self->user,
        password => $self->password,
        @_
    );
}

no Any::Moose;

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

WebService::PagerDuty - Module to interface with the http://PagerDuty.com service

=head1 SYNOPSIS

    my $pager_duty = WebService::PagerDuty->new(
        use_ssl     => 1,
        user        => 'test_user',
        password    => 'test_password',
        subdomain   => 'test-sub-domain',
    );

    my $event = $pager_duty->event( ... );
    $event->trigger( ... );
    $event->acknowledge( ... );
    $event->resolve( ... );

    my $incidents = $pager_duty->incidents( ... );
    $incidents->count();
    $incidents->list();

    my $schedules = $pager_duty->schedules( ... );
    $schedules->entries(
        schedule_id => ... ,
        since       => 'ISO8601date',
        until       => 'ISO8601date',
        ...
    );

=head1 DESCRIPTION

WebService::PagerDuty - is a client library for http://PagerDuty.com

=head1 SEE ALSO

L<http://PagerDuty.com>, L<oDesk.com>

=head1 AUTHOR

Oleg Kostyuk (cubuanic), C<< <cub@cpan.org> >>

=head1 LICENSE

Copyright E<copy> oDesk Inc., 2012

=cut

