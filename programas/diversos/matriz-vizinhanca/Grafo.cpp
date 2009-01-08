#include "Grafo.h"
#include <iostream>
#include <cstdlib>

#define INFINITO 2147483647

using namespace std;

Grafo::Grafo( ) {
	N = 0;
}
Grafo::Grafo( int N ) {
	Grafo::N = N;
	Grafo::M = 0;
	arestas = (int **) malloc(sizeof(int *)*N);
	for(int i = 0; i < N; i++) {
		arestas[i] = (int *) malloc(sizeof(int)*N);
	}
	for(int i=0;i<N;i++)
		for(int j=0;j<N;j++)
			arestas[i][j]=0;
}

Grafo::~Grafo() {
	int i=0;
	if (N>0) {
		while(i<N)
			free(arestas[i++]);
		free(arestas);
	}
}

void Grafo::setN(int n) {
  Grafo::N = n;
}

int Grafo::getN() {
  return Grafo::N;
}
int Grafo::getM() {
	return Grafo::M;
}
int** Grafo::getArestas() {
	return Grafo::arestas;
}

void Grafo::removeAresta(int i, int j) {
  Grafo::arestas[i][j] = 0;
  Grafo::arestas[j][i] = 0;
}

vector<char> Grafo::getVertices() {
	return vertices;
}
char Grafo::vertice( int i ) {
	return Grafo::vertices[i];
}

void Grafo::add_vertice(char c) {
	Grafo::vertices.push_back(c);
}
void Grafo::add_aresta(int v1, int v2) {

	Grafo::arestas[v1-1][v2-1] ++;
    Grafo::arestas[v2-1][v1-1] ++;
	Grafo::M++;
}

int Grafo::v_adjacente(char v, char va) {
	int v1 = existe_vertice(v);
	int v2 = existe_vertice(va);
	if (v1>-1 && v2>-1){
		if (arestas[v1][v2] > 0)
			return v2;
	}
	return -1;
}

void Grafo::operator =( Grafo g ) {
	N = g.getN();
	M = g.getM();
	arestas = (int **) malloc(sizeof(int *)*N);
	for(int i = 0; i < N; i++) {
		arestas[i] = (int *) malloc(sizeof(int)*N);
	}
	for(int i=0;i<g.getVertices().size();i++)
		vertices.push_back(g.getVertices()[i]);
	for(int i=0;i<N;i++)
		for(int j=0;j<N;j++)
			arestas[i][j] = g.getArestas()[i][j];
}

void Grafo::operator =(Grafo *g) {
  N = g->getN();
	M = g->getM();
	arestas = (int **) malloc(sizeof(int *)*N);
	for(int i = 0; i < N; i++) {
		arestas[i] = (int *) malloc(sizeof(int)*N);
	}
	for(int i=0;i<g->getVertices().size();i++)
		vertices.push_back(g->getVertices()[i]);
	for(int i=0;i<N;i++)
		for(int j=0;j<N;j++)
			arestas[i][j] = g->getArestas()[i][j];
}

int  Grafo::v_adjacente(int v, int va) {
	return arestas[v][va];
}

int Grafo::existe_vertice(char c){
	int i=0;
	while(i < N){
		if(vertices[i] == c)
			return i;
		i++;
	}
	return -1;
}

void Grafo::def_cintura() {
    vector<int> cintura_tmp;
    tam_cintura = INFINITO;
    cintura_tmp.clear();
    cintura.clear();
    for( int i=0; i<N; i++ ) {
    	busca_largura(&Grafo::def_cintura_f_bruta,i);
    }

}

void Grafo::imprimir_m_adj() {
	for(int i=0;i<N;i++){
		for(int j=0;j<N;j++)
			cout << arestas[i][j] << " ";
		cout << endl;
	}
}

int* Grafo::busca_largura( void (*funcao)(int,int*), int v ) {
	int* vert = (int *) malloc(sizeof(int)*N);
	int arest[N][N];
	for(int i=0;i<N;i++)
		for(int j=0;j<N;j++) arest[i][j] = arestas[i][j];
	for( int i=0; i<N; i++ ) vert[i]=INFINITO;
	fila_busca.push(v);
	vert[v]=0;
	while (!fila_busca.empty()) {
		for( int i=0; i<N ; i++ )
		if(arest[fila_busca.front()][i]) {
			arest[fila_busca.front()][i]=arest[i][fila_busca.front()]=0;
			if(vert[i]==INFINITO)
				fila_busca.push(i);
			if(vert[i] > vert[fila_busca.front()])
				vert[i]=1 + vert[fila_busca.front()];
			funcao(i,vert);
		}
		fila_busca.pop();
	}
	return vert;
}

int* Grafo::busca_profundidade( void (*funcao)(int,int*), int v ) {
	int* vert = (int *) malloc(sizeof(int)*N);
	int arest[N][N];
	for(int i=0;i<N;i++)
		for(int j=0;j<N;j++) arest[i][j] = arestas[i][j];
	for( int i=0; i<N; i++ ) vert[i]=INFINITO;
	pilha_busca.push(v);
	vert[v]=0;
	while (!pilha_busca.empty()) {
		int i=0;
		while(i<N && arest[pilha_busca.top()][i]==0) {i++;}
		if(i<N) {
			arest[pilha_busca.top()][i]=0;
			arest[i][pilha_busca.top()]=0;
			int tmp = vert[pilha_busca.top()] + 1;
			if(vert[i]==INFINITO)
				pilha_busca.push(i);
			if(tmp<vert[i])
				vert[i] = tmp;
			funcao(i,vert);
		}else pilha_busca.pop();
	}
	return vert;
}

int* Grafo::busca_profundidade( void (Grafo::*funcao)(int,int*), int v ) {
	return NULL;
}

void Grafo::def_cintura_f_bruta( int vert, int* vert_dist ) {
	for(int i=0; i<N; i++) {
		if(i!=fila_busca.front() && arestas[vert][i] && vert_dist[i]<INFINITO) {
			int nov_tam = vert_dist[i] + vert_dist[vert] + 1;
			if(tam_cintura>nov_tam) {
				tam_cintura = nov_tam;
				cintura.clear();
				cintura.insert(cintura.begin(),vert);
				int j=(int)fila_busca.front();
				while(vert_dist[j] != 0){
					cintura.insert(cintura.begin(),j);
					int menor=j;
					for(int k=0;k<N;k++) {
						if(arestas[j][k] && vert_dist[menor]>vert_dist[k])
							menor = k;
					}
					j=menor;
				}
				cintura.insert(cintura.begin(),j);
				j=i;
				while(vert_dist[j] != 0){
					cintura.push_back(j);
					int menor=j;
					for(int k=0;k<N;k++) {
						if(arestas[j][k] && vert_dist[menor]>vert_dist[k])
							menor = k;
					}
					j=menor;
				}
			}
		}
	}
}

int* Grafo::busca_largura( void (Grafo::*funcao)(int, int*), int v ) {
	int* vert = (int *) malloc(sizeof(int)*N);
	int arest[N][N];
	for(int i=0;i<N;i++)
		for(int j=0;j<N;j++) arest[i][j] = arestas[i][j];
	for( int i=0; i<N; i++ ) vert[i]=INFINITO;
	fila_busca.push(v);
	vert[v]=0;
	while (!fila_busca.empty()) {
		for( int i=0; i<N ; i++ )
		if(arest[fila_busca.front()][i]) {
			arest[fila_busca.front()][i]=arest[i][fila_busca.front()]=0;
			if(vert[i]==INFINITO)
				fila_busca.push(i);
			if(vert[i] > vert[fila_busca.front()])
				vert[i]=1 + vert[fila_busca.front()];
			(this->*funcao)(i,vert);
		}
		fila_busca.pop();
	}
	return vert;
}

