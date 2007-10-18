use inc::Module::Install;
name 'Data-Container';
all_from 'lib/Data/Container.pm';
perl_version '5.006';

requires 'Class::Accessor::Complex';
requires 'Data::Miscellany';
requires 'NEXT';

build_requires 'Test::More' => '0.70';

use_standard_tests(without => 'pod_coverage');
auto_include;
WriteAll;
