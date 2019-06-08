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


double simulate(int cache_size, int block_size, int way_n, int data) {
    unsigned int tag, index, x;
    int cnt_miss = 0, cnt_hit = 0;

    int offset_bit = (int)log2(block_size);
    int index_bit = (int)log2(cache_size / block_size / way_n); // log2(# of cache contents)
    int line = cache_size / block_size / way_n; // # of cache contents

    cache_content *cache = new cache_content[line]; // declaration of blocks
 
    for(int j = 0; j < line; j++) {
        for (int k = 0; k < way_n; k ++)
            cache[j].v[k] = false;
        cache[j].cnt = 0;
    }
    
    // read file
    FILE *fp;
    if (data == 0) fp = fopen("test/LU.txt", "r");
    if (data == 1) fp = fopen("test/RADIX.txt", "r");

    int time = 0;
    
    while(fscanf(fp, "%x", &x) != EOF) {

        index = (x >> offset_bit) & (line - 1);
        tag = x >> (index_bit + offset_bit);
        bool if_hit = false;
        int mintime = INF;
        int minid   = -1;

        for (int i = 0; i < cache[index].cnt; i++) {
            if (cache[index].v[i] && cache[index].tag[i] == tag) { // hit
                cnt_hit ++;
                if_hit = true;
                cache[index].last[i] = time;
            }
            if (cache[index].last[i] < mintime) {
                mintime = cache[index].last[i];
                minid = i;
            }
        }

        // if miss
        if (!if_hit) {
            // still have space
            if (cache[index].cnt < way_n) {
                int cnt = cache[index].cnt;
                cache[index].v[cnt] = true;
                cache[index].tag[cnt] = tag;
                cache[index].last[cnt] = time;
                cache[index].cnt ++;
            } else { // no space
                cache[index].v[minid] = true;
                cache[index].tag[minid] = tag;
                cache[index].last[minid] = time;
            }
            cnt_miss ++;
        }

        time ++;
    }
    fclose(fp);

    delete [] cache;
    
    double miss_rate = cnt_miss / (double)(cnt_hit + cnt_miss);
    return miss_rate;
}
    
int main() {
    cout << "\n=== direct_mapped_cache_lru.cpp ===\n";
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
                double ret = simulate(cache_sz * K, block_sz, way_n, k);
                cout << setw(9) << setprecision(3) << fixed << ret * 100;
            }
            cout << '\n';
        }
    }
    cout << "\n\n";
}
