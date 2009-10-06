#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
	FILE *dados, *lista, *inf;
	char arquivoEntrada[20],gi[20],arquivoSaida[20];
	char LINHA[256];
	int organismo, comunidade, cont = 0;

	lista = fopen("listaGi.dat","r");
	if (lista == NULL) {exit(0);}
	while (!feof(lista))
	{
		fscanf(lista,"%d %s",&comunidade,gi);
		//printf("%d,%s\n",comunidade,gi);
		sprintf(arquivoEntrada,"Pro_%s.dat",gi);
		sprintf(arquivoSaida,"Com_%d.dat",comunidade);
		dados = fopen(arquivoEntrada,"r");
		if (dados == NULL) {exit(0);}
		inf = fopen(arquivoSaida,"a");
		if (inf == NULL){exit(0);}
		organismo = 0;
		while((!feof(dados))&&(!organismo))
		{
			fscanf(dados,"%[^\n]\n",LINHA);
			if (strstr(LINHA,"ORGANISM")!=0)
			{
				organismo=1;
				printf("%d|%d|%s||||", ++cont, comunidade, gi);
				while(strstr(LINHA,"REFERENCE")==NULL)
				{
					fseek(inf,0,SEEK_END);
					printf("%s", LINHA);
					fscanf(dados,"%[^\n]\n",LINHA);
				}
				printf("|http://www.ncbi.nlm.nih.gov/protein/%s?report=genpept|\n", gi);
				fprintf(inf,"\n\n");
			}
		}
		fclose(inf);
		fclose(dados);
	}
	fclose(lista);
	
	return(0);
}
