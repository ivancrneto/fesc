#ifndef GRAFO_H_
#define GRAFO_H_

#include <vector>
#include <queue>
#include <stack>
#include <iostream>
using std::cin;
using std::cout;
using std::endl;
using std::vector;
using std::queue;
using std::stack;


class Grafo {
public:
	Grafo();
	Grafo( int );
	void add_vertice( char );
	void add_aresta( int, int );
	int existe_vertice( char );
	int v_adjacente( char, char );
	int v_adjacente( int, int );
	void operator =( Grafo );
	void operator =(Grafo*);
	char vertice( int );
	void imprimir_m_adj();
	void def_cintura();
	virtual ~Grafo();

	int* busca_largura( void (*funcao)(int,int*), int v );
	int* busca_profundidade( void (*funcao)(int,int*), int v );
	vector<int> cintura;
	int tam_cintura;
	void setN(int);
	int getN();
	int getM();
	int** getArestas();
	void removeAresta(int, int);
	vector<char> getVertices();
private:
	vector<char> vertices;
	queue<int> fila_busca;
	stack<int> pilha_busca;
	int **arestas;
	int N;
	int M;
	int inicio_cintura;

	int* busca_largura( void (Grafo::*funcao)(int,int*), int v );
	int* busca_profundidade( void (Grafo::*funcao)(int,int*), int v );
	void def_cintura_f_bruta( int, int* );
};

#endif // GRAFO_H_
