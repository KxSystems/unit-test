// test repeats
if[not in[;.Q.m.SP] p:.Q.rp "::../../../";.Q.m.SP,:enlist p];
t:use`test;

t.setup[{check::100}]

t.feature`runMultiple

t.assertMatch[{1+1};2;([repeats:10])]
t.assertMatch[{1+check};101;::]

t.feature`runRepeatsAndFail
t.assertTrue[{0.5<rand 1f};([repeats:10])]

t.feature`runRepeatsAndError
t.assertTrue[{$[0.5<rand 1f;'`err;::]};([repeats:10])]

t.feature`runRepeatsAndBreakOnError
t.assertTrue[{$[0.5<rand 1f;'`err;::]};([repeats:10;breakOnError:1b])]
