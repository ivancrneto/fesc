#!/bin/sh
if [ $# -ne 1 ]
   then
   echo "Uso: `basename $0` nome_do_arquivo_com_proteinas";
   exit 2 ;
fi

NOMEDOARQUIVO=$1
OLDIFS= $IFS
IFS="|"

while read comunidade lixo1 gi 
do
   wget -O Pro_${gi}.dat 'http://www.ncbi.nlm.nih.gov/sviewer/viewer.fcgi?tool=portal&db=protein&val='${gi}'&dopt=genpept&sendto=on&log$=seqview&extrafeat=984&maxplex=1'
   #html2text -nobs Pro_$gi.html >> Pro_$gi.dat
   #sed 's/_//g' <Pro_$gi.dat >aux
   #./limpador aux > Pro_$gi.dat
   echo ${comunidade} ${gi} >> listaGi.dat
done < $NOMEDOARQUIVO

#http://www.ncbi.nlm.nih.gov/protein/109455142?report=genpept
#http://www.ncbi.nlm.nih.gov/entrez/viewer.fcgi?db=protein&id='$gi
#http://www.ncbi.nlm.nih.gov/sviewer/viewer.fcgi?tool=portal&db=protein&val=1786892&dopt=genpept&sendto=on&log$=seqview&extrafeat=984&maxplex=1

mv Pro_*.dat ExtrairInformacoes
mv listaGi.dat ExtrairInformacoes
#rm aux

IFS= $OLDIFS

