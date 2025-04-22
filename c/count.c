#include "constants.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

int son[MAXN][CHARSET_SIZE];  // root: #0
int cnt[MAXN];
int father[MAXN];
char content[MAXN], buffer[MAXL];
int tot, max_cnt, max_id;
int ch, cur_id = 0;

void alpha() {
    if (!son[cur_id][ch]) {
        tot++;
        father[tot] = cur_id;
        content[tot] = ch;
        son[cur_id][ch] = tot;
    }
    cur_id = son[cur_id][ch];
}

void not_alpha() {
    if (cur_id) {
        cnt[cur_id]++;
        if (cnt[cur_id] > max_cnt) {
            max_cnt = cnt[cur_id];
            max_id = cur_id;
        }
        cur_id = 0;
    }
}

void output() {
    int len = 0;
    while (max_id) {
        buffer[len++] = content[max_id];
        max_id = father[max_id];
    }
    for (char *src = buffer + len - 1, *dest = buffer + len; src >= buffer; src--, dest++) {
        *dest = *src;
    }
    puts(buffer + len);
}

int main() {
    while ((ch = getchar()) != EOF) {
        if (isalpha(ch)) {
            alpha();
        } else {
            not_alpha();
        }
    }
    output();
    return 0;
}
