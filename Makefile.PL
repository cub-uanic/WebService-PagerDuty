use inc::Module::Install 1.06;

perl_version '5.008';

my $main_module = 'lib/WebService/PagerDuty.pm';

name 'WebService-PagerDuty';
author q{Oleg Kostyuk <cub-uanic@odesk.com>};
all_from $main_module;
repository 'http://github.com/cub-uanic/webservice-pagerduty';

requires(
    'Any::Moose'      => '0.16',
    'Class::Load'     => '0.19',
    'JSON'            => 0,
    'LWP::UserAgent'  => 0,
    'Try::Tiny'       => 0,
    'URI'             => 0,
    'URI::QueryParam' => 0,
);

recommends(
    ## for better speed
    'JSON::XS' => 0,
);

test_requires(
    ## may be extended later
    'Test::More' => 0,
);

tests_recursive;

install_script glob('script/*.pl');
install_script glob('script/*.sh');
auto_install;

WriteAll;

if ($Module::Install::AUTHOR) {
    system("pod2text $main_module > README") and die $!;
    system("make manifest")                  and die $!;
}

