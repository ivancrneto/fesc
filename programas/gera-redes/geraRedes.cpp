// programa q le a matriz de similaridades e da a lista de adjacencia para cada limiar

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>


//#define tamMatriz 100

int main(int argc, char **argv)
{
	/*Se nao foram passados os parametros corretos*/
	if (argc != 4)
	{
		printf("numero insuficiente de argumentos!\n\n./programa <relacaoCritica> <nomeDoArquivo> <tamanho da matriz>\n");
		exit(1);
	}
	
	int tamMatriz = atoi(argv[3]);
	
	FILE *arq, *rede;
	int **matriz;
	int i,j,restricao;
	char nomeRede[15];
	
	matriz = (int **) malloc(sizeof(int *) * tamMatriz);
	for(int i = 0; i < tamMatriz; i++) {
		matriz[i] = (int *) malloc(sizeof(int) * tamMatriz);
	}
	
	for(int i = 0; i < tamMatriz; i++) {
		for(int j = 0; j < tamMatriz; j++) {
	    matriz[i][j] = 0;
  	}
  }

	
	/*Se o parametro passado esta correto*/
	//else
	//{
		arq = fopen(argv[2],"r");
		/*Se o arquivo nao existe*/
		if (arq == NULL)
		{
			printf("problemas no acesso ao ARQUIVO 'proteinas'\n");
			exit(1);
		}
		/*Se o arquivo eh valido*/
		else
		{
			restricao = atoi(argv[1]);
			/*Lendo a matriz de proteinas*/
			for (i=0;i<tamMatriz;i++)			
			{
				for (j=0;j<tamMatriz;j++)
				{
					fscanf(arq,"%d",&matriz[i][j]);
				}
			}
			fclose(arq);
			/*Gerando a rede com base na restricao*/
			if (restricao==100)
			{
				sprintf(nomeRede,"rede%d.net",restricao);
			}
			else if (restricao<10)
			{
				sprintf(nomeRede,"rede00%d.net",restricao);
			}
			else
			{
				sprintf(nomeRede,"rede0%d.net",restricao);
			}
			rede = fopen(nomeRede,"w");
			if (rede == NULL)
			{
				printf("problemas no acesso ao arquvo 'rede.net'\n");
				exit(1);
			}
			/*Escrevendo a rede*/
			fprintf(rede,"*Vertices %d\n",tamMatriz);
			for (i=0;i<tamMatriz;i++)			
			{
				fprintf(rede,"%d \"proteina%d\"\n",i+1,i);
			}
			fprintf(rede,"*Edges\n");
			for (i=0;i<tamMatriz;i++)			
			{
				for (j=0;j<tamMatriz;j++)
				{
					if (matriz[i][j] >= restricao)
					{
						fprintf(rede,"%d %d\n",i+1,j+1);
					}
				}
			}
			fclose(arq);
		}
	
	//}

	return(0);
}
