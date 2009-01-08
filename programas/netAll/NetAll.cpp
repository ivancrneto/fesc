/* Esta eh uma nova versao do NetAll, criada para facilitar a compreensao do codigo fonte, e direcionar seu uso para os problems atualmente estudados no Grupo FESC
 *
 * Foram mantidas as principais funcionalidades da versao anterior:
 *
 * 0 - Calculo do Numero de Vertices
 * 1 - Calculo do Numero de Arestas
 * 2 - Calculo do Grau e do Grau Medio
 * 3 - Calculo do Coeficiente de Aglomeracao e do Coeficiente de Aglomeracao Medio
 * 4 - Calculo do Caminho Minimo Medio DESconsiderando os vertices isolados
 * 5 - Leitura de arquivos do Pajek, com o grafo no formato Lista de Adjacencia
 *
 * E foram acrescentadas as seguintes funcionalidades:
 *
 * 0 - Calculo do Caminho Minimo Medio considerando vertices isolados X 
 * 1 - Calculo do Dendogramo
 * 2 - Leitura de arquivos do Pajek, com o grafo no formato Matriz de Adjacencia X
 * 3 - Calculo da matriz de vizinhanca X
 *
*/

#include "Grafo2.h"

int main(int argc, char** argv)
{
	
	if (argc!=3)
	{
		fprintf(stderr,"A chamada deve ser feita da forma:\n\n");
		fprintf(stderr,"NetAll tipoArquivoPajek nomeArquivoPajek\n\n");
		fprintf(stderr,"lis - FORMATO LISTA DE ADJACENCIAS\n\n");
		fprintf(stderr,"mat - FORMATO MATRIZ DE ADJACENCIAS\n\n");
		cout << "arquivo #vert #Arestas diametro Agl.Medio CMM_SemIsolados CMM_ComIsolados GrauMedio ParesNconectados" << endl;
		exit(1);
	}
	Grafo * analisador = new Grafo();//cria o objeto
	analisador->nomeArquivoPajek = argv[2];
	analisador->nomeArquivoSaidaVizinhanca = argv[2];
	analisador->nomeArquivoSaidaIndices = argv[2];
	analisador->ler_Grafo(argv[1]);
	analisador->calc_Indices();
	analisador->imprime_Saida();
	
	delete(analisador);//destrói o objeto
	return (1);
}
