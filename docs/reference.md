# Unit Test References

These are the API specifications for the unit-test module

## after

Function runs user code after running a feature. Evaluated before next feature starts, or on teardown

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string|String or lambda to be executed|

**Example:** after

```q
 // after block will be run after tests

 feature `foo
 before[{`:t set ([]til 10)}]
 assertMatch[{sum get `:t};([x:45]);([name:"sum table"])]
 after[{hdel `:t}]
```

## afterEach

Function runs user code after running each individual test. Evaluated after test runs, or on teardown

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string|String or lambda to be executed|

## assertEqual

Asserts that two results equal eachother, compared with the `=` operator

**Parameters:**

|Name|Type|Description|
|---|---|---|
|input|string|String or lambda to be executed|
|expected|any|expected result of the input lambda|
|opts|dict|Options for assertEqual|
|opts.verbose|boolean|Optional; Boolean indicating whether the result of a test should print to stdout as ran|
|opts.parallel|boolean|Optional; Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)|
|opts.breakOnError|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors|
|opts.breakOnFail|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when a test fails|
|opts.repeats|long|Optional; Long indicating number of times a test should repeat|

**Example:**

```q
 assertEqual[{1i};1j;([name:"one plus one"])]
```

## assertError

Asserts that the result of the user input errors.

**Parameters:**

|Name|Type|Description|
|---|---|---|
|input|string|String or lambda to be executed|
|expected|string|Error string returned from execution|
|opts|dict|Options for assertError|
|opts.verbose|boolean|Optional; Boolean indicating whether the result of a test should print to stdout as ran|
|opts.parallel|boolean|Optional; Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)|
|opts.breakOnError|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors|
|opts.breakOnFail|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when a test fails|
|opts.repeats|long|Optional; Long indicating number of times a test should repeat|

**Example:**

```q
 assertError[{1+`f};"type";([name:"type error throws and passes"])]
```

## assertFalse

Asserts that the result of the user input is false. False is defined as something that will follow the false branch of q's conditional

**Parameters:**

|Name|Type|Description|
|---|---|---|
|input|string|String or lambda to be executed|
|opts|dict|Options for assertFalse|
|opts.verbose|boolean|Optional; Boolean indicating whether the result of a test should print to stdout as ran|
|opts.parallel|boolean|Optional; Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)|
|opts.breakOnError|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors|
|opts.breakOnFail|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when a test fails|
|opts.repeats|long|Optional; Long indicating number of times a test should repeat|

**Example:**

```q
 assertFalse[{0b};([name:"0b passes"])]
 assertFalse[{10~11};([name:"0b passes"])]
```

## assertMatch

Asserts that two results match exactly with the `~` operator

**Parameters:**

|Name|Type|Description|
|---|---|---|
|input|string|String or lambda to be executed|
|expected|any|expected result of the input lambda|
|opts|dict|Options for assertMatch|
|opts.verbose|boolean|Optional; Description Boolean indicating whether the result of a test should print to stdout as ran|
|opts.parallel|boolean|Optional; Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)|
|opts.breakOnError|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors|
|opts.breakOnFail|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when a test fails|
|opts.repeats|long|Optional; Long indicating number of times a test should repeat|

**Example:**

```q
 assertMatch[{1+1};2;([name:"one plus one"])]
```

## assertNull

Asserts that the result of the user input is null.

**Parameters:**

|Name|Type|Description|
|---|---|---|
|input|string|String or lambda to be executed|
|opts|dict|Options for assertNull|
|opts.verbose|boolean|Optional; Boolean indicating whether the result of a test should print to stdout as ran|
|opts.parallel|boolean|Optional; Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)|
|opts.breakOnError|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors|
|opts.breakOnFail|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when a test fails|
|opts.repeats|long|Optional; Long indicating number of times a test should repeat|

**Example:**

```q
 assertNull[{(::)};([name:"generic null passes"])]
 assertNull[{0N};([name:"typed null passes"])]
```

## assertTrue

Asserts that the result of the user input is true. True is defined as something that will follow the true branch of q's conditional

**Parameters:**

|Name|Type|Description|
|---|---|---|
|input|string|String or lambda to be executed|
|opts|dict|Options for assertTrue|
|opts.verbose|boolean|Optional; Boolean indicating whether the result of a test should print to stdout as ran|
|opts.parallel|boolean|Optional; Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)|
|opts.breakOnError|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors|
|opts.breakOnFail|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when a test fails|
|opts.repeats|long|Optional; Long indicating number of times a test should repeat|

**Example:**

```q
 assertTrue[{2~1+1};([name:"1b passes"])]
 assertTrue[{10};([name:"non-zero passes"])]
```

## assertType

Asserts that the type of the output is the one specified, either as a char or short

**Parameters:**

|Name|Type|Description|
|---|---|---|
|input|string|String or lambda to be executed|
|expected|short char|expected type of the input lambda|
|opts|dict|Options for assertType|
|opts.verbose|boolean|Optional; Boolean indicating whether the result of a test should print to stdout as ran|
|opts.parallel|boolean|Optional; Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)|
|opts.breakOnError|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors|
|opts.breakOnFail|boolean|Optional; Boolean indicating if the user should be thrown into the interactive debugger when a test fails|
|opts.repeats|long|Optional; Long indicating number of times a test should repeat|

**Example:**

```q
 assertType[{1i+1i};"i";::]
 assertType[{1i+1i};-6h;::]
```

## before

Function runs user code before running the tests. Evaluated immediately, so should be placed directly under a call to feature

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string|String or lambda to be executed|

**Example:** before

```q
 // Before block will be run immediately and can either be a lambda or a string. Globals should be defined with `::` 

 feature `foo
 before[{bar::3}]
 assertMatch[{bar};3;([name:"bar is 3"])]
```

## beforeEach

Function runs user code before running each individual test. Evaluated before test runs

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string|String or lambda to be executed|

## config

Function modifies the run configuration to select tests to run or skip

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|dict (run:symbol symbol[] string string[]; skip:symbol string symbol[] string[])||

**Example:** config

```q
 // The configuration can be set to a list of features, features:names and regex.
 // This example will provide as strings, though symbols also work
 // The configuration in the example will run all of feature1, test foo from feature2, and all tests in feature3 matching the regex of test[1-4]

 config ([run:("feature1";"feature2:foo";"feature3:test[1-4]")])
```

## feature

Function sets the feature, runs any defined afterEach, followed by any defined after, resetting both of these definitions, along with beforeEach, to their default no-op. Subseqently it purges the execution namespace which contains any ephemeral variables, and sets it back to the setup namespace

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|symbol|symbol to set the current feature name to|

## getDefaults

Function to get the default run parameters

## getReport

Function to get the report table, which contains the history of skipped, passed, failed and errored tests

## junitReport

Takes in the report table and produces a junit representation

**Parameter:**

|Name|Type|Description|
|---|---|---|
|r|table|Report table|

**Example:**

```q
 // Example producint junit report of the tests ran so far
 r:junitReport getReport[]
 `:junit.xml 0: r
```

## mock

Mocks a variable, existing or non existing, and stores the original value for restoring. Note, if a variable is mocked, then mocked again, unmocking will reset back to the original value, not the value of the previous mock.

**Parameters:**

|Name|Type|Description|
|---|---|---|
|name|symbol|Symbolic name of the variable to mock|
|val|any|value to mock the variable to|

## reportDefault

Report schema

## resetDefaults

Function that when ran sets the default run parameters back to the default

## resetReport

Function that when ran sets the report to the empty schema definition, removing any run information to this point

## runFile

Sets the filename to the new file, system l-s that file, and restores back to .z.f after running

**Parameter:**

|Name|Type|Description|
|---|---|---|
|file|symbol|symbol argument to system "l ",string[file].|

## setDefaults

Function modifies the default run parameters

**Parameters:**

|Name|Type|Description|
|---|---|---|
|opts|dict||
|opts.verbose|boolean|Boolean indicating whether the result of a test should print to stdout as ran|
|opts.parallel|boolean|Boolean indicating if the test should be run under peached eval (as some bugs only present themselves under peached evaluation)|
|opts.breakOnError|boolean|Boolean indicating if the user should be thrown into the interactive debugger when an evaluation errors|
|opts.breakOnFail|boolean|Boolean indicating if the user should be thrown into the interactive debugger when a test fails|
|opts.repeats|long|Long indicating number of times a test should repeat|

## setFileName

Sets the filename that gets recorded in reports

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|symbol|filename|

## setRandomSeed

Sets system "S" to a random value

## setSeed

Sets system "S" to a selected value

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|integer|seed|

## setup

Function runs user code before running features. Only removed on teardown, allowing common setups between features

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|string|String or lambda to be executed|

**Example:** setup

```q
 // Setup runs immediately and can either be a lambda or a string. Globals should be defined with `::` 

 setup[{bar::1}]
 feature `foo
 before[{bar::3}]
 assertMatch[{bar};3;([name:"bar is 3"])]
 feature `bar
 assertMatch[{bar};1;([name:"bar is 1"])]
```

## unmock

Unmocks a variable, restoring to the original value prior to any mocking.

**Parameter:**

|Name|Type|Description|
|---|---|---|
|x|symbol|Symbolic name(s) of the variable(s) to unmock|

## teardown

Function that when ran runs any defined afterEach, followed by any defined after, resetting both of these definitions, along with beforeEach, to their default no-op. Subseqently it purges the setupns which contains definitions declared in setup

