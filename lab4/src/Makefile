V=iverilog
VTARGET=code/verilog/*.v
VOUT=code/verilog/CPU.vvp
TXTOUT=test/ICACHE.txt test/DCACHE.txt

CC=g++ -O2
CMAP=code/cpp/direct_mapped_cache
CLRU=code/cpp/direct_mapped_cache_lru
CBIT=code/cpp/direct_mapped_cache_lru_totalbits

OUTFILE=test/out.txt

.PHONY: clean

display: map lru
	./${CMAP}.out > ${OUTFILE}
	./${CLRU}.out >> ${OUTFILE}
	./${CBIT}.out >> ${OUTFILE}
	cat ${OUTFILE}

map: trace
	${CC} -o ${CMAP}.out ${CMAP}.cpp

lru:
	${CC} -o ${CLRU}.out ${CLRU}.cpp
	${CC} -o ${CBIT}.out ${CBIT}.cpp

trace:
	${V} -o ${VOUT} ${VTARGET}
	vvp ${VOUT}

clean:
	rm ${VOUT} ${CMAP}.out ${CLRU}.out ${CBIT}.out ${TXTOUT} ${OUTFILE}
