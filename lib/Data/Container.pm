package Data::Container;

# $Id: Container.pm 12604 2007-02-20 12:48:57Z ek $
#
# Implements a container object.

use strict;
use warnings;
use Carp;
use Data::Miscellany 'set_push';


our $VERSION = '0.06';


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

    my $obj = Data::Container->new;
    my $obj = Data::Container->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

=item clear_items

    $obj->clear_items;

Deletes all elements from the array.

=item count_items

    my $count = $obj->count_items;

Returns the number of elements in the array.

=item index_items

    my $element   = $obj->index_items(3);
    my @elements  = $obj->index_items(@indices);
    my $array_ref = $obj->index_items(@indices);

Takes a list of indices and returns the elements indicated by those indices.
If only one index is given, the corresponding array element is returned. If
several indices are given, the result is returned as an array in list context
or as an array reference in scalar context.

=item items

    my @values    = $obj->items;
    my $array_ref = $obj->items;
    $obj->items(@values);
    $obj->items($array_ref);

Get or set the array values. If called without an arguments, it returns the
array in list context, or a reference to the array in scalar context. If
called with arguments, it expands array references found therein and sets the
values.

=item items_clear

    $obj->items_clear;

Deletes all elements from the array.

=item items_count

    my $count = $obj->items_count;

Returns the number of elements in the array.

=item items_index

    my $element   = $obj->items_index(3);
    my @elements  = $obj->items_index(@indices);
    my $array_ref = $obj->items_index(@indices);

Takes a list of indices and returns the elements indicated by those indices.
If only one index is given, the corresponding array element is returned. If
several indices are given, the result is returned as an array in list context
or as an array reference in scalar context.

=item items_pop

    my $value = $obj->items_pop;

Pops the last element off the array, returning it.

=item items_push

    $obj->items_push(@values);

Pushes elements onto the end of the array.

=item items_set

    $obj->items_set(1 => $x, 5 => $y);

Takes a list of index/value pairs and for each pair it sets the array element
at the indicated index to the indicated value. Returns the number of elements
that have been set.

=item items_shift

    my $value = $obj->items_shift;

Shifts the first element off the array, returning it.

=item items_splice

    $obj->items_splice(2, 1, $x, $y);
    $obj->items_splice(-1);
    $obj->items_splice(0, -1);

Takes three arguments: An offset, a length and a list.

Removes the elements designated by the offset and the length from the array,
and replaces them with the elements of the list, if any. In list context,
returns the elements removed from the array. In scalar context, returns the
last element removed, or C<undef> if no elements are removed. The array grows
or shrinks as necessary. If the offset is negative then it starts that far
from the end of the array. If the length is omitted, removes everything from
the offset onward. If the length is negative, removes the elements from the
offset onward except for -length elements at the end of the array. If both the
offset and the length are omitted, removes everything. If the offset is past
the end of the array, it issues a warning, and splices at the end of the
array.

=item items_unshift

    $obj->items_unshift(@values);

Unshifts elements onto the beginning of the array.

=item pop_items

    my $value = $obj->pop_items;

Pops the last element off the array, returning it.

=item push_items

    $obj->push_items(@values);

Pushes elements onto the end of the array.

=item set_items

    $obj->set_items(1 => $x, 5 => $y);

Takes a list of index/value pairs and for each pair it sets the array element
at the indicated index to the indicated value. Returns the number of elements
that have been set.

=item shift_items

    my $value = $obj->shift_items;

Shifts the first element off the array, returning it.

=item splice_items

    $obj->splice_items(2, 1, $x, $y);
    $obj->splice_items(-1);
    $obj->splice_items(0, -1);

Takes three arguments: An offset, a length and a list.

Removes the elements designated by the offset and the length from the array,
and replaces them with the elements of the list, if any. In list context,
returns the elements removed from the array. In scalar context, returns the
last element removed, or C<undef> if no elements are removed. The array grows
or shrinks as necessary. If the offset is negative then it starts that far
from the end of the array. If the length is omitted, removes everything from
the offset onward. If the length is negative, removes the elements from the
offset onward except for -length elements at the end of the array. If both the
offset and the length are omitted, removes everything. If the offset is past
the end of the array, it issues a warning, and splices at the end of the
array.

=item unshift_items

    $obj->unshift_items(@values);

Unshifts elements onto the beginning of the array.

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

Data::Container inherits from L<Class::Accessor::Complex>.

The superclass L<Class::Accessor::Complex> defines these methods and
functions:

    mk_abstract_accessors(), mk_array_accessors(), mk_boolean_accessors(),
    mk_class_array_accessors(), mk_class_hash_accessors(),
    mk_class_scalar_accessors(), mk_concat_accessors(),
    mk_forward_accessors(), mk_hash_accessors(), mk_integer_accessors(),
    mk_new(), mk_object_accessors(), mk_scalar_accessors(),
    mk_set_accessors(), mk_singleton()

The superclass L<Class::Accessor> defines these methods and functions:

    _carp(), _croak(), _mk_accessors(), accessor_name_for(),
    best_practice_accessor_name_for(), best_practice_mutator_name_for(),
    follow_best_practice(), get(), make_accessor(), make_ro_accessor(),
    make_wo_accessor(), mk_accessors(), mk_ro_accessors(),
    mk_wo_accessors(), mutator_name_for(), set()

The superclass L<Class::Accessor::Installer> defines these methods and
functions:

    install_accessor()

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2004-2008 by the authors.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

