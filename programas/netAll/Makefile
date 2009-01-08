CC=g++
CCFLAGS=-Wall 

all: netAll 

Clusters.o: Clusters.h Clusters.cpp
	${CC} ${CCFLAGS} Clusters.cpp -c
	
Grafo2.o: Grafo2.cpp Grafo2.h Clusters.h
	${CC} ${CCFLAGS} Grafo2.cpp -c

NetAll.o: NetAll.cpp Grafo2.h 
	${CC} ${CCFLAGS} NetAll.cpp -c

netAll: NetAll.o Grafo2.o Clusters.o
	${CC} ${CCFLAGS} NetAll.o Grafo2.o Clusters.o -o $@

clean: 
	rm -Rf *.o netAll *.rep *.log *.ini
