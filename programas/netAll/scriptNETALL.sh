#!/bin/bash
#
#$ -cwd
#$ -j y
#$ -S /bin/bash
#
#$ -e erro7.txt
#$ -o saida7.txt
hostname
date

 PATH="/opt/intel/cc/9.1.047/bin:${PATH}"; export PATH
 LD_LIBRARY_PATH="/opt/intel/cc/9.1.047/lib:${LD_LIBRARY_PATH}"; export LD_LIBRARY_PATH


./netAll lis rede81.net >> coletiva.dat
echo "Processando rede81.net"
./netAll lis rede82.net  >> coletiva.dat
echo "Processando rede82.net"
./netAll lis rede83.net >> coletiva.dat
echo "Processando rede83.net"
./netAll lis rede84.net >> coletiva.dat
echo "Processando rede84.net"
./netAll lis rede85.net >> coletiva.dat
echo "Processando rede85.net"
./netAll lis rede86.net >> coletiva.dat
echo "Processando rede86.net"
./netAll lis rede87.net  >> coletiva.dat
echo "Processando rede87.net"
./netAll lis rede88.net >> coletiva.dat
echo "Processando rede88.net"
./netAll lis rede89.net >> coletiva.dat
echo "Processando rede89.net"
./netAll lis rede90.net >> coletiva.dat
echo "Processando rede90.net"
./netAll lis rede91.net >> coletiva.dat
echo "Processando rede91.net"
./netAll lis rede92.net  >> coletiva.dat
echo "Processando rede92.net"
./netAll lis rede93.net >> coletiva.dat
echo "Processando rede93.net"
./netAll lis rede94.net >> coletiva.dat
echo "Processando rede94.net"
./netAll lis rede95.net >> coletiva.dat
echo "Processando rede95.net"
./netAll lis rede96.net >> coletiva.dat
echo "Processando rede96.net"
./netAll lis rede97.net  >> coletiva.dat
echo "Processando rede97.net"
./netAll lis rede98.net >> coletiva.dat
echo "Processando rede98.net"
./netAll lis rede99.net >> coletiva.dat
echo "Processando rede99.net"
./netAll lis rede100.net >> coletiva.dat
echo "Processando rede100.net"


date
