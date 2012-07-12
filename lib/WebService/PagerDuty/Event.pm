#!/usr/bin/env perl -w

package WebService::PagerDuty::Event;
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
has service_key => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);
has incident_key => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);
has description => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
);

sub trigger {
    my ( $self, %details ) = @_;

    my $incident_key = $details{incident_key} || $self->incident_key || undef;
    my $description  = $details{description}  || $self->description  || undef;

    delete $details{incident_key};
    delete $details{description};

    die('WebService::PagerDuty::Event::trigger(): description is required') unless defined $description;

    load_class('WebService::PagerDuty::Request');
    return WebService::PagerDuty::Request->new->post(
        url         => $self->url,
        service_key => $self->service_key,
        event_type  => 'trigger',
        description => $description,
        ( $incident_key ? ( incident_key => $incident_key ) : () ),
        ( %details      ? ( details      => \%details )     : () ),
    );
}

sub acknowledge {
    my ( $self, %details ) = @_;

    my $incident_key = $details{incident_key} || $self->incident_key || undef;
    my $description  = $details{description}  || $self->description  || undef;

    delete $details{incident_key};
    delete $details{description};

    die('WebService::PagerDuty::Event::acknowledge(): incident_key is required') unless defined $incident_key;

    load_class('WebService::PagerDuty::Request');
    return WebService::PagerDuty::Request->new->post(
        url          => $self->url,
        service_key  => $self->service_key,
        event_type   => 'acknowledge',
        incident_key => $incident_key,
        ( $description ? ( description => $description ) : () ),
        ( %details     ? ( details     => \%details )    : () ),
    );
}
*ack = \&acknowledge;

sub resolve {
    my ( $self, %details ) = @_;

    my $incident_key = $details{incident_key} || $self->incident_key || undef;
    my $description  = $details{description}  || $self->description  || undef;

    delete $details{incident_key};
    delete $details{description};

    die('WebService::PagerDuty::Event::resolve(): incident_key is required') unless defined $incident_key;

    load_class('WebService::PagerDuty::Request');
    return WebService::PagerDuty::Request->new->post(
        url          => $self->url,
        service_key  => $self->service_key,
        event_type   => 'resolve',
        incident_key => $incident_key,
        ( $description ? ( description => $description ) : () ),
        ( %details     ? ( details     => \%details )    : () ),
    );
}

no Any::Moose;

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

WebService::PagerDuty::Event - A event object

=head1 SYNOPSIS

    my $pager_duty = WebService::PagerDuty->new;

    my $event = $pager_duty->event( ... );
    $event->trigger( ... );
    $event->acknowledge( ... );
    $event->ack( ... ); # same as above, synonym
    $event->resolve( ... );

=head1 DESCRIPTION

This class represents a basic event object, which could be triggered,
acknowledged or resolved.

=head1 SEE ALSO

L<WebService::PagerDuty>, L<http://PagerDuty.com>, L<oDesk.com>

=head1 AUTHOR

Oleg Kostyuk (cubuanic), C<< <cub@cpan.org> >>

=head1 LICENSE

Copyright by oDesk Inc., 2012

All development sponsored by oDesk.

=cut

