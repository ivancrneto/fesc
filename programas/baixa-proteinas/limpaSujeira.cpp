/*Programa para limpar sujeira de arquivos baixados do site do NCBI
 * Apenas retira o caracter de codigo ASCII '8' do texto. Este caracter representa sujeira no texto analisado.
 *
 * Charles Novaes de Santana, 30 de janeiro de 2008
 * */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	
	FILE *arq;
	char caracter;

	arq = fopen(argv[1],"r");
	if (arq == NULL)
	{
		exit(1);
	}

	while (!feof(arq))
	{
		fscanf(arq,"%c",&caracter);
		if ((int)caracter != 8)
		{
			printf("%c",caracter);
		}
	}
	fclose(arq);

	return(0);
}
