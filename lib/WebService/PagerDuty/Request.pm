#!/usr/bin/env perl -w

## workaround for PkgVersion
## no critic
package WebService::PagerDuty::Request;
## use critic
use strict;
use warnings;

use Moo;
use HTTP::Request;
use LWP::UserAgent;
use JSON;
use URI;
use URI::QueryParam;
use WebService::PagerDuty::Response;

has 'agent' => (
    is      => 'ro',
    lazy    => 1,
    default => sub { LWP::UserAgent->new }
);

sub get {
    my $self = shift;
    return $self->_perform_request( method => 'GET', @_ );
}

sub post {
    my $self = shift;
    return $self->_perform_request( method => 'POST', @_ );
}

sub _perform_request {
    my ( $self, %args ) = @_;

    my $method   = delete $args{method};
    my $url      = delete $args{url};
    my $user     = delete $args{user};
    my $password = delete $args{password};
    my $params   = delete $args{params};
    my $body     = {%args};

    die( 'Unknown method: ' . $method ) unless $method =~ m/^(get|post)$/io;

    $url->query_form_hash($params) if $params && ref($params) && ref($params) eq 'HASH' && %$params;

    my $headers = HTTP::Headers->new;
    $headers->header( 'Content-Type' => 'application/json' ) if %$body;
    $headers->authorization_basic( $user, $password ) if $user && $password;

    my $content = '';
    $content = encode_json($body) if %$body;

    my $request = HTTP::Request->new( $method, $url, $headers, $content );

    my $response = $self->agent->request($request);

    return WebService::PagerDuty::Response->new($response);
}

1;

=head1 NAME

WebService::PagerDuty::Request - Aux object to perform HTTP requests.

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

    get
    post

=end Pod::Coverage

=cut

