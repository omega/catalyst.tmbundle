use inc::Module::Install;

name 'MyLine';
all_from 'lib/MyLine.pm';

requires 'Catalyst::Runtime' => '5.7099_03';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'parent';
requires 'YAML'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats

requires 'Catalyst::Model::S3';
requires 'Catalyst::Plugin::Assets';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
