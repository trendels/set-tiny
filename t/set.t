#!perl -T
use strict;
use warnings;

use Test::More tests => 57;

use Set::Tiny;

my $a = Set::Tiny->new;
my $b = Set::Tiny->new(qw( a b c ));

isa_ok $a, 'Set::Tiny';

sub to_s { join '', map { ref $_ eq 'Set::Tiny' ? $_->as_string : $_ } @_ }

is $a->as_string, '()', "empty set stringification";
is $b->as_string, '(a, b, c)', "non-empty set stringification";

is $a->size, 0, to_s("size of ", $a, " is 0");
is $b->size, 3, to_s("size of ", $b, " is 3");

is $b->element('a'), 'a', "element()";
is $b->element('z'), undef, "element() on non-existing element";
is $b->member('a'), 'a', "member() is an alias for element()";

is_deeply [$a->elements], [], "elements() of emtpy set";
is_deeply [sort $b->elements], [qw( a b c )], "elements()";
is_deeply [sort $b->members], [qw( a b c )], "members() is an alias for elements()";

ok $b->contains(qw( a c )), to_s($b, " contains 'a' and 'c'");
ok $b->has(qw( a c )), "has() is an alias for contains()";
ok $b->includes(qw( a c )), "includes() is an alias for contains()";
ok ! $a->contains('b'), to_s($a, " does not contain 'b'");
ok $a->contains(), to_s($a, " contains the empty list");

ok $a->is_null, to_s($a, " is empty");
ok ! $b->is_null, to_s($b, " is not empty");

ok $a->is_equal($a), to_s($a, " is equal to ", $a);
ok $b->is_equal($b), to_s($b, " is equal to ", $b);
ok ! $a->is_equal($b), to_s($a, " is not equal to ", $b);

ok $a->is_subset($a), to_s($a, " is a subset of ", $a);
ok $a->is_subset($b), to_s($a, " is a subset of ", $b);
ok $b->is_subset($b), to_s($b, " is a subset of ", $b);
ok ! $b->is_subset($a), to_s($b, " is not a subset of ", $a);

ok $a->is_proper_subset($b), to_s($a, " is a proper subset of ", $b);
ok ! $a->is_proper_subset($a), to_s($a, " is not a proper subset of ", $a);
ok ! $b->is_proper_subset($b), to_s($b, " is not a proper subset of ", $b);
ok ! $b->is_proper_subset($a), to_s($b, " is not a proper subset of ", $a);

ok $b->is_superset($b), to_s($b, " is a superset of ", $b);
ok $b->is_superset($a), to_s($b, " is a superset of ", $a);
ok $a->is_superset($a), to_s($a, " is a superset of ", $a);
ok ! $a->is_superset($b), to_s($a, " is not a superset of ", $b);

ok $b->is_proper_superset($a), to_s($b, " is a proper superset of ", $a);
ok ! $b->is_proper_superset($b), to_s($b, " is not a proper superset of ", $b);
ok ! $a->is_proper_superset($a), to_s($a, " is not a proper superset of ", $a);
ok ! $a->is_proper_superset($b), to_s($a, " is not a proper superset of ", $b);

ok $a->is_disjoint($a), to_s($a, " and ", $a, " are disjoint");
ok $a->is_disjoint($b), to_s($a, " and ", $b, " are disjoint");
ok ! $b->is_disjoint($b), to_s($b, " and ", $b, " are not disjoint");

my $c = Set::Tiny->new(qw( c d e ));

my $d1 = $b->difference($c);
my $d2 = $c->difference($b);

is $d1->as_string, '(a, b)', to_s("difference of ", $b, " and ", $c, " is ", $d1);
is $d2->as_string, '(d, e)', to_s("difference of ", $c, " and ", $b, " is ", $d2);

my $u = $b->union($c);
my $i = $b->intersection($c);
my $s = $b->symmetric_difference($c);

is $u->as_string, '(a, b, c, d, e)', to_s("union of ", $b, " and ", $c, " is ", $u);
is $i->as_string, '(c)', to_s("intersection of ", $b, " and ", $c, " is ", $i);
is $s->as_string, '(a, b, d, e)', to_s("symmetric difference of ", $b, " and ", $c, " is ", $s);

$s = $b->unique($c);
is $s->as_string, '(a, b, d, e)', "unique() is an alias for symmetric_difference()";

$b->clear;
is $b->as_string, "()", "clear()";

my $n = $b->insert(qw( a b c ));
is $b->as_string, "(a, b, c)", "insert()";
is $n, 3, "insert() returns the number of inserted elements";
$n = $b->insert(qw( c c d ));
is $n, 1, "existing elements are not counted";

$n = $b->remove(qw( a ));
is $b->as_string, "(b, c, d)", "remove()";
is $n, 1, "remove() returns the number of removed elements";
$n = $b->remove(qw( b b x ));
is $n, 1, "only elements actually removed are counted";

$b->delete('c');
is $b->as_string, "(d)", "delete() is an alias for remove()";

$b->invert(qw( c d ));
is $b->as_string, "(c)", "invert()";

my $x = $b->clone;
is $x->as_string, "(c)", "clone()";

$x->clear;
is $b->as_string, "(c)", "clone is unchanged()";

