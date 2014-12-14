use Mojo::Base -strict;
use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/lib" }
use Test::More;
use Mojo::Shortcut;

my ($res, $short, $cb, @args);
@args = ('cl1#action2', namespaces => ['Foo', 'Bar']);

$short = Mojo::Shortcut->new(@args);
$cb    = $short->cb;
is $cb, $short->cb, 'same cb';
is $cb->(1, 2), 'foo-1-2', 'right result';

# action changed, but $cb doesn't care
$short->action('not_exists');
is $cb->(1, 2), 'foo-1-2', 'cb is immutable';
is $short->cb, undef, 'cb not defined';

# change base classes
$short = Mojo::Shortcut->new(@args);
$short->base_classes(['Mojolicious::Controller']);
$short->namespaces(['Foo', 'Bar']);
is $short->cb->(1, 2), 'bar-1-2', 'right result';

# exception
ok !eval { $short->action('')->cb; 1 }, 'no cb';
like $@, qr/action must be defined/, 'right exception';
done_testing;
