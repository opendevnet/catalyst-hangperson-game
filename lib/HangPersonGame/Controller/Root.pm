package HangPersonGame::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }


#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

# could fetch rand_img path from hangperson.conf
#has rand_img_path => (is => 'ro', required => 1);


# For debugging
use Data::Dumper;

=encoding utf-8

=head1 NAME

HangPersonGame::Controller::Root - Root Controller for HangPersonGame

=head1 DESCRIPTION

Root controller ( C< ./MyApp/lib/MyApp/Controller/Root.pm> ), from here
we dispatch to the subroutines and method calls below. 

=head1 METHODS

=head2 index

The root page (/)

=cut

# ================================================================ #
#
#  Root Controller:
#
sub index :Path :Args(0)  {
    my ( $self, $c ) = @_;
}

sub create_game : Local :Args(0) {
   my ( $self, $c ) = @_;
   my $game = $c->model('WordGuesser') ;
   $game->set_word() ;
	 ###
   $c->log->debug(" This is the game we are putting in the session\n" .Dumper($game) ) ;
	 ###
	 
   $c->session->{game} =  $game ;
	 
	 ###
   $c->log->debug(" Is it in the session? \n" .Dumper($c->session->{game} ) ) ;
	 ###
	 
	 $c->forward("game");
}

#
# Test with the longest word in the English language:
#
my $longest_word = "pneumonoultramicroscopicsilicovolcanoconiosis";

sub create_supergame : Local :Args(0) {
   my ( $self, $c ) = @_;       
   my $game = $c->model('WordGuesser') ;
   $game->set_word($longest_word) ;
   $c->log->debug(" This is the game we are putting in the session\n" .Dumper($game) ) ;
   $c->session->{game} =  $game ;
   $c->log->debug(" Is it in the session? \n" .Dumper($c->session->{game} ) ) ;
   $c->forward("supergame");
}         

sub supergame :Private {
	my ( $self, $c ) = @_ ;
  my $game = $c->session->{game} ;
	my $word = $game->{word} ;
	$c->stash( template => 'super.tt') ;
	$c->detach('guess') ;
}

sub game :Private {
	 my ( $self, $c ) = @_;
  ### 
	$c->log->debug("\n\nXXXXXXXXXXXXXXX START A GAME ! XXXXXXXXXXXXXXXX\n\n" );
  $c->log->debug(" Get the game out of the session\n" .Dumper($c->session->{game} ) ) ;
  ###
  my $game = $c->session->{game} ;
	my $word = $game->{word} ;
  ###
	$c->log->debug("\n++++++++ THE WORD ++++++++\n" .Dumper($word) ); 
	$c->log->debug( $c->stash->{word} ); 
	###
	$c->stash( template => 'show.tt');
	$c->detach('guess');
}

sub guess :Local :Arg(0) {
	my ( $self, $c ) = @_;

	# check for exisiting session or create one
	#	$c->session->{game} ||= $c->model('WordGuesser');
	#
	# This does not work correctly because the current subroutine
	# will continue to execute (i.e. dispatch is not stopped):
  	#
  	# $c->session->{game} ||= $c->res->redirect("/create_game") ;
	#
	# We need to detach from the sub guess { } route and
	# go to create_game
	#
	unless ( $c->session->{game} ) { $c->detach("/create_game") ;  } ; 
	my $game = $c->session->{game} ;
	my $word = lc $game->{word} ;

	$c->log->debug("\n++++++++ THE WORD LATER ++++++++\n" .Dumper($word) ); 

	my $guessed_letter  = $c->request->body_params->{guess} ; 

	$game->guess($guessed_letter);

	my $badguesses = join "", $game->wrong_guesses;
	my $goodguesses = join "", $game->guesses;
	my $maskedword = $game->word_with_guesses() ;

	$c->stash( badguesses => $badguesses ) ; 
	$c->stash( goodguesses => $goodguesses ) ; 
	$c->stash( last_guess => $guessed_letter );
	$c->stash( maskedword => $maskedword );
	$c->stash( word => $word );

	$c->log->debug("WTF?!?!? the STASH??!".Dumper($c->stash));

	if ( $game->_check_win_or_lose  eq "win" ) { 
			$c->detach('win');
		}
		elsif ( $game->_check_win_or_lose  eq "lose"  )  {
			$c->detach('lose');
	}	

	$c->stash( template => 'show.tt');
}

sub win :Private {
	my ( $self, $c ) = @_;
  my @files = glob('root/static/images/img*.jpg'); 
	my $nimg = scalar @files; 
	my $randimg = "/static/images/img". int ( rand($nimg) ). ".jpg" ;   
	$c->log->debug($randimg) ;
	$c->stash( randimg => $randimg ) ; 
	$c->stash( template => 'win.tt');

}

sub lose :Private {
	my ( $self, $c ) = @_;
	$c->stash( template => 'lose.tt');
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Graham Todd

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;

__END__
