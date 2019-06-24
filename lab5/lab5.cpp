#include <iostream>
#include <fstream>
#include <stdio.h>
#include <math.h>
#include <iomanip>
#include <vector>

using namespace std;

unsigned long long addrA, addrB, addrC;
int m, n, p;

vector<vector<int> > mA;
vector<vector<int> > mB;
vector<vector<int> > mC;

int A(int i, int j) {return addrA + i * n * 4 + j * 4;}
int B(int i, int j) {return addrB + i * p * 4 + j * 4;}
int C(int i, int j) {return addrC + i * p * 4 + j * 4;}
vector<int> address;
vector<int> L1_miss_address;
vector<int> L2_miss_address;

int execution_cycles() {
    return 2 + (22 * m * p * n + 2 * m * p) + (5 * m * p + 2 * m) + (5 * m + 2) + 1;
}

int bandwidth = 1;
int block_sz_words = 8;
int cache_sz; // bytes
int block_sz = 64; // bytes
int way_n;

const int INF = 0x3f3f3f3f;

struct cache_content {
    bool v[8];
    unsigned int tag[8];
    unsigned int last[8];
    int cnt;
    // unsigned int data[block_sz];
};

double log2(double n) {
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


int simulate(int cache_size, int block_size, int way_n,
        vector<int> & addr, vector<int> & miss_addr) {
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

    int time = 0;

    for (int i = 0; i < addr.size(); i ++) {
        x = addr[i];

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
            miss_addr.push_back(x);
        }

        time ++;
    }

    delete [] cache;

    // double miss_rate = cnt_miss / (double)(cnt_hit + cnt_miss);
    // return miss_rate;
    return cnt_miss;
}

int main(int argc, char** argv) {

    ifstream fin(argv[1]);
    ofstream fout(argv[2]);
    fin >> hex >> addrA >> addrB >> addrC;
    fin >> dec >> m >> n >> p;
    mA.resize(m); mB.resize(n); mC.resize(m);

    // matrix A values
    for (int i = 0; i < m; i ++) {
        for (int j = 0; j < n; j ++) {
            int tmp;
            fin >> dec >> tmp;
            mA[i].push_back(tmp);
        }
    }

    // matrix B values
    for (int i = 0; i < n; i ++) {
        for (int j = 0; j < p; j ++) {
            int tmp;
            fin >> dec >> tmp;
            mB[i].push_back(tmp);
        }
    }

    // matrix C spaces
    for (int i = 0; i < m; i ++)
        mC[i].resize(p);

    // execution of matmul
    for (int i = 0; i < m; i ++) {
        for (int j = 0; j < p; j ++) {
            for (int k = 0; k < n; k ++) {
                address.push_back(C(i, j));
                address.push_back(A(i, k));
                address.push_back(B(k, j));
                address.push_back(C(i, j));
                mC[i][j] += mA[i][k] * mB[k][j];
            }
            fout << mC[i][j] << ' ';
        }
        fout << '\n';
    }

    bandwidth = 1;
    block_sz_words = 8;
    cache_sz = 512;
    block_sz = block_sz_words * 4;
    way_n = 8;

    fout << execution_cycles() << ' ';

    int cnt_miss, cnt_hit;
    cnt_miss = simulate(cache_sz, block_sz, way_n, address, L1_miss_address);
    cnt_hit  = address.size() - cnt_miss;
    L1_miss_address.clear();

    // 1(a)
    fout << cnt_miss * 836 + cnt_hit * 4 << ' ';
    // 1(b)
    fout << cnt_miss * 108 + cnt_hit * 4 << ' ';

    int cnt_L1_miss, cnt_L2_miss;
    cache_sz = 128;
    block_sz = 16;
    simulate(cache_sz, block_sz, way_n, address, L1_miss_address);
    cache_sz = 4096;
    block_sz = 128;
    simulate(cache_sz, block_sz, way_n, L1_miss_address, L2_miss_address);
    cnt_L2_miss = L2_miss_address.size();
    cnt_L1_miss = L1_miss_address.size() - cnt_L2_miss;
    cnt_hit     = address.size() - L1_miss_address.size();
    // fout << "hit:    " << cnt_hit << '\n';
    // fout << "miss:   " << cnt_L1_miss << '\n';
    // fout << "global: " << cnt_L2_miss << '\n';
    // fout << "total:  " << address.size() << '\n';
    fout << cnt_hit * 3 + cnt_L1_miss * 55 + cnt_L2_miss * 3639 << '\n';
}
