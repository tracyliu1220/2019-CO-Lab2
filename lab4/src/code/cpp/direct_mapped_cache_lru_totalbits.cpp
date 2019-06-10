#include <iostream>
#include <stdio.h>
#include <math.h>
#include <iomanip>

using namespace std;

int cache_sz; // K
int block_sz = 64;
int way_n;

int csz[6] = {1, 2, 4, 8, 16, 32};
int way[4] = {1, 2, 4, 8};

const int INF = 0x3f3f3f3f;

struct cache_content {
    bool v[8];
    unsigned int tag[8];
    unsigned int last[8];
    int cnt;
    // unsigned int data[block_sz];
};

const int K = 1024;

double log2(double n) {
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


int tag_cnt(int cache_size, int block_size, int way_n, int data) {
    int tag, index, x;
    int cnt_miss = 0, cnt_hit = 0;

    int offset_bit = (int)log2(block_size);
    int index_bit = (int)log2(cache_size / block_size / way_n); // log2(# of cache contents)
    int line = cache_size / block_size / way_n; // # of cache contents

    return (1 + (32 - index_bit - offset_bit) + block_sz * 8) * (line * way_n);
}

int main() {
    cout << "\n=== direct_mapped_cache_lru_totalbits.cpp ===\n";
    for (int k = 0; k < 2; k ++) {
        if (k == 0) cout << "\ntest/LU.txt\n\n";
        if (k == 1) cout << "\ntest/RADIX.txt\n\n";
        cout << "         1-way    2-way    4-way    8-way\n";
        cout << "-----------------------------------------\n";
        for (int i = 0; i < 6; i ++) {
            cout << setw(2) << csz[i] << "K: ";
            for (int j = 0; j < 4; j ++) {
                cache_sz = csz[i]; // K
                block_sz = 64;
                way_n = way[j];
                int ret = tag_cnt(cache_sz * K, block_sz, way_n, k);
                cout << setw(9) << ret; // total bits
            }
            cout << '\n';
        }
    }
    cout << "\n\n";
}
