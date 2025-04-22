#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

#define MAXN         1000  // max quantity of different words
#define MAXL         100   // max length of a word
#define CHARSET_SIZE 128

int son[MAXN][CHARSET_SIZE];  // root: #0
int cnt[MAXN];
int father[MAXN];
char content[MAXN], buffer[MAXL];
int tot, max_cnt, max_id;

void traverse(int id);

int main() {
    // main:
    int ch, cur_id = 0;
    while ((ch = getchar()) != EOF) {
        if (!isalpha(ch)) {
            // if_stmt:
            if (cur_id) {
                cnt[cur_id]++;
                if (cnt[cur_id] > max_cnt) {
                    max_cnt = cnt[cur_id];
                    max_id = cur_id;
                }
                cur_id = 0;
            }
        } else {
            // else_stmt:
            if (!son[cur_id][ch]) {
                tot++;
                father[tot] = cur_id;
                content[tot] = ch;
                son[cur_id][ch] = tot;
            }
            cur_id = son[cur_id][ch];
        }
    }
    // output:
    int len = 0;
    while (max_id) {
        buffer[len++] = content[max_id];
        max_id = father[max_id];
    }
    for (char *src = buffer + len - 1, *dest = buffer + len; src >= buffer; src--, dest++) {
        *dest = *src;
    }
    printf("%s\n", buffer + len);
    return 0;
}

// void traverse(int cur_id) {
//     static char stack[MAXL], stack_tot;
//     if (cnt[cur_id]) {
//         stack[stack_tot] = 0;
//         printf("%s: %d\n", stack, cnt[cur_id]);
//     }
//     for (int i = 0; i < CHARSET_SIZE; i++) {
//         if (son[cur_id][i]) {
//             stack[stack_tot++] = i;
//             traverse(son[cur_id][i]);
//             stack_tot--;
//         }
//     }
// }
