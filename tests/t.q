if[not in[;.Q.m.SP] p:.Q.rp "::../../";.Q.m.SP,:enlist p];
t:use`test;
// simple tests


t.setup[{check::100}]

t.config ([run:`assertTypeWithShort])

t.feature`assertTypeWithShort

t.assertType[{1i+1i};-6h;::]
t.assertType["1i+1i";-6h;::]
t.assertType[{1+check};-7h;::]
t.assertType["1+check";-7h;::]

t.feature`assertTypeWithChar

t.assertType[{1i+1i};"i";::]
t.assertType["1i+1i";"i";::]
t.assertType[{1+check};"j";::]
t.assertType["1+check";"j";::]

t.feature`assertMatch

t.assertMatch[{1+1};2;::]
t.assertMatch["1+1";2;::]
t.assertMatch[{1+check};101;::]
t.assertMatch["1+check";101;::]


t.feature`assertEqual

t.assertEqual[{1+1};2;::]
t.assertEqual["1+1";2;::]
t.assertEqual[{1+check};101;::]
t.assertEqual["1+check";101;::]

t.feature`assertTrue

t.assertTrue[{2~1+1};::]
t.assertTrue["2~1+1";::]
t.assertTrue[{101~1+check};::]
t.assertTrue["101~1+check";::]

t.feature`assertFalse

t.assertFalse[{3~1+1};::]
t.assertFalse["3~1+1";::]
t.assertFalse[{102~1+check};::]
t.assertFalse["102~1+check";::]

t.feature`assertNull

t.assertNull[{0Nj};::]
t.assertNull["0Nj";::]
t.assertNull[{::};::]
t.assertNull["::";::]

t.feature`assertError

t.assertError[{1+`f};"type";::]
t.assertError["1+`f";"type";::]

t.teardown[]

// order

t.setup[{foo::1}]

t.feature[`foo]
t.before[{foo::2}]
t.assertMatch[{foo};2;::]

t.feature[`bar]
t.assertMatch[{foo};1;::]

t.teardown[]; // purge the setup namespace

t.feature[`foobar]
t.assertError[{foo};"foo";::]

t.teardown[]

// test config

t.setup[{check::100}]

t.config ([run:`selective])

t.feature `selective
t.assertMatch[{1+1};2;::]
t.feature `shouldNotRun
t.assertMatch[{1+1};2;::]

t.config ([run:`;skip:`])

t.feature `shouldRun
t.assertMatch[{1+1};2;::]

t.teardown[]

// test mocking

.bar.foo:1b;

t.setup[{foo::1}]

t.unmock `                  // should pass without anything mocked
t.feature[`foo]
t.before[{foo::2}]
t.assertMatch[{foo};2;::]
t.mock[`foo;3]
t.assertMatch[{foo};3;::]
t.mock[`foo;4]
t.assertMatch[{foo};4;::]
t.unmock[`foo]
t.assertMatch[{foo};2;::]

t.feature[`bar]
t.assertMatch[{foo};1;::]
t.mock[`.foo.bar;10];
t.mock[`a.b.c;10];
t.mock[`.a.b.c;10];
t.mock[`.bar.foo;2];
t.mock[`somethingThatDoesntExist;10]
t.mock[`foo;10]
t.assertMatch[{somethingThatDoesntExist};10;::]
t.assertMatch[{foo};10;::]
t.unmock `
t.assertError[{somethingThatDoesntExist};"somethingThatDoesntExist";::]
t.assertMatch[{foo};1;::]

t.teardown[]; // purge the setup namespace

t.feature[`foogone]
t.assertError[{foo};"foo";::]

t.feature[`unmockNS];
t.mock[`.bar.foo;1];
t.assertMatch[{.bar.foo};1;::]
t.unmock `.bar
t.mock[`.something;1]
t.assertMatch[{.something};1;::]
t.unmock `.something
t.assertMatch[{.something};();::]

t.teardown[]



