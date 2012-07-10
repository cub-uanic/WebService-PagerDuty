#!/usr/bion/env perl
use strict;
use warnings;
use Test::More;

plan(
      ( -e '.do_remote_testing' )
    ? ( tests => 19 )
    : ( skip_all => 'Do not run test thru network in non-author environment' )
);

use WebService::PagerDuty;
use WebService::PagerDuty::Schedules;
use WebService::PagerDuty::Response;

my $pager_duty = WebService::PagerDuty->new(
    subdomain => 'cub-uanic-odesk',
    user      => 'cub-uanic@odesk.com',
    password  => '8uRwyHTqAP_ms88_8I7x1wuS',
);
isa_ok( $pager_duty, 'WebService::PagerDuty', 'Created WebService::PagerDuty object have correct class' );
is( $pager_duty->subdomain, 'cub-uanic-odesk',          'Subdomain in PagerDuty object is correct' );
is( $pager_duty->user,      'cub-uanic@odesk.com',      'User in PagerDuty object is correct' );
is( $pager_duty->password,  '8uRwyHTqAP_ms88_8I7x1wuS', 'Password in PagerDuty object is correct' );

my $schedules = $pager_duty->schedules();
isa_ok( $schedules, 'WebService::PagerDuty::Schedules', 'Created WebService::PagerDuty::Schedules object have correct class' );
ok( $schedules->url, 'URL in Schedules object is not empty' );
is( $schedules->user,     'cub-uanic@odesk.com',      'User in Schedules object is correct' );
is( $schedules->password, '8uRwyHTqAP_ms88_8I7x1wuS', 'Password in Schedules object is correct' );

my $list = $schedules->list(
    schedule_id => 'PODUVNC',
    since       => '2012-07-09T00:00Z',    # ISO 8601 required
    until       => '2012-07-11T00:00Z',    # ISO 8601 required
);
ok( $list, 'We got non-empty response (list)' );
isa_ok( $list, 'WebService::PagerDuty::Response', 'Returned WebService::PagerDuty::Response object have correct class (list)' );
is( $list->status, 'success', 'Response should be successfull (list)' );
ok( $list->message,    'Response should have message to log (list)' );
ok( $list->total >= 1, 'Response have correct total count of schedules (list)' );
ok( $list->entries,    'Response have some entries of schedules (list)' );

ok( ref( $list->entries ), 'Response entries is reference (list)' );
ok( ref( $list->entries )      eq 'ARRAY', 'Response entries is reference to array (list)' );
ok( ref( $list->entries->[0] ) eq 'HASH',  'Response entries is reference to array of hashes (list)' );
ok( $list->total >= @{ $list->entries }, 'Count of entries in response looks good (list)' );
my $good_entries = [ map { exists( $_->{start} ) && exists( $_->{end} ) && exists( $_->{user} ) ? (1) : () } @{ $list->entries } ];
ok( @$good_entries == @{ $list->entries }, 'Each entry in response have all needed fields (list)' );

