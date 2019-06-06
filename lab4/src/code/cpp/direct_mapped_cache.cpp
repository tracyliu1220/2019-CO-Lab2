#include <iostream>
#include <stdio.h>
#include <math.h>
#include <iomanip>

using namespace std;

int cache_sz = 4; // K
int block_sz = 16;
int csz[4] = {4, 16, 64, 256};
int bsz[5] = {16, 32, 64, 128, 256};

struct cache_content
{
	bool v;
	unsigned int tag;
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


double simulate(int cache_size, int block_size, int data) {
	unsigned int tag, index, x;
    int cnt_miss = 0, cnt_hit = 0;

	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size); // log2(# of blocks)
	int line = cache_size >> (offset_bit); // # of blocks

	cache_content *cache = new cache_content[line]; // declaration of blocks

	for(int j = 0; j < line; j++)
		cache[j].v = false;
	
    // read file
    FILE *fp;
    if (data == 0) fp = fopen("test/ICACHE.txt", "r");
    if (data == 1) fp = fopen("test/DCACHE.txt", "r");
	
	while(fscanf(fp, "%x", &x) != EOF)
    {
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
        // cout << hex << tag << ' ';
		if(cache[index].v && cache[index].tag == tag) {
			cache[index].v = true;    // hit
            cnt_hit ++;
        }
		else
        {
			cache[index].v = true;  // miss
			cache[index].tag = tag;
            cnt_miss ++;
		}
	}
	fclose(fp);
    
    double miss_rate = cnt_miss / (double)(cnt_hit + cnt_miss);

	delete [] cache;

    return miss_rate;
}
	
int main() {

    cout << "\n=== direct_mapped_cache.cpp ===\n";
    for (int k = 0; k < 2; k ++) {
        if (k == 0) cout << "\ntest/ICACHE.txt\n\n";
        if (k == 1) cout << "\ntest/DCACHE.txt\n\n";
        cout << "             16       32       64      128      256\n";
        cout << "---------------------------------------------------\n";
        for (int i = 0; i < 4; i ++) {
            cout << setw(3) << csz[i] << "K: ";
            for (int j = 0; j < 5; j ++) {
                cache_sz = csz[i];
                block_sz = bsz[j];
                double ret = simulate(cache_sz * K, block_sz, k);
                cout << setw(9) << setprecision(3) << fixed << ret * 100;
            }
            cout << '\n';
        } 
    }
    cout << "\n\n";
}
