#!/usr/bin/env perl -w

## workaround for PkgVersion
## no critic
package WebService::PagerDuty;
## use critic
use strict;
use warnings;

use Mouse;
use URI;
use WebService::PagerDuty::Event;
use WebService::PagerDuty::Incidents;
use WebService::PagerDuty::Schedules;

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
    lazy     => 1,
    default  => sub {
        my $self = shift;
        URI->new( ( $self->use_ssl ? 'https' : 'http' ) . '://events.pagerduty.com/generic/2010-04-15/create_event.json' );
    },
);
has incidents_url => (
    is       => 'ro',
    isa      => 'URI',
    required => 0,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        URI->new( 'https://' . $self->subdomain . '.pagerduty.com/api/v1/incidents' );
    },
);
has schedules_url => (
    is       => 'ro',
    isa      => 'URI',
    required => 0,
    lazy     => 1,
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

no Mouse;

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

WebService::PagerDuty - Module to interface with the http://PagerDuty.com service

=head1 SYNOPSIS

    # for Events API, all parameters are optional
    my $pager_duty = WebService::PagerDuty->new();


    # for Incidents API and Schedules API, these are mandatory
    my $pager_duty2 = WebService::PagerDuty->new(
        user        => 'test_user',
        password    => 'test_password',
        subdomain   => 'test-sub-domain',
        # always optional, true by default
        use_ssl     => 1,
    );

    # if you want to get access to all three APIs via
    # same $pager_duty variable, then use second form


    #
    # Events API
    #
    my $event = $pager_duty->event(
         service_key  => ... , # required
         incident_key => ... , # optional
         %extra_params,
    );
    $event->trigger( %extra_params );
    $event->acknowledge( %extra_params );
    $event->resolve( %extra_params );

    #
    # Incidents API
    #
    my $incidents = $pager_duty->incidents();
    $incidents->count( %extra_params );
    $incidents->list( %extra_params );

    #
    # Schedules API
    #
    my $schedules = $pager_duty->schedules();
    $schedules->list(
        schedule_id => ... ,
        since       => 'ISO8601date',
        until       => 'ISO8601date',
        %extra_params,
    );

=head1 DESCRIPTION

WebService::PagerDuty - is a client library for http://PagerDuty.com

For detailed description of B<%extra_params> (including which of them are
required or optional), see PagerDuty site:

=over 4

=item L<Events API|http://www.pagerduty.com/docs/integration-api/integration-api-documentation>

=item L<Incidents API|http://www.pagerduty.com/docs/rest-api/incidents>

=item L<Schedules API|http://www.pagerduty.com/docs/rest-api/schedules>

=back

Also, you could explore tests in t/ directory of distribution archive.

=head1 SEE ALSO

L<http://PagerDuty.com>, L<http://oDesk.com>

=head1 AUTHOR

Oleg Kostyuk (cubuanic), C<< <cub@cpan.org> >>

=head1 LICENSE

Same as Perl.

=head1 COPYRIGHT

Copyright by oDesk Inc., 2012

All development sponsored by oDesk.

=head1 NO WARRANTY

This software is provided "as-is," without any express or implied warranty.
In no event shall the author or sponsor be held liable for any damages
arising from the use of the software.

=cut

