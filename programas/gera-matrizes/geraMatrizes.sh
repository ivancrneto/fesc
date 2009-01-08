#!/bin/bash

for ((i=100;i<=10000;i += 100))
do
echo "Gerando Rede " $i
./geraMatrizes $i
done;
