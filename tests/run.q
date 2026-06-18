if[not in[;.Q.m.SP] p:.Q.rp "::../../";.Q.m.SP,:enlist p];
t:use`test;
t.runFile[`:t.q];
t.runFile[`:treg.q];
t.runFile[`:tba.q];
{@[t.runFile;x;{1b}]} each ` sv' f,'key f:`:failTests; // these tests break on fail, so error trapping  as don't want to exit

0N!"If you're seeing this message the tests passed :)";

r:t.junitReport t.getReport[];

// Optionally write the xml for inspection
// `:junit.xml 0: r;

exit 0;
