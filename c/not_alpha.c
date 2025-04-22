#include "variable.h"

void not_alpha() {
    if (cur_id) {
        cnt[cur_id]++;
        if (cnt[cur_id] > max_cnt) {
            max_siz = 0;
            max_cnt = cnt[cur_id];
        }
        if (cnt[cur_id] >= max_cnt) {
            max_id[max_siz++] = cur_id;
        }
        cur_id = 0;
    }
}
