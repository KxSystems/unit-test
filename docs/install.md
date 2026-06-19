# unit-test kdb-x installation

[`test.q`](../test.q) is written as a module, under KDB-X's module framework. Though modules can be loaded from anywhere if added to your `$QPATH`, we recommend installing under a `kx` folder within your `$QPATH`. This is to avoid name clashes with other user defined modules, as well as providing a name for other KX modules to cross reference each other.

## Installing a Release

It is recommended that a user install this module through a release. 

[Download a release](https://github.com/KxSystems/unit-test/releases) and then unzip to your module directory. The following example assumes the default install location for KDB-X.

```
unzip unit-test.zip -d ~/.kx/mod
```

## Installing from Source

```bash
git clone https://github.com/KxSystems/unit-test.git
cd unit-test
```

Move `test.q` into your module directory, under `kx`. The following example assumes the default install location for KDB-X.

```bash
mkdir -p ~/.kx/mod/kx
cp test.q ~/.kx/mod/kx/
```


## Next Steps

Now from anywhere you can import test.

```q
q)t:use`kx.test
```

You're ready to check out some of the tests we've provided [here](../tests/) and the [reference](reference.md) to get started
