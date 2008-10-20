use inc::Module::Install;
include 'Module::AutoInstall';

name 'Data-Container';
all_from 'lib/Data/Container.pm';
perl_version '5.006';

requires 'Class::Accessor::Complex';
requires 'Data::Miscellany';
requires 'NEXT';

recommends 'Test::Pod';
recommends 'Test::Pod::Coverage';

test_requires 'Test::More' => '0.70';
test_requires 'Test::Compile';

auto_install;
auto_include;
WriteAll;
