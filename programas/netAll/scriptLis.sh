#/bin/bash

./netAll > res.dat;
for i in *.net;
do
	echo "rede $i" >> redesExecutadas;
	./netAll lis $i >> res.dat;
done;
