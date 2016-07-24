use strict;
use warnings;
#no strict 'refs' ;
package WordGuesser ;

# ABSTRACT: Guess words from remote random word services

use Function::Parameters;
use Carp 'carp';
use autobox::Core ;

# The following will work with Importer as:
# use Importer 'WordGuesser' => qw/guess .. /;
#
our @EXPORT_OK = qw/ 
  guess guesses wrong_guesses
  _check_win_or_lose word
  word_with_guesses show_word
  get_word word set_word
/;	

method new( $self: ) { return bless {  
     guesses => [] , 
     wrong_guesses => [] , 
  } , $self ; 
}

method set_word {
$self->{word} = lc ( shift || $self->get_word() ) ;
}

method guess ($self: $letter ) {
	unless ( $letter =~ /\S/ ) { 
		carp "Empty string"; 
		return ;
	}

  if ($letter !~ /[A-Z]/i ) {
		carp "Not a letter"  ;
		return ;
	}

  my $word = lc $self->{word} ;
	$letter = lc substr $letter , 0 , 1 ; # only one letter guesses
	push @{ $self->{guesses} } , $_ for $letter =~ /[($word)]/gi  ;
   
  for ( $letter =~ /[^($word)]/gi ) {     # no duplicate guesses
    push @{$self->{wrong_guesses}} , $_ unless grep /$letter/, @{$self->{wrong_guesses}}
  }    

}

method guesses {
  return wantarray ? @{ $self->{guesses} } : $self->{guesses} ;
}

method guessed_str {
my $guesses_str = join " ", @{ $self->{guesses} } ;
return $guesses_str ;
}

method wrong_guesses {
return wantarray ? @{ $self->{wrong_guesses} } : $self->{wrong_guesses} ;
}

method show_word { 
  print $self->{word} , "\n" ;
}

method word_with_guesses {
# Mask any letter in the word unless correctly guessed
 my $list_of_guesses = "" ;
 $list_of_guesses = join "", @{ $self->guesses } ;
 my $rx = qr/[^ $list_of_guesses ]/  ; 
 (my $masked = lc $self->{word} )  =~ s/$rx/-/gi ;
 return $masked ;
}

method get_word {

  my @urls = qw<
     http://watchout4snakes.com/wo4snakes/Random/RandomWord
     http://randomword.setgetgo.com/get.php
     
  >;

my $url = $urls[ int rand (~~@urls) ]; 

  use HTTP::Tiny;
  
  my $word = HTTP::Tiny->new
    ->post( $url, { headers => { 'content-length' => '0'}, })
    ->{content};

  return $word ;
}

method _check_win_or_lose {
	if ( $self->{wrong_guesses}->length > 6 ){
		return "lose";
	}	
  elsif ( $self->word_with_guesses !~ /-/ ) { 
    return "win" ;
  }
  else {
    return "play" ;
  }
}

1;

=encoding utf8

=head1 NAME

WordGuesser - TODO

=head1 SYNOPSIS

TODO

=head1 DESCRIPTION

TODO

=head1 ATTRIBUTES
TODO
=head1 METHODS

TODO
=head1 AUTHOR

Graham Todd

=head1 COPYRIGHT AND LICENSE

TODO

=head1 SEE ALSO

TODO

=cut
