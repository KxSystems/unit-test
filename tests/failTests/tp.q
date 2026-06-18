// test parallel
if[not in[;.Q.m.SP] p:.Q.rp "::../../../";.Q.m.SP,:enlist p];
t:use`test;

t.setup[{check::100}]

t.feature`setGlobal
t.assertTrue[{system "s"};([name:"secondary check";breakOnFail:1b])];
t.assertTrue[{.foo.bar:`bar;1b};([name:"try set without peach"])];
t.assertFail[{.foo.bar:`bar;1b};"noupdate: `.m.test.executens `.foo.bar";([name:"try set with peach";parallel:1b;breakOnFail:1b])];

t.teardown[]
