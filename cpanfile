requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Model::Adaptor';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Runtime';
requires 'Catalyst::View::TT';
requires 'Config::General';
requires 'Function::Parameters';
requires 'autobox::Core';
requires 'Importer';
requires 'Plack' => '1.0039';
requires 'Plack::Middleware::CrossOrigin';

on 'develop' => sub {
    requires 'Catalyst::Devel';
};
