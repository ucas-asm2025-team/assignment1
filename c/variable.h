// data range: different words <= 200, word length <= 12
#define MAXN         2500  // max tree size
#define MAXL         100   // max length of a word
#define CHARSET_SIZE 128
extern int son[MAXN][CHARSET_SIZE];
extern int cnt[MAXN];
extern int father[MAXN];
extern char content[MAXN];
extern int tot, max_cnt, max_id[MAXN], max_siz, ch, cur_id;
