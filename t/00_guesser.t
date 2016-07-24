use strict;
use warnings;
use Test::More qw(no_plan);
use List::MoreUtils qw/uniq/;
use lib './lib';
use Importer 'WordGuesser' => qw< guess show_word word_with_guesses >;

BEGIN { use_ok 'HangPersonGame::Model::WordGuesser' ; } 

ok(
  ( my $gtest = HangPersonGame::Model::WordGuesser->new ),
  'Constructed game object ok'
);

my $g = WordGuesser->new() ; 
use DDP;
p $g;
$g->set_word(); 

#is ( $g->show_word , $g->{word} , "Game object method same as word attribute") ;
$g->guess($_) for qw<a e i o u>;
is ( length $g->word_with_guesses , length $g->{'word'} , "Masked version word is correct length");
#is ( length $g->word_with_guesses , length $g->show_word , "Masked version word is correct length");

p $g->word_with_guesses ; 
$g->guesses; 
$g->show_word ; 

print "="x25;
print "\n";

my $g2 = WordGuesser->new ;
$g2->set_word("textual");
p $g2;
$g2->show_word ;
$g2->guess($_) for qw<x z>;

is(
   "@{ $g2->guesses }" ,
#   "$g2->guessed_str" ,
  "x",
  'Correct guess registered'
);
is(
	"@{ $g2->wrong_guesses }",
  "z",
  'Incorrect guess registered'
);

$g2->guess($_) for qw<p q w y o d>;

my $g3 = WordGuesser->new() ; 
$g3->set_word("sadness");
$g3->guess($_) for qw<p p q w y o d q>;
my @test_guess = uniq @{ $g3->wrong_guesses };

is(
	"@{ $g3->wrong_guesses }",
  "@test_guess",
  'No duplicate guesses - mind p\'s and q\'s'
);
