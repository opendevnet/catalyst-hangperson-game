perl -Ilib -MDDP -MWordGuesser -E '$s=WordGuesser->new(); $s->set_word("textual"); say $s->show_word; p $s; p $s->{word}; $s->guess($_) for qw<a e i o u>; p $s->guesses; p $s->wrong_guesses ; p $s->word_with_guesses ;  $s2=WordGuesser->new() ; say "\n"; say "="x25; $s2->set_word("thespian"); say $s2->show_word;  p $s2; p $s2->{word}; $s2->guess($_) for qw<a e i o u>; p $s2->guesses; p $s2->wrong_guesses ; p $s2->word_with_guesses ;'
