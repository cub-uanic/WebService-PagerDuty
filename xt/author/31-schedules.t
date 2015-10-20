#!/usr/bion/env perl
use strict;
use warnings;
use lib './t/lib';
use Test::More tests => 22;
use POSIX qw/ strftime /;

use WebService::PagerDuty;
use WebService::PagerDuty::Schedules;
use WebService::PagerDuty::Response;

do 'config.pl';
our $pd_subdomain;
our $pd_user;
our $pd_password;
our $pd_schedule_id;

my $pager_duty = WebService::PagerDuty->new(
    subdomain => $pd_subdomain,
    api_key   => $pd_api_key,
);

isa_ok( $pager_duty, 'WebService::PagerDuty', 'Created WebService::PagerDuty object have correct class' );
is( $pager_duty->subdomain, $pd_subdomain, 'Subdomain in PagerDuty object is correct' );
is( $pager_duty->api_key,   $pd_api_key,   'API Key in PagerDuty object is correct' );

my $schedules = $pager_duty->schedules();
isa_ok( $schedules, 'WebService::PagerDuty::Schedules', 'Created WebService::PagerDuty::Schedules object have correct class' );
ok( $schedules->url, 'URL in Schedules object is not empty' );
is( $schedules->api_key,  $pd_api_key,  'API Key in Schedules object is correct' );

my $since = `date --date '-1 month' '+%Y-%m-%dT00:00Z'`;    # ISO 8601 required
my $until = `date --date '+1 month' '+%Y-%m-%dT00:00Z'`;    # ISO 8601 required

my $list = $schedules->list(
    schedule_id => $pd_schedule_id,
    since       => $since,
    until       => $until,
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

my $all_schedules = $schedules->all_schedules;

cmp_ok( ref( $all_schedules->schedules ),      'eq', 'ARRAY', 'Response schedules is an array ref (all_schedules)' );
cmp_ok( ref( $all_schedules->schedules->[0] ), 'eq', 'HASH', 'Schedule[0] is a hash reference (all_schedules)');
cmp_ok( ref( $all_schedules->schedules->[0] ), 'eq', 'HASH', 'Schedule[0] is a hash reference (all_schedules)');
ok( $all_schedules->schedules->[0]{id},   'Schedule[0] has an id' );
ok( $all_schedules->schedules->[0]{name}, 'Schedule[0] has a name' );
