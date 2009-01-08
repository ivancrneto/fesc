# include <stdio.h>
# include <stdlib.h>

int main(int argc, char **argv){
	if(argc < 4){
		printf("%s\n%s\n%s\n%s\n", "Chame com 2 argumentos:",
			" 1. Primeiro limiar desejado;",
			" 2. Ultimo limiar desejado;",
			" 3. Variacao.");
	}else{
		int i, inicio = atoi(argv[1]), fim = atoi(argv[2]), variacao = atoi(argv[3]);
		FILE *arquivo;

		if((arquivo = fopen("scriptNETALL.sh", "w+")) == NULL){
			printf("Problemas na criacao do arquivo!\n");
			exit(0);
		}

		fprintf(arquivo, "%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n%s\n%s\n\n\n",
			"#!/bin/bash", "#", "#$ -cwd", "#$ -j y", "#$ -S /bin/bash","#",
			"#$ -e erro7.txt", "#$ -o saida7.txt","hostname", "date",
			" PATH=\"/opt/intel/cc/9.1.047/bin:${PATH}\"; export PATH",
		" LD_LIBRARY_PATH=\"/opt/intel/cc/9.1.047/lib:${LD_LIBRARY_PATH}\"; export LD_LIBRARY_PATH");

		for(i = inicio; i <= fim; i+=variacao){
			if((i - 2) % 5){
			       if (i == 100) {
                     fprintf(arquivo, "%s%d%s\n",
                          "echo \"Processando rede", i, ".net\"");
                     fprintf(arquivo,"%s%d%s\n",
                         "./netAll lis rede", i, ".net >> coletiva.dat");
                }
                else if (i < 10) { 
                     fprintf(arquivo, "%s%d%s\n",
                          "echo \"Processando rede00", i, ".net\"");
                     fprintf(arquivo,"%s%d%s\n",
                         "./netAll lis rede00", i, ".net >> coletiva.dat");
                }
                else {
                     fprintf(arquivo, "%s%d%s\n",
                           "echo \"Processando rede0", i, ".net\"");
                     fprintf(arquivo,"%s%d%s\n",
                         "./netAll lis rede0", i, ".net >> coletiva.dat");
                }
				/*fprintf(arquivo, "%s%d%s\n",
					"./netAll lis rede", i, ".net >> coletiva.dat");
			    fprintf(arquivo, "%s%d%s\n",
			        "echo \"Processando rede", i, ".net\""); */
			}else{
                if (i == 100) {
                     fprintf(arquivo, "%s%d%s\n",
                          "echo \"Processando rede", i, ".net\"");
                     fprintf(arquivo,"%s%d%s\n",
                         "./netAll lis rede", i, ".net >> coletiva.dat");

                }
                else if (i < 10) { 
                     fprintf(arquivo, "%s%d%s\n",
                          "echo \"Processando rede00", i, ".net\"");
                     fprintf(arquivo,"%s%d%s\n",
                         "./netAll lis rede00", i, ".net >> coletiva.dat");
                }
                else {
                     fprintf(arquivo, "%s%d%s\n",
                           "echo \"Processando rede0", i, ".net\"");
                     fprintf(arquivo,"%s%d%s\n",
                         "./netAll lis rede0", i, ".net >> coletiva.dat");
                }
			/*fprintf(arquivo, "%s%d%s\n",
					"./netAll lis rede", i, ".net  >> coletiva.dat");
				fprintf(arquivo, "%s%d%s\n",
			        "echo \"Processando rede", i, ".net\""); */
			}
		}

		fprintf(arquivo, "\n\n%s", "date\n");

		fclose(arquivo);
	}
}
