package Data::Container;

# $Id: Container.pm 12604 2007-02-20 12:48:57Z ek $
#
# Implements a container object.

use strict;
use warnings;
use Carp;
use Data::Miscellany 'set_push';
use NEXT;


our $VERSION = '0.04';


use base 'Class::Accessor::Complex';


use overload
    '""' => 'stringify',
    cmp  => sub { "$_[0]" cmp "$_[1]" };


__PACKAGE__
    ->mk_new
    ->mk_array_accessors('items');


sub stringify { join "\n\n" => map { "$_" } $_[0]->items }



sub items_set_push {
    my ($self, @values) = @_;
    set_push @{$self->{items}},
        map {
            ref($_) && UNIVERSAL::isa($self, ref $_) ? $_->items : $_
        }
        @values;
}


sub prepare_comparable {
    my $self = shift;
    $self->NEXT::prepare_comparable(@_);
    $self->items;     # autovivify
}



sub item_grep {
    my ($self, $spec) = @_;
    grep { ref($_) eq $spec } $self->items;
}


1;

__END__

=head1 NAME

Data::Container - base class for objects containing a list of items

=head1 SYNOPSIS

  package My::Container;
  use base 'Data::Container';
  ...

  package main;
  my $container = My::Container->new;
  $container->items_push(...);

=head1 DESCRIPTION

This class implements a container object. The container can contain any
object, scalar or reference you like. Typically you would subclass
Data::Container and implement custom methods for your specific copntainer.

When the container is stringified, it returns the concatenated stringifications of its items, each two items joined by two newlines.

=head1 METHODS

=over 4

=item new

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. 

=item items

An array accessor. See L<Class::Accessor::Complex->mk_array_accessors()> for
details on related methods provided. C<items()> is used to access the items
contained in the container.

=item items_set_push

Like C<items_push()>, and it also takes a list of items to push into the
container, but it doesn't push any items that are already in the container
(items are compared deeply to determine equality).

=item item_grep

Given a package name, it returns those items from the container whose C<ref()>
is equal to that package name.

For example, your container could contain some items of type C<My::Item::Foo>
and some of type C<My::Item::Bar>. If you only want a list of the items of
type C<My::Item::Foo>, you could use:

    my @foo_items = $container->item_grep('My::Item::Foo');

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-data-container@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

