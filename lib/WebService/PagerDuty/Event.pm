#!/usr/bin/env perl -w

package WebService::PagerDuty::Event;
use strict;
use warnings;

use Any::Moose;
use URI;

has url => (
    is       => 'ro',
    isa      => 'URI',
    required => 1,
);

sub trigger {
    my $self = shift;
}

sub acknowledge {
    my $self = shift;
}
*ack = \&acknowledge;

sub resolve {
    my $self = shift;
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

Copyright E<copy> oDesk Inc., 2012

=cut

