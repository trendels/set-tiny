#!perl -T
use strict;
use warnings;

use Test::More tests => 50;

use Set::Tiny;

my $a = Set::Tiny->new;
my $b = Set::Tiny->new(qw( a b c ));

isa_ok $a, 'Set::Tiny';

is "$a", '()', "empty set stringifies to '$a'";
is "$b", '(a, b, c)', "non-empty set stringifies to '$b'";

is $a->size, 0, "size of $a is 0";
is $b->size, 3, "size of $b is 3";

is_deeply [$a->elements], [], "elements of $a";
is_deeply [$b->elements], [qw( a b c )], "elements of $b";
is_deeply [$b->members], [qw( a b c )], "members() is an alias for elements()";

ok $b->contains(qw( a c )), "$b contains 'a' and 'c'";
ok $b->has(qw( a c )), "has() is an alias for contains()";
ok ! $a->contains('b'), "$a does not contain 'b'";
ok $a->contains(), "$a contains the empty list";

ok $a->is_empty, "$a is empty";
ok ! $b->is_empty, "$b is not empty";

ok $a->is_equal($a), "$a is equal to $a";
ok $b->is_equal($b), "$b is equal to $b";
ok ! $a->is_equal($b), "$a is not equal to $b";

ok $a->is_subset($a), "$a is a subset of $a";
ok $a->is_subset($b), "$a is a subset of $b";
ok $b->is_subset($b), "$b is a subset of $b";
ok ! $b->is_subset($a), "$b is not a subset of $a";

ok $a->is_proper_subset($b), "$a is a proper subset of $b";
ok ! $a->is_proper_subset($a), "$a is not a proper subset of $a";
ok ! $b->is_proper_subset($b), "$b is not a proper subset of $b";
ok ! $b->is_proper_subset($a), "$b is not a proper subset of $a";

ok $b->is_superset($b), "$b is a superset of $b";
ok $b->is_superset($a), "$b is a superset of $a";
ok $a->is_superset($a), "$a is a superset of $a";
ok ! $a->is_superset($b), "$a is not a superset of $b";

ok $b->is_proper_superset($a), "$b is a proper superset of $a";
ok ! $b->is_proper_superset($b), "$b is not a proper superset of $b";
ok ! $a->is_proper_superset($a), "$a is not a proper superset of $a";
ok ! $a->is_proper_superset($b), "$a is not a proper superset of $b";

ok $a->is_disjoint($a), "$a and $a are disjoint";
ok $a->is_disjoint($b), "$a and $b are disjoint";
ok ! $b->is_disjoint($b), "$b and $b are not disjoint";

my $c = Set::Tiny->new(qw( c d e ));

my $d1 = $b->difference($c);
my $d2 = $c->difference($b);

is "$d1", '(a, b)', "difference of $b and $c is $d1";
is "$d2", '(d, e)', "difference of $c and $b is $d2";

my $u = $b->union($c);
my $i = $b->intersection($c);
my $s = $b->symmetric_difference($c);

is "$u", '(a, b, c, d, e)', "union of $b and $c is $u";
is "$i", '(c)', "intersection of $b and $c is $i";
is "$s", '(a, b, d, e)', "symmetric difference of $b and $c is $s";

$s = $b->unique($c);
is "$s", '(a, b, d, e)', "unique() is an alias for symmetric_difference()";

$b->clear;
is "$b", "()", "cleared $b";

$b->insert(qw( a b c d ));
is "$b", "(a, b, c, d)", "inserted into $b";

$b->remove(qw( a b ));
is "$b", "(c, d)", "removed from $b";

$b->delete('c');
is "$b", "(d)", "delete() is an alias for remove()";

$b->invert(qw( c d ));
is "$b", "(c)", "inverted $b";

my $x = $b->clone;
is "$x", "(c)", "cloned $x";

$x->clear;
is "$b", "(c)", "$b is unchanged";

my $y = $b->clone                       # (c)
          ->insert('z')                 # (c, z)
          ->union($u)                   # (a, b, c, d, e, z)
          ->difference($i)              # (a, b, d, e, z)
          ->remove('a')                 # (b, d, e, z)
          ->intersection($u)            # (b, d, e)
          ->symmetric_difference($s)    # (a)
          ;

is "$y", "(a)", "modifying methods can be chained";

