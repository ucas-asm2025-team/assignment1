#include "constants.h"

#include <stdio.h>
extern int cnt[MAXN];
extern int son[MAXN][CHARSET_SIZE];
void traverse(int cur_id) {
    static char stack[MAXL], stack_tot;
    if (cnt[cur_id]) {
        stack[stack_tot] = 0;
        printf("%s: %d\n", stack, cnt[cur_id]);
    }
    for (int i = 0; i < CHARSET_SIZE; i++) {
        if (son[cur_id][i]) {
            stack[stack_tot++] = i;
            traverse(son[cur_id][i]);
            stack_tot--;
        }
    }
}
