// break on error
if[not in[;.Q.m.SP] p:.Q.rp "::../../../";.Q.m.SP,:enlist p];
t:use`test;

t.setup[{check::100}]

t.feature `shouldPass
t.assertMatch[{check};100;::];
t.feature `shouldFailAndNotBreak
t.assertMatch[{foo};1;([breakOnError:0b])];
t.feature `shouldFailAndBreak
t.assertMatch[{foo};1;([breakOnError:1b])];
