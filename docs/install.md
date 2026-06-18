# unit-test kdb-x installation

[`test.q`](../test.q) is written as a module, under kdb-x's module framework. Though modules can be loaded from anywhere if added to your `$QPATH`, we recommend installing to the `$HOME/.kx/mod/kx` folder. This is to avoid name clashes with other user defined modules, as well as providing a location for other KX modules to cross reference eachother


```bash
export QPATH="$QPATH:$HOME/.kx/mod"
mkdir -p ~/.kx/mod/kx/
cp test.q ~/.kx/mod/kx/
```

> [!NOTE]
> The above assumes the current working directory is the root of this project.

Now from anywhere you can import test.

```q
q)t:use`kx.test
```

Add the `QPATH` export to your bashrc or equivalent to persist across sessions.

You're now ready to check out some of the tests we've provided [here](../tests/) and the [reference](reference.md) to get started

