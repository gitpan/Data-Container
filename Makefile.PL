use inc::Module::Install;
name 'Data-Container';
all_from 'lib/Data/Container.pm';
perl_version '5.006';

requires 'Class::Accessor::Complex';
requires 'Data::Miscellany';

build_requires 'Test::More';

use_standard_tests(without => 'pod_coverage');
auto_include;
WriteAll;
