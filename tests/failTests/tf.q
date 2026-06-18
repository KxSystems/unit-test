// break on fail
if[not in[;.Q.m.SP] p:.Q.rp "::../../../";.Q.m.SP,:enlist p];
t:use`test;

t.setup[{check::100}]

t.feature `shouldPass
t.assertMatch[{check};100;::];
t.feature `shouldFailAndNotBreak
t.assertMatch[{check};1;([breakOnFail:0b])];
t.feature `shouldFailAndBreak
t.assertMatch[{check};1;([breakOnFail:1b])];
