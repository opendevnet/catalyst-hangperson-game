use strict;
use warnings;
use lib './lib';
use HangPersonGame;

my $app = HangPersonGame->apply_default_middlewares(HangPersonGame->psgi_app);
$app;

