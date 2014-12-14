package Foo::Cl1;
use Mojo::Base -base;
use experimental 'signatures';

has ['attr1', 'attr2'];
sub action1        {'Foo::Cl1::action1'}
sub action2(@args) { join '-', 'foo', @args }
sub action3($self) { join '-', 'foo', $self->attr1, $self->attr2 }

1;
