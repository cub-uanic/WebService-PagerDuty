#!/usr/bion/env perl
use strict;
use warnings;
use Test::More;

plan(
      ( -e '.do_remote_testing' )
    ? ( tests => 20 )
    : ( skip_all => 'Do not run test thru network in non-author environment' )
);

use WebService::PagerDuty;
use WebService::PagerDuty::Event;
use WebService::PagerDuty::Response;

my $pager_duty = WebService::PagerDuty->new();
isa_ok( $pager_duty, 'WebService::PagerDuty', 'Created WebService::PagerDuty object have correct class' );

my $response;
my $incident_key = 'HTTP/srv01.odesk.com';

# Testing with correct service key and non-empty incident_key
my $correct_event = $pager_duty->event(
    service_key  => '0f3475b0a905012fc55622000afc419f',
    incident_key => $incident_key,
);
isa_ok( $correct_event, 'WebService::PagerDuty::Event', 'Created WebService::PagerDuty::Event object have correct class' );
ok( $correct_event->url, 'URL in Event object is not empty' );
is( $correct_event->service_key, '0f3475b0a905012fc55622000afc419f', 'ServiceKey in Event object is correct' );
is( $correct_event->incident_key, $incident_key, 'IncidentKey in Event object is correct' );

$response = $correct_event->trigger( description => 'Test triggering event with good service_key and non-empty incident_key' );
ok( $response, 'We got non-empty response (trigger)' );
isa_ok( $response, 'WebService::PagerDuty::Response', 'Returned WebService::PagerDuty::Response object have correct class (trigger)' );
is( $response->status, 'success', 'Response should be successfull (trigger)' );
ok( $response->message, 'Response should have message to log (trigger)' );
is( $response->incident_key, $incident_key, 'Response have correct incident_key (trigger)' );

$response = $correct_event->acknowledge(
    incident_key => $incident_key,
    description  => 'Problem accepted, incident_key=' . $incident_key,
);
ok( $response, 'We got non-empty response (acknowledge)' );
isa_ok( $response, 'WebService::PagerDuty::Response', 'Returned WebService::PagerDuty::Response object have correct class (acknowledge)' );
is( $response->status, 'success', 'Response should be successfull (acknowledge)' );
ok( $response->message, 'Response should have message to log (acknowledge)' );
is( $response->incident_key, $incident_key, 'Response have correct incident_key (acknowledge)' );

$response = $correct_event->resolve(
    incident_key => $incident_key,
    description  => 'Problem resolved, incident_key=' . $incident_key,
);
ok( $response, 'We got non-empty response (resolve)' );
isa_ok( $response, 'WebService::PagerDuty::Response', 'Returned WebService::PagerDuty::Response object have correct class (resolve)' );
is( $response->status, 'success', 'Response should be successfull (resolve)' );
ok( $response->message, 'Response should have message to log (resolve)' );
is( $response->incident_key, $incident_key, 'Response have correct incident_key (resolve)' );

