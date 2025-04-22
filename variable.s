#define MAXN         1000  // max quantity of different words
#define MAXL         100   // max length of a word
#define CHARSET_SIZE 128

.equ MAXN, 1000
.equ CHARSET_SIZE, 128
.equ MAXL, 1000

.section .data
son:     .fill MAXN*CHARSET_SIZE, 4, 0  # int son[MAXN][CHARSET_SIZE] = {0}
cnt:     .fill MAXN, 4, 0               # int cnt[MAXN] = {0}
father:  .fill MAXN, 4, 0               # int father[MAXN] = {0}
max_id:  .fill MAXN, 4, 0               # int max_id[MAXN] = {0}
content: .fill MAXN, 1, 0               # char content[MAXN] = {0}
tot:     .long 0                        # int tot = 0
max_cnt: .long 0                        # int max_cnt = 0
max_siz:  .long 0                       # int max_siz = 0
ch:      .long 0                        # int ch = 0
cur_id:  .long 0                        # int cur_id = 0

.globl son, cnt, father, content, tot, max_cnt, max_id, max_siz, ch, cur_id
