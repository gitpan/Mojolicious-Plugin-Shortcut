use Mojo::Base -strict;
use Mojo::Shortcut;
use Test::More;
use Test::Mojo;

my $short;

$short = Mojo::Shortcut->new('cl1');
is $short->moniker, 'cl1', 'right moniker';

# moniker#action
$short = Mojo::Shortcut->new(
  'cl1#action1',
  namespaces   => ['Foo'],
  base_classes => ['Bar']
);
is $short->moniker, 'cl1',     'right moniker';
is $short->action,  'action1', 'right action';
is_deeply $short->namespaces,   ['Foo'], 'right namespaces';
is_deeply $short->base_classes, ['Bar'], 'right base_classes';

# long form
is_deeply $short,
  Mojo::Shortcut->new(
  moniker      => 'cl1',
  action       => 'action1',
  namespaces   => ['Foo'],
  base_classes => ['Bar']
  );

done_testing;
exit;
