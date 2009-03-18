use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Set::Tiny',
    license             => 'perl',
    dist_author         => 'Stanis Trendelenburg <stanis.trendelenburg@gmail.com>',
    dist_version_from   => 'lib/Set/Tiny.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Set-Tiny-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
