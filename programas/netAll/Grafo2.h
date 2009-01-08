#ifndef _GRAFO2_
#define _GRAFO2_

#include <string>
#include <string.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <stdio.h>
#include <vector>
#include <queue>
#include <math.h>
#include <time.h>
#include "Clusters.h"

using namespace std;

using std::cout;
using std::endl;

#define RAND(x) ( ((double)rand()/RAND_MAX)*(x) )

typedef struct sAresta
{
	int i;
	int j;
}tAresta;

typedef int tMatriz;

class Grafo
{
	private:
		int ind_NaoConectados;
		int ind_Diametro;
		float ind_GrauMedio;
		float ind_AglomeracaoMedia;
		vector<int> grauVertices;
		vector<float>aglomVertices;
		int numVerticesRede;
		int numVerticesNaoIsolados;
		int numArestasRede;
		vector<tAresta> arestasRede;
		vector<vector<tMatriz> > mat_Adjacencias;
		vector<vector<tMatriz> > mat_ArvoreGeradoraMinima;
		vector<vector<int> > mat_CamMin;
		vector<string> nomesVertices;
		vector<float>caminhoMinimoMedio_vert;
		float ind_CamMin_ci;
		float ind_CamMin_si;

		//Metodos de impressao de resultados
		void imprime_MatrizAdjacencias(void);
		void imprime_ArvoreGeradoraMinima(void);
		void imprime_MatrizVizinhanca(void);
		//Metodos de inicializacao
		void inicializa_MatrizAdjacencias(void);
		//Metodos de leitura de informacoes
		void ler_GrafoLista(void);
		void ler_GrafoMatriz(void);
		//Calculo dos indices
		void calc_ArvoreGeradoraMinima(void);
		void calc_Arestas(void);
		void calc_VetCoeficienteAglom(void);
		void calc_AglomVertices(int i);
		void calc_AglomeracaoMedia(void);
		void calc_NumVerticesNaoIsolados(void);
		void calc_GrauVertices(void);
		void calc_GrauMedio(void);
		void calc_Diametro(void);
		void calc_ParesNaoConectados(void);
		void calc_MatrizCaminhosMinimos(void);
		void calc_Betweeness(void);
		void calc_CaminhoMinimoMedio_vert(void);
		void calc_CaminhoMinimoMedio_rede_ci(void);//COM isolados
		void calc_CaminhoMinimoMedio_rede_si(void);//SEM isolados
		int calc_CaminhoMinimo(long int i, long int j);
	public:	
		string nomeArquivoPajek;
		string nomeArquivoSaidaIndices;
		string nomeArquivoSaidaVizinhanca;
		void ler_Grafo(char tipoArquivo[5]);
		void calc_Indices(void);
		void imprime_Saida(void);
		void imprime_Estatisticas(void);
		Grafo();
		~Grafo();
};

#endif
