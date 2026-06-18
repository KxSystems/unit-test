// Utils
// @private
qd:{$[99h~type x;x;null x;([]);'`type]};

// @private
predicate:{[rs:`s;name:`C]
            $[.z.m.configuration[rs]~enlist "";
                  1b;
                  [
                    runFN:@'[0 1 _/: ":" vs' .z.m.configuration[rs];1;{$[()~x;x;enlist ":" sv x]}];
                    pf1:string[.z.m.feat] like/: runFN[::;0;0];
                    pn1:name {.[like;(x;y);{1b}]}/: runFN[::;1;0];
                    any pf1 and pn1
                  ]
                ]
  }

// @private
checkRun:{[x:`C] all predicate[;x]@/:`run`skip };

// State Tables and Internal Variables
// @private
feat:`;
// @private
mocks:(enlist[`.])!enlist (::);  // store var!original. needs prepopulating so non-existing entry returns null
// @private
umocks:`$(); // list of items that have been mocked but didn't exist before to delete

// @private
configuration:([run:enlist "";skip:enlist ""]); // configuration dictionary for running tests

// @kind function
// @fileoverview Function modifies the run configuration to select tests to run or skip
// @param x {dict (run:symbol symbol[] string string[]; skip:symbol string symbol[] string[])}
// @desc  x.run List of tests to run.
// @desc  x.skip List of tests to skip".
// @example config
// // The configuration can be set to a list of features, features:names and regex.
// // This example will provide as strings, though symbols also work
// // The configuration in the example will run all of feature1, test foo from feature2, and all tests in feature3 matching the regex of test[1-4]
//
// config ([run:("feature1";"feature2:foo";"feature3:test[1-4]")])
config:{[x:qd]
    $[(t:abs type (raze/) value x)~10h;configuration::configuration upsert x;t~11h;configuration::configuration upsert string x;'`type];
                  configuration::key[configuration]!@[value configuration;where not 0h=type each value configuration;enlist];}        // api for setting configuration

// executens:setupns:([]); // setup namespace for storing globals and for executing feature space

// @private
executens:setupns:d0:(enlist `.)!enlist (::);

// @kind function
// @fileoverview Function that when ran runs any defined afterEach, followed by any defined after, resetting both of these definitions, along with beforeEach, to their default no-op. Subseqently it purges the setupns which contains definitions declared in setup
// @see after
// @see afterEach
// @see setup
teardown:{
          .z.m.afterEachPrj[];
          .z.m.resetAfterEach[];
          .z.m.resetBeforeEach[];
          .z.m.afterPrj[];
          .z.m.resetAfter[];
          .z.m.setupns:d0;
          .z.m.configuration:([run:enlist "";skip:enlist ""])} // Call the after block of the final feature

// Getters and setters

// @kind data
// @fileoverview Report schema
reportDefault:([]filename:`$();feature:`$();name:();status:`$();executionTime:`long$();memory:`long$();description:();details:());

// @kind function
// @fileoverview Function that when ran sets the report to the empty schema definition, removing any run information to this point
// @see getReport
// @see reportDefault
resetReport:{report::reportDefault};
resetReport[];

// @kind function
// @fileoverview Function to get the report table, which contains the history of skipped, passed, failed and errored tests
// @see resetReport
// @see reportDefault
getReport:{report} // reporting table get api

// @kind data
// @fileoverview Default run parameters dictionary
defaultsDefault:([verbose:1b;parallel:0b;breakOnError:0b;breakOnFail:0b;repeats:1]);

// @kind function
// @fileoverview Function that when ran sets the default run parameters back to the default
// @see getDefaults
// @see defaultsDefault
resetDefaults:{defaults::defaultsDefault};
resetDefaults[];

// @kind function
// @fileoverview Function to get the default run parameters
// @see resetDefaults
// @see defaultsDefault
// @see setDefaults
getDefaults:{defaults}

// @kind function
// @fileoverview Function modifies the default run parameters
// @param opts {dict (verbose:boolean; parallel:boolean; breakOnError:boolean; breakOnFail:boolean; repeats:long)}
// @desc opts.verbose Boolean indicating whether the result of a test should print to stdout as ran
// @desc opts.parallel Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)
// @desc opts.breakOnError Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors
// @desc opts.breakOnFail Boolean indicating if the user should be thrown into the interactive debugger when a test fails
// @desc opts.repeats Long indicating number of times a test should repeat
setDefaults:{[opts:qd] defaults::defaults upsert opts}

// File Name for when we runFiles 
// @private
fileName:.z.f;

// @kind function
// @fileoverview Sets the filename that gets recorded in reports
// @param x {symbol} filename
setFileName:{[x] // qdocs
// setFileName:{[x:`s]
    fileName::x} // qdoc

// Seeds
// @kind function
// @fileoverview Sets system "S" to a random value
setRandomSeed:{ system "S ",string "i"$.z.p mod (0wi-1)}
// @fileoverview Sets system "S" to a selected value
// @param x {integer} seed
setSeed:{[x:`i] system "S ",string x}

// Scoped execution
// @private
pre:{[x:`s] r:string system "d"; system "d ",string x;r}
// @private
post:{string system "d ",x}
// @private
scope:{$[100h~tx:type x;            // if lambda
        (value last value x;::);    // value the source code so the absolute namespace is in new scope
        10h~tx;                     // if string
        (eval;parse x);             // parse string
        x]}                         // else, just an object, scope shouldn't matter

// Before/after
// @kind function
// @fileoverview Function runs user code before running the tests. Evaluated immediately, so should be placed directly under a call to feature
// @param x {string} String or lambda to be executed
// @see feature
// @example before
// // Before block will be run immediately and can either be a lambda or a string. Globals should be defined with `::` 
//
// feature `foo
// before[{bar::3}]
// assertMatch[{bar};3;([name:"bar is 3"])]
before:{ns:pre[.z.M.executens]; if[checkRun[""];eval scope[x]]; post ns;}; // Before runs immediately, as before should be defined immediately after feature setting
// @private
resetAfter:{afterPrj::{[x]}};
// @private
resetAfter[];                                  // After runs deferred as the definition can be set immediately after feature setting or immediately before setting the next feature

// @kind function
// @fileoverview Function runs user code after running a feature. Evaluated before next feature starts, or on teardown
// @param x {string} String or lambda to be executed
// @see feature
// @example after
// // after block will be run after tests
//
// feature `foo
// before[{`:t set ([]til 10)}]
// assertMatch[{sum get `:t};([x:45]);([name:"sum table"])]
// after[{hdel `:t}]
after:{.z.m.afterPrj::{[x;y]ns:pre[.z.M.executens]; if[checkRun[""];eval scope[x]]; post ns;}[x;];};

// @private
resetAfterEach:{afterEachPrj::{[x]}};
// @private
resetAfterEach[];                                  // After each runs deferred

// @kind function
// @fileoverview Function runs user code after running each individual test. Evaluated after test runs, or on teardown
// @param x {string} String or lambda to be executed
// @see after
afterEach:{.z.m.afterEachPrj::{[x;y]ns:pre[.z.M.executens]; if[checkRun[""];eval scope[x]]; post ns;}[x;];};

// @private
resetBeforeEach:{beforeEachPrj::{[x]}};
// @private
resetBeforeEach[];                                  // Before each runs deferred

// @kind function
// @fileoverview Function runs user code before running each individual test. Evaluated before test runs
// @param x {string} String or lambda to be executed
// @see before
beforeEach:{.z.m.beforeEachPrj::{[x;y]ns:pre[.z.M.executens]; if[checkRun[""];eval scope[x]]; post ns;}[x;];};


// @kind function
// @fileoverview Function runs user code before running features. Only removed on teardown, allowing common setups between features
// @param x {string} String or lambda to be executed
// @see feature
// @example setup
// // Setup runs immediately and can either be a lambda or a string. Globals should be defined with `::` 
//
// setup[{bar::1}]
// feature `foo
// before[{bar::3}]
// assertMatch[{bar};3;([name:"bar is 3"])]
// feature `bar
// assertMatch[{bar};1;([name:"bar is 1"])]
setup:{ns:pre[.z.M.setupns]; eval scope[x]; post ns;}
// Set Feature

// @kind function
// @fileoverview Function sets the feature, runs any defined afterEach, followed by any defined after, resetting both of these definitions, along with beforeEach, to their default no-op. Subseqently it purges the execution namespace which contains any ephemeral variables, and sets it back to the setup namespace
// @param x {symbol} symbol to set the current feature name to
feature:{[x:`s]
          .z.m.afterEachPrj[];
          .z.m.resetAfterEach[];
          .z.m.resetBeforeEach[];
          .z.m.afterPrj[];            // Call the defined after call before teardown and next feature
          .z.m.resetAfter[];
          delete from .z.M.executens;
          .z.M.executens set .z.m.setupns;
          feat::x};

// Assert
assertImpl:{[expectedError;op;input;ex;opts:{$[99h~type x;x;null x;([]);'`type]}]
  ns:pre[.z.M.executens];
  defaultOpts:([name:"";description:""]),.z.m.defaults;
  opts:defaultOpts upsert opts;
  .z.m.func:scope[input];
  .z.m.act:();
  status:`skipped;
  evaluate:$[opts`parallel;"first eval peach (x;())";"eval x"];
  reps:([]executionTime:`long$();memory:`long$());
  if[checkRun[opts`name] and (not `skip in key opts); // if not skipped
      i:0;
      doiter:1b;
      .z.m.beforeEachPrj[];
      while[(i<opts`repeats) and doiter;
        i+:1;
        reps,:system "ts ",string[.z.M.act],":@[{(1b;",evaluate,")};",string[.z.M.func],$[(not expectedError) and opts`breakOnError;"]";";{(0b;x)}]"];
        result:all (op) . (ex;last act); // does the test pass, both in error condition and in pass condition
        errored:not first act;
        status:$[(not expectedError) and errored;
                  `error;
                  (expectedError) and not errored;
                  `fail;
                  `fail`pass result
                  ];
        if[status~`fail;
              doiter:0b;
              if[opts`breakOnFail;{[func;op;ex;act]'`$"test failed, check comparison [op]eration, eval [func]tion, [ex]pected and [act]ual results"}[func;op;ex;last act]]
              ];
        ];
      .z.m.afterEachPrj[]
      ];
  .z.M.report upsert enlist ([filename:fileName;
                              feature:.z.m.feat;
                              name:opts`name;
                              status;
                              executionTime:max reps`executionTime;
                              memory:max reps`memory;
                              description:opts`description;
                              // details:([input;actual:last act;expected:ex;reps;seed:system "S";skipMessage:$[`skip in key opts;opts`skip;""]])]);
                              details:([input;actual:last act;expected:ex;reps;seed:system "S";.z.m.configuration;skipMessage:$[`skip in key opts;opts`skip;""]])]);
  if[opts`verbose;-1 .Q.s enlist last .z.m.report];
  post[ns];
  }

// @private
assert:assertImpl[0b];

// @private
eassert:assertImpl[1b];

// @private
typ:{((upper;lower)t<0)@.Q.t@abs t:type x};
// @private
ty:{x~$[-10h~tx:type x;typ y;type y]};
// (assertMatch;assertEqual;assertType):assert@/:(~;=;ty);

// @kind function
// @fileoverview Asserts that two results match exactly with the `~` operator
// @param input {string} String or lambda to be executed
// @param expected {any} expected result of the input lambda
// @param opts {dict (verbose:boolean; parallel:boolean; breakOnError:boolean; breakOnFail:boolean; repeats:long)} Options for assertMatch
// @desc [opts.verbose] Description Boolean indicating whether the result of a test should print to stdout as ran
// @desc [opts.parallel] Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)
// @desc [opts.breakOnError] Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors
// @desc [opts.breakOnFail] Boolean indicating if the user should be thrown into the interactive debugger when a test fails
// @desc [opts.repeats] Long indicating number of times a test should repeat
// @example
// assertMatch[{1+1};2;([name:"one plus one"])]
assertMatch:{[input;expected;opts] assert[~;input;expected;opts]};

// @kind function
// @fileoverview Asserts that two results equal eachother, compared with the `=` operator
// @param input {string} String or lambda to be executed
// @param expected {any} expected result of the input lambda
// @param opts {dict (verbose:boolean; parallel:boolean; breakOnError:boolean; breakOnFail:boolean; repeats:long)} Options for assertEqual
// @desc  [opts.verbose] Boolean indicating whether the result of a test should print to stdout as ran
// @desc  [opts.parallel] Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)
// @desc  [opts.breakOnError] Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors
// @desc  [opts.breakOnFail] Boolean indicating if the user should be thrown into the interactive debugger when a test fails
// @desc  [opts.repeats] Long indicating number of times a test should repeat
// @example
// assertEqual[{1i};1j;([name:"one plus one"])]
assertEqual:{[input;expected;opts] assert[=;input;expected;opts]};

// @kind function
// @fileoverview Asserts that the type of the output is the one specified, either as a char or short
// @param input {string} String or lambda to be executed
// @param expected {short char} expected type of the input lambda
// @param opts {dict (verbose:boolean; parallel:boolean; breakOnError:boolean; breakOnFail:boolean; repeats:long)} Options for assertType
// @desc  [opts.verbose] Boolean indicating whether the result of a test should print to stdout as ran
// @desc  [opts.parallel] Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)
// @desc  [opts.breakOnError] Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors
// @desc  [opts.breakOnFail] Boolean indicating if the user should be thrown into the interactive debugger when a test fails
// @desc  [opts.repeats] Long indicating number of times a test should repeat
// @example
// assertType[{1i+1i};"i";::]
// assertType[{1i+1i};-6h;::]
assertType:{[input;expected;opts] assert[ty;input;expected;opts]};

// @kind function
// @fileoverview Asserts that the result of the user input is true. True is defined as something that will follow the true branch of q's conditional
// @param input {string} String or lambda to be executed
// @param opts {dict (verbose:boolean; parallel:boolean; breakOnError:boolean; breakOnFail:boolean; repeats:long)} Options for assertTrue
// @desc  [opts.verbose] Boolean indicating whether the result of a test should print to stdout as ran
// @desc  [opts.parallel] Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)
// @desc  [opts.breakOnError] Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors
// @desc  [opts.breakOnFail] Boolean indicating if the user should be thrown into the interactive debugger when a test fails
// @desc  [opts.repeats] Long indicating number of times a test should repeat
// @example
// assertTrue[{2~1+1};([name:"1b passes"])]
// assertTrue[{10};([name:"non-zero passes"])]
assertTrue:{[input;opts] assert[{[x;y]@[{$[x;1b;0b]};y;0b]};input;0N;opts]};
// assertFalse:assert[~;;0b;];

// @kind function
// @fileoverview Asserts that the result of the user input is false. False is defined as something that will follow the false branch of q's conditional
// @param input {string} String or lambda to be executed
// @param opts {dict (verbose:boolean; parallel:boolean; breakOnError:boolean; breakOnFail:boolean; repeats:long)} Options for assertFalse
// @desc  [opts.verbose] Boolean indicating whether the result of a test should print to stdout as ran
// @desc  [opts.parallel] Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)
// @desc  [opts.breakOnError] Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors
// @desc  [opts.breakOnFail] Boolean indicating if the user should be thrown into the interactive debugger when a test fails
// @desc  [opts.repeats] Long indicating number of times a test should repeat
// @example
// assertFalse[{0b};([name:"0b passes"])]
// assertFalse[{10~11};([name:"0b passes"])]
assertFalse:{[input;opts] assert[{[x;y]@[{$[x;0b;1b]};y;0b]};input;0N;opts]};

// @kind function
// @fileoverview Asserts that the result of the user input is null.
// @param input {string} String or lambda to be executed
// @param opts {dict (verbose:boolean; parallel:boolean; breakOnError:boolean; breakOnFail:boolean; repeats:long)} Options for assertNull
// @desc  [opts.verbose] Boolean indicating whether the result of a test should print to stdout as ran
// @desc  [opts.parallel] Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)
// @desc  [opts.breakOnError] Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors
// @desc  [opts.breakOnFail] Boolean indicating if the user should be thrown into the interactive debugger when a test fails
// @desc  [opts.repeats] Long indicating number of times a test should repeat
// @example
// assertNull[{(::)};([name:"generic null passes"])]
// assertNull[{0N};([name:"typed null passes"])]
assertNull:{[input;opts] assert[@;input;null;opts]};

// @kind function
// @fileoverview Asserts that the result of the user input errors.
// @param input {string} String or lambda to be executed
// @param expected {string} Error string returned from execution
// @param opts {dict (verbose:boolean; parallel:boolean; breakOnError:boolean; breakOnFail:boolean; repeats:long)} Options for assertError
// @desc  [opts.verbose] Boolean indicating whether the result of a test should print to stdout as ran
// @desc  [opts.parallel] Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)
// @desc  [opts.breakOnError] Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors
// @desc  [opts.breakOnFail] Boolean indicating if the user should be thrown into the interactive debugger when a test fails
// @desc  [opts.repeats] Long indicating number of times a test should repeat
// @example
// assertError[{1+`f};"type";([name:"type error throws and passes"])]
assertError:{[input;expected;opts] eassert[~;input;expected;opts]};

// @kind function
// @fileoverview Mocks a variable, existing or non existing, and stores the original value for restoring. Note, if a variable is mocked, then mocked again, unmocking will reset back to the original value, not the value of the previous mock.
// @param name {symbol} Symbolic name of the variable to mock
// @param val {any} value to mock the variable to
mock:{[name:`s;val]
  ns:pre[.z.M.executens];
  r:@[{(1b;value x)};name;{(0b;x)}];
  $[(not name in umocks) and first r;
    @[.z.M.mocks;name;{$[null x;x:y;x]};r 1];
    not first r;
    .z.m.umocks,:name];
  eval (set;enlist name;scope[val]);
  post[ns];
  }

// @kind function
// @fileoverview Unmocks a variable, restoring to the original value prior to any mocking.
// @param name {symbol} Symbolic name(s) of the variable(s) to unmock
unmock:{[x:{$[x~(::);`;11h~abs type x;x;'`type]}]
  ns:pre[.z.M.executens];
  toremove:$[`~x;.z.m.umocks,key 1 _ .z.m.mocks;(),x];
  // TODO: (optional) store information about nested mocks to delete say if .a is set but doesn't contain b, mocking and unmocking .a.b.c should purge c, and b
  // FIX: if previously mocked .foo.bar, then unmocked, then set .foo:1, unmock will delete from ns instead of setting to ()
  @'[{(ns;n):(::;{$[x~`;`symbol$();enlist x]})@'` sv' (0;-1+count string x) _ x:$[(2~count x) and fx:`~first x;x,`;fx;x;.z.M.executens,x];.[{![x;();0b;y]};(ns;n);{[x;y]x set ()}[ns;]]};` vs' toremove];
  .[.z.M.umocks;();except;toremove];
  torestore:toremove inter key .z.m.mocks;
  torestore set' .z.m.mocks torestore;
  .z.m.mocks:torestore _ .z.m.mocks;
  post[ns];
  }

// @kind function
// @fileoverview Sets the filename to the new file, system l-s that file, and restores back to .z.f after running
// @param file {symbol} symbol argument to system "l ",string[file].
runFile:{[file:`s] setFileName[file]; system "l ",string[file]; setFileName[.z.f]} 



// JUNIT
// @private
xmlEscape:{[xml]
  xml:$[-11h = type xml;string xml;xml];
  if [xml~enlist "";:""];
  if [not 10h = type xml;
      : xml];
  
  : ssr/[xml; "&<>\"'"; "&",/:("amp";"lt";"gt";"quot";"apos"),\:";"]
  }

// @private
junit.statusNode:{[row]
  status: row`status;
  escape: {if[x~enlist "";:""];.h.xs $[-10h~type x;enlist x;x]};
  details:row`details;
  $[`pass~status; "";
    `fail~status;
      "<failure>", (escape .j.j `input`actual`expected # details), "</failure>";
    `error~status;
      "<error>", (escape .j.j `input`actual`expected # details), "</error>";
    `skipped~status;
      "<skipped>", (escape {$[x~"";x;.Q.s x]} details[`skipMessage]), "</skipped>";
    ""]
  }

// @private
junit.writeTestcase:{[row]
  open:
    "<testcase classname=\"", xmlEscape[row`feature],
    "\" name=\"", xmlEscape[row`name],
    $[not ""~row`description;"\" description=\"", xmlEscape[row`description];""],
    "\" memory=\"", string[row`memory],
    "\" time=\"", string[row`executionTime], "\">";

  detail: junit.statusNode[row];
  $[""~detail;enlist open,"</testcase>";(open;detail;"</testcase>")]
  }

// @private
junit.suiteStats:{[suite]
  exec
    tests: count i,
    failures: sum status=`fail,
    errors: sum status=`error,
    skipped: sum status=`skipped,
    time: sum ?[executionTime=-0W;0;executionTime]
  from suite
  }

// @private
junit.writeSuite:{[suite]
  stats: junit.suiteStats suite;
  open: enlist "<testsuite name=\"", xmlEscape[first[suite]`filename], "\" ",
      "tests=\"", string[stats`tests], "\" ",
      "failures=\"", string[stats`failures], "\" ",
      "errors=\"", string[stats`errors], "\" ",
      "skipped=\"", string[stats`skipped], "\" ",
      "time=\"", string[stats`time], "\">";

  open,raze [junit.writeTestcase each suite],enlist "</testsuite>"
  }

// @kind function
// @fileoverview Takes in the report table and produces a junit representation
// @param r {table} Report table
// @example
// // Example producint junit report of the tests ran so far
// r:junitReport getReport[]
// `:junit.xml 0: r
junitReport:{[r]
  cases: {[x;y]junit.writeSuite select from x where filename = y}[r;] each exec distinct filename from r;
  (enlist["<testsuites>"],raze[cases],enlist["</testsuites>"])
  }

// Exports
// TODO: refine export
// @private
export:.z.m
