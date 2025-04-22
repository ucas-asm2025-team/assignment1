#!/bin/bash
cat head.s block{1,2,3,4}.s >count.s
as --32 count.s -o count.o
ld -lc -dynamic-linker /lib/ld-linux.so.2 -m elf_i386 count.o -o count
