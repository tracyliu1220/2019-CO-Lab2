V=iverilog
VTARGET=code/verilog/*.v
VOUT=code/verilog/CPU.vvp
TXTOUT=test/ICACHE.txt test/DCACHE.txt

CC=g++ -O2
CMAP=code/cpp/direct_mapped_cache
CLRU=code/cpp/direct_mapped_cache_lru
CTAG=code/cpp/direct_mapped_cache_lru_tag

OUTFILE=test/out.txt

.PHONY: clean

display: map lru
	./${CMAP}.out
	./${CLRU}.out
	./${CTAG}.out
	./${CMAP}.out > ${OUTFILE}
	./${CLRU}.out >> ${OUTFILE}
	./${CTAG}.out >> ${OUTFILE}

map: trace
	${CC} -o ${CMAP}.out ${CMAP}.cpp

lru:
	${CC} -o ${CLRU}.out ${CLRU}.cpp
	${CC} -o ${CTAG}.out ${CTAG}.cpp

trace:
	${V} -o ${VOUT} ${VTARGET}
	vvp ${VOUT}

clean:
	rm ${VOUT} ${CMAP}.out ${CLRU}.out ${CTAG}.out ${TXTOUT} ${OUTFILE}
