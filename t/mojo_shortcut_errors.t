use Mojo::Base -strict;
use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/lib" }
use Mojolicious;
use Test::More;
use Mojo::Shortcut;

my $short = Mojo::Shortcut->new(
  moniker    => 'cl1',
  action     => 'action1',
  namespaces => ['Foo']
);
ok $short->class, 'class is found';

NOT_FOUND: {
  local $short->{moniker} = 'clnot';
  is $short->class, undef, 'class correctly not found because of moniker';
}

NOT_FOUND: {
  local $short->{action} = 'actionnot';
  is $short->class, undef, 'class correctly not found because of action';
}

# exeption
ERR: {
  local $short->{moniker} = 'fail';
  ok !eval { $short->class; 1 }, 'died';
  like $@, qr/Foo::Fail failed/, "Right exception";
}
done_testing;
