package Mojo::Shortcut;
use Mojo::Base -base;
use experimental qw( signatures postderef );

use Carp 'croak';
use List::Util 'first';
use Mojo::Loader;
use Mojo::Util 'camelize';

has namespaces => sub { croak 'Shortcut::namespaces should be defined' };

has base_classes => sub { [] };
has ['action', 'moniker'];

sub new($self, @args) {
  if (@args % 2) {
    my ($moniker, $action) = split '#', shift @args;
    push @args, moniker => $moniker, action => $action;
  }
  $self->SUPER::new(@args);
}

sub invoke($self, @args) {
  my $cb;
  unless ($cb = $self->cb) {
    my $cl = $self->class // $self->moniker // 'undefined';
    my $act = $self->action // 'undefined';
    croak "can't invoke $cl::$act";
  }

  $cb->($self->class->new(@args));
}

sub cb($self, @args) {
  croak 'action must be defined' unless my $action = $self->action;
  my $class = $self->class or return;
  \&{"$class::$action"};
}

sub class($self) {
  my $namespaces = $self->namespaces;
  $namespaces = [$namespaces] unless ref $namespaces;
  my @classes = map { join '::', $_, camelize $self->moniker } @$namespaces;

  foreach my $cur (@classes) {
    if (my $e = Mojo::Loader->load($cur)) {
      ref $e ? die $e : next;
    }

    # is not child of any from base_classes
    if ($self->base_classes->@*) {
      next unless first { $cur->isa($_) } $self->base_classes->@*;
    }

    # action defined but not found
    next if $self->action && !$cur->can($self->action);
    return $cur;
  }

  # nothing found
  return;
}

1;

# ABSTRACT: Mojo::Abstract - loading classes and methods by short#cuts

__END__

=pod

=encoding UTF-8

=head1 NAME

Mojo::Shortcut - Mojo::Abstract - loading classes and methods by short#cuts

=head1 VERSION

version 0.003

=head1 SYNOPSIS

  my @args = ('foo#bar', namespaces => ['My']);
  my $shortcut = Mojo::Shortcut->new(@args);

  # find a class My::Foo
  my $class = $shortcut->class;
  $class->bar();

  # get a cb, that can be called as 'My::Foo::bar()' without firts argument
  my $cb = $shortcut->cb;
  $cb->();

  # create an instance of My::Foo like and invoke a method bar;
  # My::Foo->new(attr1 => 'val1')->bar()
  $shortcut->invoke(attr1 => 'val1');

=head1 METHODS

=head2 new

Creates a new object

=head2 cb

Returns a code reference

=head2 invoke

Creates an instance of class and invokes an action immidietly

=head2 class

Finds a class and returns it. Is simmilar like Mojolicious finds a controller class, but also checks
if a class has a method

=head1 ATTRIBUTES

=head2 namespaces

=head2 base_classes

If defined, class method will check if a class is a subclass of base_classes
This attribute is required

=head2 action

action, if is defined, class will check if class returned class can do it

=head2 moniker

Short name of class

=head1 AUTHOR

alexbyk <alex@alexbyk.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by alexbyk.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
