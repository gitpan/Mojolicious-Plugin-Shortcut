use Mojo::Base -strict;
use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/lib" }
use Test::More;
use Mojo::Shortcut;

my $class;
my @args;

@args = ('cl1', namespaces => 'Foo');
is $class = Mojo::Shortcut->new(@args)->class, 'Foo::Cl1',
  'right class loaded';
is $class->action1, 'Foo::Cl1::action1', 'class was really loaded';

# actions doesn't prevent
@args = ('cl1#action1', namespaces => 'Foo');
is $class = Mojo::Shortcut->new(@args)->class, 'Foo::Cl1',
  'right class loaded';

# load with bases, Bar::Cl1 is child of Mojolicious::Controller, Foo::Cl1 isn't
@args = (
  'cl1',
  namespaces   => ['Foo', 'Bar'],
  base_classes => ['Mojolicious::Controller']
);
is $class = Mojo::Shortcut->new(@args)->class, 'Bar::Cl1',
  'right class loaded';
is $class->action1, 'Bar::Cl1::action1', 'class was really loaded';

# respects action, Bar::Cl1 has action bar_action, Foo::Cl1 hasn't
@args = ('cl1#bar_action', namespaces => ['Foo', 'Bar'],);
is $class = Mojo::Shortcut->new(@args)->class, 'Bar::Cl1',
  'right class loaded';
is $class->bar_action, 'Bar::Cl1::bar_action', 'class was really loaded';

done_testing;
