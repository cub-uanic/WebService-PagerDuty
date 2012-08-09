#!/usr/bin/env perl -w

## workaround for PkgVersion
## no critic
package WebService::PagerDuty::Event;
## use critic
use strict;
use warnings;

use Moo;
use URI;
use WebService::PagerDuty::Request;

has url => (
    is       => 'ro',
    required => 1,
);
has service_key => (
    is       => 'ro',
    required => 1,
);
has incident_key => (
    is       => 'ro',
    required => 0,
);
has description => (
    is       => 'ro',
    required => 0,
);

my @__method_definitions = (
    ## method_name => required_arg  ],
    [ trigger     => 'description' ],
    [ acknowledge => 'incident_key' ],
    [ resolve     => 'incident_key' ],
);

__construct_method(@$_) for @__method_definitions;
*ack = \&acknowledge;

sub __construct_method {
    my ( $method_name, $required_arg ) = @_;

    no strict 'refs';    ## no critic

    my $method = 'sub {
        my ( $self, %details ) = @_;

        my $incident_key = delete $details{incident_key} || $self->incident_key || undef;
        my $description  = delete $details{description}  || $self->description  || undef;

        die("WebService::PagerDuty::Event::' . $method_name . '(): ' . $required_arg . ' is required")
            unless defined \$' . $required_arg . ';

        return WebService::PagerDuty::Request->new->post(
            url         => $self->url,
            event_type  => "' . $method_name . '",
            service_key => $self->service_key,
            ( $description  ? ( description  => $description )  : () ),
            ( $incident_key ? ( incident_key => $incident_key ) : () ),
            ( %details      ? ( details      => \%details )     : () ),
        );
    }';

    *$method_name = eval $method;    ## no critic
}

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

=begin Pod::Coverage

    trigger
    acknowledge
    ack
    resolve

=end Pod::Coverage

=cut

