#!/bin/bash

for ((i=0;i<101;i++))
do
./geraRedes $i matriz_exemplo.txt 64
echo "Gerando Rede " $i
done;
mkdir Redes 2>/dev/null
mv *.net Redes/

