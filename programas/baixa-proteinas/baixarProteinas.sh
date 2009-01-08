# Programa para baixar dados de proteinas, disponiveis no site do NCBI
# Utiliza-se o programa 'wget' para baixar as paginas, nomeadas com base nos 'Gi' das proteinas
# Utiliza-se o programa 'html2text' para converter os arquivos html em texto
# Utiliza-se o programa 'limpador' para limpar caracteres estranhos do texto
# Gera-se arquivo contendo a lista de 'Gi' das proteinas estudadas
# Copia-se os arquivos processados e a lista de Gi para o diretorio onde serao extraidas as informacoes das proteinas
#
# Charles Novaes de Santana, 30 de janeiro de 2008
#!/bin/bash

#Programa Principal

if [ $# -ne 1 ]
   then
   echo "Uso: `basename $0` nome_do_arquivo_com_proteinas";
   exit 2 ;
fi
	  
NOMEDOARQUIVO=$1
OLDIFS= $IFS
IFS="|"

while read comunidade lixo1 gi lixo2 lixo3 lixo4 
do
   wget -O Pro_${gi}.html 'http://www.ncbi.nlm.nih.gov/entrez/viewer.fcgi?db=protein&id='$gi
   html2text -nobs Pro_$gi.html >> Pro_$gi.dat
   sed 's/_//g' <Pro_$gi.dat >aux
   ./limpador aux > Pro_$gi.dat
   echo ${comunidade} ${gi} >> listaGi.dat
done < $NOMEDOARQUIVO

cp Pro_*.dat ExtrairInformacoes
cp listaGi.dat ExtrairInformacoes
rm aux

IFS= $OLDIFS

