# Assignment 1

Count words from `stdin`.

## build

---

`make`:

Compile all *.s to build/count

```shell
as foo.s -o build/foo.o
as bar.s -o build/bar.o
as debug.s -o build/debug.o
ld -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o build/count build/*.o
```

---

`make c`:

Compile all c/*.c to build/count-c

```shell
gcc -c c/foo.c -o build/foo.o
gcc -c c/bar.c -o build/bar.o
gcc -c c/debug.c -o build/debug.o
gcc -o build/count-c build/*.o
```

---

`make debug`:

Compile all (*.s except debug.s) and c/debug.c to build/count-debug

```shell
as foo.s -o build/foo.o
as bar.s -o build/bar.o
gcc -c c/debug.c -o build/debug.o
gcc -o build/count-debug build/*.o
```

---

`make debug-<module>`:

Compile all (c/*.c except c/\<module\>.c) and module.s to build/count-debug-\<module\>

```shell
$ make debug-foo
as foo.s -o build/foo.o
gcc -c c/bar.c -o build/bar.o
gcc -c c/debug.c -o build/debug.o
gcc -o build/count-debug-foo build/*.o
```

## run

```shell
build/count < some-text.txt
```
