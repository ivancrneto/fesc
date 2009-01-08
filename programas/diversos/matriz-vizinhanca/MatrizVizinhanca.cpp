#include <iostream>
#include <vector>
#include "Grafo.h"
#include <string>

#define INFINITO 2147483647

using namespace std;

#define DEBUG
int cont=0;
void f(int a,int* b) {cont++;}

int main() {
  int N=0,aux=0;

  cin >> N;

  Grafo g = Grafo(N);

  for( int j=1; j<=N ; j++ ) {
  	for( int i=1; i<=N ; i++ ) {
  		cin >> aux;
          if(aux && j>i)
              g.add_aresta(j,i);
  	}
  }

  
  for(int j = 0; j < g.getN(); j++) {
    int *v = g.busca_largura(f,j);
    for(int i = 0; i < g.getN(); i++) {
        cout << v[i] << " ";
    }cout << endl;
  }
}
