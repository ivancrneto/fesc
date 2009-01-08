#/bin/bash

for i in *.net;
do
	echo "rede $i" >> redesExecutadas;
	./netAll mat $i;
done;
