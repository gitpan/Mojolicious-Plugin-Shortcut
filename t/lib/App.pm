package App;
use Mojo::Base 'Mojolicious';
sub startup { shift->plugin('shortcut') }
1;
