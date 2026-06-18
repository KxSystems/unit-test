if[not in[;.Q.m.SP] p:.Q.rp "::../../";.Q.m.SP,:enlist p];
t:use`test;

// single string
t.config ([run:"bar"])

t.feature `foo
t.assertTrue[{1b};([name:"testFoo:v1";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"testFoo:v2";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"testBar:v3";description:"shouldn't run"])]
t.feature `bar
t.assertTrue[{1b};([name:"testFoo"])]
t.assertTrue[{1b};([name:"testBar"])]
t.assertTrue[{1b};([name:"bar"])]

// single symbol
t.config ([run:`foo])

t.feature `foo
t.assertTrue[{1b};([name:"testFoo:v1"])]
t.assertTrue[{1b};([name:"testFoo:v2"])]
t.assertTrue[{1b};([name:"testBar:v3"])]
t.feature `bar
t.assertTrue[{1b};([name:"testFoo";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"testBar";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"bar";description:"shouldn't run"])]

// single string simple regex
t.config ([run:"foo:testB*"])

t.feature `foo
t.assertTrue[{1b};([name:"testFoo:v1";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"testFoo:v2";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"testBar:v3"])]
t.feature `bar
t.assertTrue[{1b};([name:"testFoo";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"testBar";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"bar";description:"shouldn't run"])]

// single string complex regex
t.config ([run:"foo:testfoo:v[1-2]"])

t.feature `foo
t.assertTrue[{1b};([name:"testfoo:v1"])]
t.assertTrue[{1b};([name:"testfoo:v2"])]
t.assertTrue[{1b};([name:"testbar:v3";description:"shouldn't run"])]
t.feature `bar
t.assertTrue[{1b};([name:"testfoo";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"testbar";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"bar";description:"shouldn't run"])]

// single string complex regex on feature
t.config ([run:"*:test*"])

t.feature `foo
t.assertTrue[{1b};([name:"testfoo:v1"])]
t.assertTrue[{1b};([name:"testfoo:v2"])]
t.assertTrue[{1b};([name:"testbar:v3"])]
t.feature `bar
t.assertTrue[{1b};([name:"testfoo"])]
t.assertTrue[{1b};([name:"testbar"])]
t.assertTrue[{1b};([name:"bar";description:"shouldn't run"])]


// multiple string regex
t.config ([run:("foo:testFoo:v[1-2]";"bar:t*")])

t.feature `foo
t.assertTrue[{1b};([name:"testFoo:v1"])]
t.assertTrue[{1b};([name:"testFoo:v2"])]
t.assertTrue[{1b};([name:"testBar:v3";description:"shouldn't run"])]
t.feature `bar
t.assertTrue[{1b};([name:"testFoo"])]
t.assertTrue[{1b};([name:"testBar"])]
t.assertTrue[{1b};([name:"bar";description:"shouldn't run"])]

// single symbol specific
t.config ([run:`bar:testFoo])

t.feature `foo
t.assertTrue[{1b};([name:"testFoo:v1";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"testFoo:v2";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"testBar:v3";description:"shouldn't run"])]
t.feature `bar
t.assertTrue[{1b};([name:"testFoo"])]
t.assertTrue[{1b};([name:"testBar";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"bar";description:"shouldn't run"])]

// multiple symbol specific
t.config ([run:`bar:testFoo`bar:testBar])

t.feature `foo
t.assertTrue[{1b};([name:"testFoo:v1";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"testFoo:v2";description:"shouldn't run"])]
t.assertTrue[{1b};([name:"testBar:v3";description:"shouldn't run"])]
t.feature `bar
t.assertTrue[{1b};([name:"testFoo"])]
t.assertTrue[{1b};([name:"testBar"])]
t.assertTrue[{1b};([name:"bar";description:"shouldn't run"])]

rep:t.getReport`;
n1:exec count i from rep where filename like "treg.q", status like "skipped", description like "" // skipped but shouldnt
n2:exec count i from rep where filename like "treg.q", status like "pass", description like "shouldn't run" // skipped but shouldnt
if[sum n1,n2;'"treg.q tests failed"]


t.teardown[]
