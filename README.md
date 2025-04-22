# Assignment 1

Count words from `stdin`.

---

`make`:

Compile all *.s to build/count

```shell
as --32 foo.s -o build/foo.o
as --32 bar.s -o build/bar.o
as --32 debug.s -o build/debug.o
ld -m elf_i386 -lc -dynamic-linker /lib/ld-linux.so.2 -o build/count build/*.o
```

---

`make c`:

Compile all c/*.c to build/count-c

```shell
gcc -m32 c/foo.c -o build/foo.o
gcc -m32 c/bar.c -o build/bar.o
gcc -m32 c/debug.c -o build/debug.o
gcc -o build/count-c build/*.o
```

---

`make debug`:

Compile all (*.s except debug.s) and c/debug.c to build/count-debug

```shell
as --32 foo.s -o build/foo.o
as --32 bar.s -o build/bar.o
gcc -m32 c/debug.c -o build/debug.o
gcc -o build/count-debug build/*.o
```

---

`make debug-<module>`:

Compile all (c/*.c except c/\<module\>.c) and module.s to build/count-debug-\<module\>

```shell
$ make debug-output
as --32 foo.s -o build/foo.o
gcc -m32 c/bar.c -o build/bar.o
gcc -m32 c/debug.c -o build/debug.o
gcc -o build/count-debug-output build/*.o
```
