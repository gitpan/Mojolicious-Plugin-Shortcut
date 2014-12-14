use Mojo::Base -strict;
use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/lib" }
use Test::More;
use Mojo::Shortcut;

my ($res, $short, $cb, @args);
@args = ('cl1#action3', namespaces => ['Foo', 'Bar']);

$short = Mojo::Shortcut->new(@args);
is $short->invoke(attr1 => 1, attr2 => 2), 'foo-1-2', 'right invocation';

# base
$short->base_classes(['Mojolicious::Controller']);
is $short->invoke(attr1 => 1, attr2 => 2), 'bar-1-2', 'right invocation';

# exception
$short->action('not_exists');
ok !eval { $short->invoke(attr1 => 1, attr2 => 2); 1 }, 'can not invoke';
like $@, qr/can't invoke/, 'right exception';
done_testing;
