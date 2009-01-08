# include <stdio.h>
# include <stdlib.h>
# include <string.h>

int **matriz;

void inicializaMatriz(int tamanho) {
  int i, j;

  srand(time(NULL));    

  for(i = 0; i < tamanho; i++) {
    for(j = i + 1; j < tamanho; j++) {
      if(i != j) {
        matriz[i][j] = rand() % 2; 
        matriz[j][i] = matriz[i][j];
      }else {
        matriz[i][j] = 0;
      }
    }
  }
}

void imprimeMatrizArquivo(char *str0) {
  int i, j, tamanho = atoi(str0);
  
  char str[14] = "rede";
  
  strcat(str, str0);
  strcat(str, ".net");
  
  printf("%s\n", str);
  
  FILE *arquivo = fopen(str, "w");

  for(i = 0; i < tamanho; i++) {
    for(j = 0; j < tamanho; j++) {
      fprintf(arquivo, "%d ", matriz[i][j]);
    }
    fprintf(arquivo, "\n");
  }
}

int main(int argc, char **argv) {

  int numVert = atoi(argv[1]), i;

  matriz = (int **) malloc(sizeof(int *) * numVert);  
  for(i = 0; i < numVert; i++) {
    matriz[i] = (int *) malloc(sizeof(int *) * numVert);
  }
  
  inicializaMatriz(numVert);
  imprimeMatrizArquivo(argv[1]);
}



















