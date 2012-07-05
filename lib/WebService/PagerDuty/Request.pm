#!/usr/bin/env perl -w

package WebService::PagerDuty::Request;
use strict;
use warnings;

use Any::Moose;
use URI;

our $VERSION = '0.01';

sub get {
    my $self = shift;
    return $self->_perform_request( method => 'GET', @_ );
}

sub post {
    my $self = shift;
    return $self->_perform_request( method => 'POST', @_ );
}

sub _perform_request {
    my $self = shift;
    return WebService::PagerDuty::Response->new();
}

no Any::Moose;

__PACKAGE__->meta->make_immutable;

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

Copyright E<copy> oDesk Inc., 2012

=cut

