#!/usr/bion/env perl
use strict;
use warnings;
use Test::More;

plan(
      ( -e '.do_remote_testing' )
    ? ( tests => 7 )
    : ( skip_all => 'Do not run test thru network in non-author environment' )
);

use WebService::PagerDuty;
use WebService::PagerDuty::Event;
use WebService::PagerDuty::Response;

my $pager_duty = WebService::PagerDuty->new();
isa_ok( $pager_duty, 'WebService::PagerDuty', 'Created WebService::PagerDuty object have correct class' );

# Testing with incorrect service key
my $incorrect_event = $pager_duty->event( service_key => '????????????????????????????????' );
isa_ok( $incorrect_event, 'WebService::PagerDuty::Event', 'Created WebService::PagerDuty::Event object have correct class' );
ok( $incorrect_event->url, 'URL in Event object is not empty' );
is( $incorrect_event->service_key, '????????????????????????????????', 'ServiceKey in Event object is correct' );

my $response = $incorrect_event->trigger( description => 'Test triggering event with bad service_key' );
ok( $response, 'We got non-empty response' );
isa_ok( $response, 'WebService::PagerDuty::Response', 'Returned WebService::PagerDuty::Response object have correct class' );

SKIP: {
    skip 'Broken API on PagerDuty accepts any (even incorrect) service_key', 1;
    isnt( $response->status, 'success', 'Response should be not successfull' );
}

