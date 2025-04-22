#include "variable.h"

int son[MAXN][CHARSET_SIZE];  // root: #0
int cnt[MAXN];
int father[MAXN];
char content[MAXN];
int tot, max_cnt, max_id[MAXN], max_siz;
int ch, cur_id = 0;


