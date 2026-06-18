if[not in[;.Q.m.SP] p:.Q.rp "::../../";.Q.m.SP,:enlist p];
t:use`test;
t.setup[{foo::1}]
t.config ([skip:`last])

/ ── foo: before + after only ──────────────────────────────────────────────
t.feature `foo
t.before[{0N!"before foo"}]
t.assertTrue[{1b};([name:"runs"])]
t.after[{0N!"after foo"}]

/ ── bar: before + after, single assert ────────────────────────────────────
t.feature `bar
t.before[{0N!"before bar"}]
t.after[{0N!"after bar"}]
t.assertTrue[{1b};([name:"runs"])]

/ ── foobar: before + after, single assert ─────────────────────────────────
t.feature `foobar
t.before[{0N!"before foobar"}]
t.after[{0N!"after foobar"}]
t.assertTrue[{1b};([name:"runs"])]

/ ── last: skipped via config ───────────────────────────────────────────────
t.feature `last
t.before[{0N!"before last"}]
t.after[{0N!"after last"}]
t.assertTrue[{1b};([name:"skips"])]

/ ── nobefore: after only ───────────────────────────────────────────────────
t.feature `nobefore
t.assertTrue[{1b};([name:"runs"])]
t.after[{0N!"after nobefore"}]

/ ── noafter: before only ───────────────────────────────────────────────────
t.feature `noafter
t.before[{0N!"before noafter"}]
t.assertTrue[{1b};([name:"runs"])]

/ ── noeither: no before/after/each ────────────────────────────────────────
t.feature `noeither
t.assertTrue[{1b};([name:"runs"])]

/ ── eachonly: beforeEach + afterEach, no before/after, multiple asserts ───
t.feature `eachonly
t.beforeEach[{0N!"beforeEach eachonly"}]
t.afterEach[{0N!"afterEach eachonly"}]
t.assertTrue[{1b};([name:"runs 1"])]
t.assertTrue[{1b};([name:"runs 2"])]
t.assertTrue[{1b};([name:"runs 3"])]

/ ── eachwithwrap: before + beforeEach + afterEach + after ─────────────────
t.feature `eachwithwrap
t.before[{0N!"before eachwithwrap"}]
t.beforeEach[{0N!"beforeEach eachwithwrap"}]
t.afterEach[{0N!"afterEach eachwithwrap"}]
t.after[{0N!"after eachwithwrap"}]
t.assertTrue[{1b};([name:"runs 1"])]
t.assertTrue[{1b};([name:"runs 2"])]
t.assertTrue[{1b};([name:"runs 3"])]

/ ── eachnoafter: beforeEach only, multiple asserts ────────────────────────
t.feature `eachnoafter
t.beforeEach[{0N!"beforeEach eachnoafter"}]
t.assertTrue[{1b};([name:"runs 1"])]
t.assertTrue[{1b};([name:"runs 2"])]

/ ── eachnobefore: afterEach only, multiple asserts ────────────────────────
t.feature `eachnobefore
t.afterEach[{0N!"afterEach eachnobefore"}]
t.assertTrue[{1b};([name:"runs 1"])]
t.assertTrue[{1b};([name:"runs 2"])]

/ ── eachbeforewrap: before + beforeEach only (no afterEach/after) ─────────
t.feature `eachbeforewrap
t.before[{0N!"before eachbeforewrap"}]
t.beforeEach[{0N!"beforeEach eachbeforewrap"}]
t.assertTrue[{1b};([name:"runs 1"])]
t.assertTrue[{1b};([name:"runs 2"])]

/ ── eachafterwrap: afterEach + after only (no before/beforeEach) ──────────
t.feature `eachafterwrap
t.afterEach[{0N!"afterEach eachafterwrap"}]
t.after[{0N!"after eachafterwrap"}]
t.assertTrue[{1b};([name:"runs 1"])]
t.assertTrue[{1b};([name:"runs 2"])]

/ ── singleeach: beforeEach + afterEach with only one assert ───────────────
t.feature `singleeach
t.beforeEach[{0N!"beforeEach singleeach"}]
t.afterEach[{0N!"afterEach singleeach"}]
t.assertTrue[{1b};([name:"runs"])]

/ ── skippedwithEach: skipped feature that also declares each hooks ─────────
t.config ([skip:`last`skippedwitheach])
t.feature `skippedwitheach
t.before[{0N!"before skippedwitheach"}]
t.beforeEach[{0N!"beforeEach skippedwitheach"}]
t.afterEach[{0N!"afterEach skippedwitheach"}]
t.after[{0N!"after skippedwitheach"}]
t.assertTrue[{1b};([name:"skips"])]

t.teardown[]
