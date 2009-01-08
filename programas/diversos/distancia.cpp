//  programa para calcular a distancia entre matrizes de vizinhanca
// bem como outras grandezas metricas: norma, cosseno


#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char **argv)
{
	FILE *arq1, *arq2, *saida;
	int nVertices,nArquivos;
	int i,j,k,primeiro;
	char nomeArquivo1[10], nomeArquivo2[10];
	int **mat1, **mat2;
	int cont=0;
	float distancia, normaA, normaB, produtoInterno, coxeno;

	if (argc != 4)
	{
		printf("Uso: ./lerMatriz <nVertices> <nArquivos> <primeiro>\n\n\nnVertices = dimensao da matriz\nnArquivos = numero de matrizes\nprimeiro = primeiro numero das matrizes\n\n");
		exit(0);
	}
	nVertices = atoi(argv[1]);nArquivos = atoi(argv[2]);primeiro = atoi(argv[3]);

	/*ALOCAR MEMORIA*/
	mat1 = (int **)malloc(sizeof(int*) * 327);
	mat2 = (int **)malloc(sizeof(int*) * 327);
	for (i=0;i<nVertices;i++)
	{
		mat1[i] = (int *)malloc(sizeof(int) * 327);
		mat2[i] = (int *)malloc(sizeof(int) * 327);
	}

	for (k=0;k<nArquivos-1;k++)
	{
		sprintf(nomeArquivo1,"mv%d.dat",k+primeiro);

		arq1 = fopen(nomeArquivo1,"r");
		if (arq1 == NULL){exit(0);}
		fscanf(arq1,"%*[^\n]\n");
		fscanf(arq1,"%*[^\n]\n");
		i =0;
		j =0;
		for (i=0;i<nVertices;i++)
		{
			for (j=0;j<nVertices;j++)
			{
				fscanf(arq1,"   %d",&mat1[i][j]);
			}
		}
		fclose(arq1);

		sprintf(nomeArquivo2,"mv%d.dat",k+primeiro+1);
		arq2 = fopen(nomeArquivo2,"r");
		if (arq2 == NULL){exit(0);}
		fscanf(arq2,"%*[^\n]\n");
		fscanf(arq2,"%*[^\n]\n");
		i =0;
		j =0;
		for (i=0;i<nVertices;i++)
		{
			for (j=0;j<nVertices;j++)
			{
				fscanf(arq2,"   %d",&mat2[i][j]);
			}
		}
		fclose(arq2);

		distancia = 0;
		normaA=0;
		normaB=0;
		produtoInterno=0;
		
		
		for (i=0;i<nVertices;i++)
		{
			for (j=0;j<nVertices;j++)
			{
				distancia += (float)( (mat1[i][j] - mat2[i][j])*(mat1[i][j] - mat2[i][j]) );
                normaA += (float)( (mat1[i][j])*(mat1[i][j]) ); 
                normaB += (float)( (mat2[i][j])*(mat2[i][j]) ); 
                produtoInterno += (float)( (mat1[i][j])*(mat2[i][j]) ); 
			}
		}
		
		coxeno = (float) (produtoInterno/(sqrt(normaA)*sqrt(normaB)));
		saida = fopen("quasiDistancia.dat","a");
		fseek(saida,0,SEEK_END);
		fprintf (saida,"%f %f %f %f\n",sqrt(distancia),sqrt(normaA),sqrt(normaB),coxeno);
		fclose(saida);
	}
	
	/*LIBERAR MEMORIA*/
	for (i=0;i<nVertices;i++)
	{
		free(mat1[i]);
		free(mat2[i]);
	}
	free(mat1);
	free(mat2);


}
