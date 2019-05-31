#include <iostream>
#include <stdio.h>
#include <math.h>

using namespace std;

int const cache_sz = 4; // K
int const block_sz = 16;

struct cache_content
{
	bool v;
	unsigned int tag;
    unsigned int data[block_sz];
};

const int K = 1024;

double log2(double n)
{  
    // log(n) / log(2) is log2.
    return log(n) / log(double(2));
}


void simulate(int cache_size, int block_size)
{
	unsigned int tag, index, x;
    int cnt_miss = 0, cnt_hit = 0;

	int offset_bit = (int)log2(block_size);
	int index_bit = (int)log2(cache_size / block_size); // log2(# of blocks)
	int line = cache_size >> (offset_bit); // # of blocks

	cache_content *cache = new cache_content[line]; // declaration of blocks
	
    cout << "cache line: " << line << endl;

	for(int j = 0; j < line; j++)
		cache[j].v = false;
	
    FILE *fp = fopen("../../verilog/ICACHE.txt", "r");  // read file
	
	while(fscanf(fp, "%x", &x) != EOF)
    {
		cout << hex << x << " ";
		index = (x >> offset_bit) & (line - 1);
		tag = x >> (index_bit + offset_bit);
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
    
    cout << "\n-----\n";
    cout << "hit:       " << dec << cnt_hit << '\n';
    cout << "miss:      " << dec << cnt_miss << '\n';
    cout << "miss_rate: " << cnt_miss / (double)(cnt_hit + cnt_miss) << '\n';
    cout << "-----\n";

	delete [] cache;
}
	
int main()
{
	// Let us simulate 4KB cache with 16B blocks
	simulate(cache_sz * K, block_sz);
}
