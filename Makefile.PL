use inc::Module::Install;

name 'Path-Finder';
all_from 'lib/Path/Finder.pm';

build_requires 'Test::More';

auto_install;

WriteAll;

