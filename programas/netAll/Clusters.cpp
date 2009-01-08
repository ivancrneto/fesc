#include "Clusters.h"

Clusters::Clusters()
{
	this->vertices = -1;
	this->greaterClusterInd = 0;
	this->greaterClusterSize = 0;
}

Clusters::Clusters(int local_vertices)
{
	this->vertices = local_vertices;
	this->marcadores.assign(this->vertices,0);
	this->matrix_adj.assign(this->vertices,this->marcadores);
	this->greaterClusterInd = 0;
	this->greaterClusterSize = 0;
}

Clusters::Clusters(vector<vector<int> > mat, int numVertices)
{
	int i,j;

	this->vertices = numVertices;
	this->marcadores.assign(this->vertices,0);
	this->matrix_adj.assign(this->vertices,this->marcadores);
	this->greaterClusterInd = 0;
	this->greaterClusterSize = 0;

	for (i=0;i<numVertices;i++)
	{
		for (j=0;j<numVertices;j++)
		{
			this->matrix_adj.at(i).at(j) = mat.at(i).at(j);
		}
	}
}

void Clusters::readNet(string file_net)
{
	ifstream net; // abertura do arquivo para somente leitura
	bool edges = false; // flag para detectar onde começa a definicao das arestas
	string linha; //string usada na leitura do arquivo 
	net.open(file_net.c_str(),ios::in);
	if(!net)
	{
		this->erro(0);
	}
	if(1)
	{
		net >> linha >> this->vertices;
		this->marcadores.assign(this->vertices,0);
		this->matrix_adj.assign(this->vertices,this->marcadores);
	}
	while(!edges && (net >> linha))  // equanto não achar a palavra chave "*Edges" ande no arquivo
	{
		if(linha == "*Edges") edges = true;
	}
	if(edges)  // se encontrou a palavra chave
	{
		int v1,v2;
		while(net >> v1 >> v2) // leitura para preencher a matriz de adjacencias
		{
			matrix_adj.at(v1-1).at(v2-1) = 1;
			matrix_adj.at(v2-1).at(v1-1) = 1;
		}
	}
}

void Clusters::searchClusters()
{
	int i = 0,j = 0;
	bool raiz = true;
	while((raiz) && (i < this->vertices))
	{
		if(marcadores.at(i)==0)
		{
			if(matrix_adj.at(i).at(j) == 1)
			{	
				this->searchBreadth(matrix_adj, i, vertices);
			}
			else{
				if(j == (vertices - 1))
				{
					i++;
					j = 0;
				}
		     		else
					j++;
			}
		}
		else if(i < (vertices-1))
		{
			 i++;
			 j = 0;
		}
		else raiz = false;
	}
}

void Clusters::searchBreadth(vector< vector <int> > matrix, int root, int vertices)
{
	queue<int> fila;  // fila usada na busca em largura
	int contador = 0;
	vector<int> nohs;
	
	marcadores.at(root) = 1;
	fila.push(root);
	nohs.push_back(root+1);  // guardando lugar para colocar o contador
	contador++;
	while(!fila.empty())
	{
		int front = fila.front();
		for(int j = 0; j<vertices; j++)
		{

			if((matrix.at(front).at(j) == 1) && (marcadores.at(j) == 0))
			{
				marcadores.at(j) = 1;
				fila.push(j);
				contador++;
				nohs.push_back(j+1);
			}
		}
		fila.pop();
		
	}
	nohs.push_back(root+1);
	nohs.at(0) = contador;
	if(contador > this->greaterClusterSize)
	{
		this->greaterClusterSize = contador;
		this->greaterClusterInd = clusters.size();
	}
	this->clusters.push_back(nohs);
}

bool Clusters::cmp(vector<int> elemA,vector<int> elemB)
{
	return elemA.at(0) > elemB.at(0);
}

void Clusters::change(vector< vector<int> >::iterator from,vector< vector<int> >::iterator to)
{
	vector<int> temp;
	unsigned int i;
	temp.assign((*from).size(),0);
	for(i = 0; i < (*from).size();i++)
	{
		temp.at(i) = from->at(i);
	}
	from->clear();
	from->assign(to->size(),0);
	for(i = 0; i < to->size();i++)
	{
		from->at(i) = to->at(i);
	}
	to->clear();
	to->assign(temp.size(),0);
	for(i = 0; i < temp.size();i++)
	{
		to->at(i) = temp.at(i);
	}

}

void Clusters::sortBySize()
{
	vector< vector<int> >::iterator cluster_it2;
	vector< vector<int> >::iterator cluster_it1;
	for(cluster_it2 = this->clusters.begin(); cluster_it2 != this->clusters.end();cluster_it2++)
	{
		cluster_it1 = cluster_it2;
		if(++cluster_it2 == this->clusters.end()) break;
		if(cmp((*cluster_it2),(*cluster_it1)))
		{	
			this->change(cluster_it2,cluster_it1);
		}
	}
}

int Clusters::getGreaterCluster(vector<int> *vertices)
{
	for(int i = 1; i <= this->greaterClusterSize; i++)
	{
		(*vertices).push_back(this->clusters.at(this->greaterClusterInd).at(i));
	}
	
	return this->greaterClusterSize;
}

int Clusters::getNohGreaterCluster()
{
	if(clusters.size() == 0)
	{
		this->erro(1); // erro para a nao existencia de clusters, todos os noh isolados
		return 0;
	}
	return (this->clusters.at(greaterClusterInd).at(1)-1); //retorna o '1' pq o '0' é o tamanho do cluster.
}

void Clusters::removeNoh(int noh)
{
	noh--;
	for(int i = 0; i<this->vertices; i++)
	{
		if(matrix_adj.at(noh).at(i) == 1)
		{
				matrix_adj.at(noh).at(i) = 0;
				matrix_adj.at(i).at(noh) = 0;
		}
	}
}

void Clusters::print()
{
	vector< vector<int> >::iterator it_col;
	vector< int >::iterator it_lin;
	bool contador = true;
	
	cout << "----------------------------------------" << endl;
	for(it_col = this->clusters.begin(); it_col != this->clusters.end(); it_col++)
	{
		for(it_lin = it_col->begin(); it_lin != it_col->end(); it_lin++)
		{
			if(contador)
			{
				cout << "Cluster size = " << (*it_lin) << " | nohs -> ";
				contador = false;
			}
			else cout << (*it_lin) << " ";
		}
		cout << endl;
		contador = true;
	}
	cout << "----------------------------------------" << endl;
}


void Clusters::clear()
{
	this->marcadores.assign(this->vertices,0);
	this->clusters.clear();
	this->greaterClusterInd = 0;
	this->greaterClusterSize = 0;
}

void Clusters::erro(int codigo)
{
	switch(codigo)
	{
		case 0: 
			cerr << "ERRO NA ABERTURA DO ARQUIVO" << endl;
			break;
		case 1:
			cerr << "OBS: NAO EXISTE CLUSTERS. TODOS OS NOH DESCONECTADOS" << endl;
	}
	this->erroCod = codigo;
	if (codigo ==0) exit(1);
}
