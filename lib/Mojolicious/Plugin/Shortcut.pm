package Mojolicious::Plugin::Shortcut;
use Mojo::Base 'Mojolicious::Plugin';
use experimental 'signatures';

our $VERSION = '0.003';    # TRIAL VERSION

use Mojo::Shortcut;

sub register($self, $app, $options) {
  $app->helper(
    'shortcut' => sub($c,@args) {
      my $short = Mojo::Shortcut->new(@args);
      $short->{namespaces} //= [ref $c->app];
      $short;
    }
  );
}

1;

# ABSTRACT: Plugin for Mojo::Shortcut to use short#action like invocations

__END__

=pod

=encoding UTF-8

=head1 NAME

Mojolicious::Plugin::Shortcut - Plugin for Mojo::Shortcut to use short#action like invocations

=head1 VERSION

version 0.003

=head1 SYNOPSIS

  $app->plugin('Shortcut');

=head1 DESCRIPTION

Add a helper 'shorctut' also provides an application class as a namespaces attribute to Mojo::Shortcut

=head1 METHODS

=head2 register

Loads and registers a plugin

=head1 HELPERS

=head2 shorcut

Creates a new Mojo::Shortcut object. Also sets a C<namespaces> to application's class, if C<namespaces>
attribute isn't provided

=head1 AUTHOR

alexbyk <alex@alexbyk.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by alexbyk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
