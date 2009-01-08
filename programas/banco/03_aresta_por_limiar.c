
#include <stdio.h>
#include <string.h>

int main() {

	int tam;

  // esta variavel tem que ser grande para que seja possivel ler toda a linha do arquivo
	tam = 5000;

	// variaveis de tabalho
	char buffer[tam], nome[10], nqtdArestas[3], temp[10];
	int  i, j, cont, n, qtdArestas;
	
	// definindo matriz com de trabalho
	n = 327; // n eh a quantidade de proteinas da classe proteica
	int matriz[n][n];
	
	// definicao dos arquivo de entrada e saida
	FILE *inputfile;
	FILE *outputfile;

	// definindo arquivo de saida
	outputfile = fopen("res_limiar_aresta.txt", "w");

	// a variavel cont inicia com 17 porque eh o menor limiar de similaridade no banco de dados
  	cont = 17;

	// While que ler as matrizes de adjacencia
	while (cont <= 100) {

  		printf("\nLendo arquivo %i", cont);
	  	printf("\n");

		// definir nome do arquivo de entrada
		sprintf(nome, "%d", cont);

		strcpy(temp,nome);

		inputfile = fopen(strcat(nome,".txt"), "r");

		i = 0;
		// lendo o arquivo de entrada
		while (fgets(buffer, tam, inputfile)) {
			
		    for(j = 0 ; j < strlen(buffer) ; j++) {

			if ((buffer[j] != ' ' ) && (buffer[j] != '\n' )) {

				matriz[i][j] = buffer[j];
			 }
		     }

	    	   i++; // incrementando a linha da matriz[n][n]
		}

	  	fclose(inputfile);

	  	qtdArestas = 0;

		// contando quantidade de arestas
		for(i = 0 ; i < n ; i++) {
		    for(j = i ; j < n ; j++) {
			// se o elemento A(i,j) for igual a 1, incrementa 1 a variavel de trabalho
			if (matriz[i][j] == 49) {
			   qtdArestas++;
			}
		     }
		}
		
		sprintf(nqtdArestas, "%d", qtdArestas);
		// -----------------------------------
		// escrevendo uma linda no arquivo de saida		
		fputs( temp, outputfile);
		fputs( ",", outputfile);
		fputs( nqtdArestas, outputfile);
		fputs( "\n", outputfile);
		// -----------------------------------

		cont = cont + 1;
	}// fim While que ler as matrizes de adjacencia

  	fclose(outputfile);

	printf("\n\nFinalizado \n\n");
}
