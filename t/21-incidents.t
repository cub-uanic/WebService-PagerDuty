#!/usr/bion/env perl
use strict;
use warnings;
use Test::More;

plan(
      ( -e '.do_remote_testing' )
    ? ( tests => 24 )
    : ( skip_all => 'Do not run test thru network in non-author environment' )
);

use WebService::PagerDuty;
use WebService::PagerDuty::Incidents;
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

my $incidents = $pager_duty->incidents();
isa_ok( $incidents, 'WebService::PagerDuty::Incidents', 'Created WebService::PagerDuty::Incidents object have correct class' );
ok( $incidents->url, 'URL in Incidents object is not empty' );
is( $incidents->user,     'cub-uanic@odesk.com',      'User in Incidents object is correct' );
is( $incidents->password, '8uRwyHTqAP_ms88_8I7x1wuS', 'Password in Incidents object is correct' );

my $count = $incidents->count();
ok( $count, 'We got non-empty response (count)' );
isa_ok( $count, 'WebService::PagerDuty::Response', 'Returned WebService::PagerDuty::Response object have correct class (count)' );
is( $count->status, 'success', 'Response should be successfull (count)' );
ok( $count->message,     'Response should have message to log (count)' );
ok( $count->total >= 15, 'Response have correct total count of incidents (count)' );

my $list = $incidents->list();
ok( $list, 'We got non-empty response (list)' );
isa_ok( $list, 'WebService::PagerDuty::Response', 'Returned WebService::PagerDuty::Response object have correct class (list)' );
is( $list->status, 'success', 'Response should be successfull (list)' );
ok( $list->message,        'Response should have message to log (list)' );
ok( $list->total >= 15,    'Response have correct total count of incidents (list)' );
ok( $list->entries,        'Response have some entries of incidents (list)' );
ok( ref( $list->entries ), 'Response entries is reference (list)' );
ok( ref( $list->entries )      eq 'ARRAY', 'Response entries is reference to array (list)' );
ok( ref( $list->entries->[0] ) eq 'HASH',  'Response entries is reference to array of hashes (list)' );
ok( $list->total >= @{ $list->entries }, 'Count of entries in response looks good (list)' );
my $statuses = [ map { exists( $_->{status} ) ? (1) : () } @{ $list->entries } ];
ok( @$statuses == @{ $list->entries }, 'Each entry in response have status (list)' );

