#include "variable.h"

#include <stdio.h>

void output(int id) {
    static char buffer[MAXL * 2];
    int len = 0;
    while (id) {
        buffer[len++] = content[id];
        id = father[id];
    }
    for (char *src = buffer + len - 1, *dest = buffer + len; src >= buffer; src--, dest++) {
        *dest = *src;
    }
    buffer[len * 2] = '\0';
    puts(buffer + len);
}
