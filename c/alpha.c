#include "variable.h"

void alpha() {
    if (!son[cur_id][ch]) {
        tot++;
        father[tot] = cur_id;
        content[tot] = ch;
        son[cur_id][ch] = tot;
    }
    cur_id = son[cur_id][ch];
}
