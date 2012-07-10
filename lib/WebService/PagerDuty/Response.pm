#!/usr/bin/env perl -w

package WebService::PagerDuty::Response;
use strict;
use warnings;

use Any::Moose;
use JSON;

has [qw/ code status message error incident_key data /] => ( is => 'ro', );

sub BUILDARGS {
    my ( $self, $response, $options ) = @_;
    $options ||= {};

    if ($response) {
        $options->{code}    = $response->code();
        $options->{status}  = $response->code();
        $options->{message} = $response->message();
        $options->{errors}  = undef;
        $options->{data}    = decode_json( $response->content() );

        $options->{status}       = delete $options->{data}{status}       if exists $options->{data}{status};
        $options->{message}      = delete $options->{data}{message}      if exists $options->{data}{message};
        $options->{error}        = delete $options->{data}{errors}       if exists $options->{data}{errors};
        $options->{incident_key} = delete $options->{data}{incident_key} if exists $options->{data}{incident_key};
    }
    else {
        $options->{code}    = 599;
        $options->{status}  = 'invalid';
        $options->{message} = $options->{error} = 'WebService::PagerDuty::Response was created incorrectly';
    }

    return $options;
}

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

