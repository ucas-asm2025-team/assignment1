#include "variable.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

void alpha();
void not_alpha();
void output(int id);
void traverse();

int main() {
    while ((ch = getchar()) != EOF) {
        if (isalpha(ch)) {
            alpha();
        } else {
            not_alpha();
        }
    }
    for (int i = 0; i < max_siz; i++) {
        output(max_id[i]);
    }
    traverse();
    return 0;
}
