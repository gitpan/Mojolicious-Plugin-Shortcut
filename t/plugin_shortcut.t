use Mojo::Base -strict;
use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/lib" }
use Test::More;
use Test::Mojo;

my $app = Test::Mojo->new('App')->app;

# By default ns is app's class
is_deeply $app->shortcut('cl1')->namespaces, ['App'],
  'right default namespaces';

is_deeply $app->shortcut('cl1#action1')->namespaces, ['App'],
  'right default namespaces';

is_deeply $app->shortcut('cl1#action1', namespaces => ['Foo'])->namespaces,
  ['Foo'], 'right namespaces';

done_testing;
