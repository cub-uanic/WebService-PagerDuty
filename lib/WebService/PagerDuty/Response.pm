#!/usr/bin/env perl -w

## workaround for PkgVersion
## no critic
package WebService::PagerDuty::Response;
## use critic
use strict;
use warnings;

use Moo;
use JSON;
use Try::Tiny;

my @all_options = qw/
  code status message error
  incident_key
  total limit offset
  entries
  data
  /;
has $_ => ( is => 'ro', ) for @all_options;

sub BUILDARGS {
    my ( $self, $response, $options ) = @_;
    $options ||= {};

    if ($response) {
        $options->{code}    = $response->code();
        $options->{status}  = $response->status_line();
        $options->{message} = $response->message();
        $options->{errors}  = undef;

        try {
            $options->{data} = decode_json( $response->content() ) if $response->content();
        }
        catch {
            ## the only error that could happen and we care of - it's when $response->content can't
            ## be parsed as json (no difference why - because of bad request or something else)
            $options->{data} = {
                status  => 'invalid',
                message => $_,
            };
        };

        for my $option (@all_options) {
            $options->{$option} = delete $options->{data}{$option} if exists $options->{data}{$option};
        }

        # one extra-case
        $options->{entries} = delete $options->{data}{incidents} if exists $options->{data}{incidents};

        # translate HTTP codes to human-readable status
        if ( $options->{status} =~ /^(\d+)/ ) {
            if ( $1 eq '200' ) {
                $options->{status} = 'success';
            }
            else {
                $options->{status} = 'invalid';
            }
        }

        # eliminate uneeded fields
        delete $options->{data} unless %{ $options->{data} };
    }
    else {
        $options->{code}    = 599;
        $options->{status}  = 'invalid';
        $options->{message} = $options->{error} = 'WebService::PagerDuty::Response was created incorrectly';
    }

    return $options;
}

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

Copyright by oDesk Inc., 2012

All development sponsored by oDesk.

=begin Pod::Coverage

    BUILDARGS

=end Pod::Coverage

=cut

