package Bar::Cl1;
use Mojo::Base 'Mojolicious::Controller';
use experimental 'signatures';

has ['attr1', 'attr2'];
sub action1        {'Bar::Cl1::action1'}
sub action2(@args) { join '-', 'bar', @args }
sub action3($self) { join '-', 'bar', $self->attr1, $self->attr2 }
sub bar_action     {'Bar::Cl1::bar_action'}

1;
