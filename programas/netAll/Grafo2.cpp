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
 *
 * CHARLES NOVAES DE SANTANA, 15 DE FEVEREIRO DE 2008.
 *
 * */

#include "Grafo2.h"

/********************* M E T O D O S             P R I V A D O S ****************/

/* Construtor
 * */
Grafo::Grafo()
{
	this->nomeArquivoPajek = (char*)malloc(sizeof(char));
	this->nomeArquivoSaidaIndices = (char*)malloc(sizeof(char));
	this->nomeArquivoSaidaVizinhanca = (char*)malloc(sizeof(char));
	this->numArestasRede = 0;
	this->ind_Diametro = 0;
}

/* Destrutor
 * */
Grafo::~Grafo()
{
	//free(this->nomeArquivoPajek);
	//free(this->nomeArquivoSaidaIndices);
	//free(this->nomeArquivoSaidaVizinhanca);
	this->mat_Adjacencias.clear();
	this->mat_ArvoreGeradoraMinima.clear();
	this->nomesVertices.clear();
	this->mat_CamMin.clear();
	this->grauVertices.clear();
}

/* Metodo para inicializar com valores nulos a matriz de adjacencias associada ao Grafo lido
 * */
void Grafo::inicializa_MatrizAdjacencias(void)
{
	vector<int> listaVazia;
	vector<tMatriz> listaVaziaMat;

	listaVazia.assign(this->numVerticesRede,0);
	listaVaziaMat.assign(this->numVerticesRede,0);
	this->mat_Adjacencias.assign(this->numVerticesRede,listaVaziaMat);
	this->mat_ArvoreGeradoraMinima.assign(this->numVerticesRede,listaVaziaMat);
	this->grauVertices.assign(this->numVerticesRede,0);
	this->aglomVertices.assign(this->numVerticesRede,0.0);
	this->caminhoMinimoMedio_vert.assign(this->numVerticesRede,0);
	this->mat_CamMin.assign(this->numVerticesRede,listaVazia);
	listaVazia.clear();
}
/* Metodo para leitura do grafo no arquivo Pajek no formato de Lista de Adjacencias
 * */
void Grafo::ler_GrafoLista(void)
{
	int i,j;
	char lixo[20];
	char nomeVertice[20];
	float peso;
	ifstream arq;

	arq.open(this->nomeArquivoPajek.c_str(),ios::in);
	arq >> lixo >> this->numVerticesRede;//comecar a ler os vertices
	this->inicializa_MatrizAdjacencias();
	for (i=0;i<this->numVerticesRede;i++)
	{
		arq >> j >> nomeVertice;
		this->nomesVertices.push_back(nomeVertice);
	}
	arq >> lixo;//comecar a ler as arestas
	while(!arq.eof())
	{
// se as arestas tiverem peso, descomentar linha abaixo e comentar a seguinte:
//		arq >> i >> j >> peso;
		arq >> i >> j;
		this->mat_Adjacencias.at(i-1).at(j-1) = 1;
		this->mat_Adjacencias.at(j-1).at(i-1) = 1;
	}
//	this->imprime_MatrizAdjacencias();
	arq.close();
	
	return;
}

/* Metodo para leitura do grafo no arquivo Pajek no formato de Matriz de Adjacencias
 * */
void Grafo::ler_GrafoMatriz(void)
{
	int i,j;
	tMatriz num;
	char nomeVertice[20];
	char lixo[20];
	ifstream arq;

	arq.open(this->nomeArquivoPajek.c_str(),ios::in);
	arq >> lixo >> this->numVerticesRede;//comecar a ler os vertices
	this->inicializa_MatrizAdjacencias();
	for (i=0;i<this->numVerticesRede;i++)
	{
		arq >> j >> nomeVertice;
		this->nomesVertices.push_back(nomeVertice);
	}
	arq >> lixo;//comecar a ler as arestas
	for (i=0;i<this->numVerticesRede;i++)
	{
		for (j=0;j<this->numVerticesRede;j++)
		{
			arq >> num;
			this->mat_Adjacencias.at(i).at(j) = num;
		}
	}
//	this->imprime_MatrizAdjacencias();
	arq.close();

	return;
}


/* Metodo que chama todos os metodos de calculo de indices da Rede
 *
 * Alguns indices ja sao calculados automaticamente, durante a leitura da rede do arquivo .net. Sao eles:
 * - Numero de Vertices
 * - Numero de Arestas
 * */
void Grafo::calc_Indices(void)
{
	this->calc_GrauMedio();
	this->calc_Arestas();
        this->calc_MatrizCaminhosMinimos();//a matriz deve ser construida antes de chamar as funcoes de calculo do CMM_si e CMM_ci
	this->calc_Diametro();
	this->calc_CaminhoMinimoMedio_vert();
	this->calc_CaminhoMinimoMedio_rede_ci();
	this->calc_CaminhoMinimoMedio_rede_si();
	this->calc_VetCoeficienteAglom();
	this->calc_AglomeracaoMedia();
	this->calc_ParesNaoConectados();
        this->calc_Betweeness();
//	this->calc_ArvoreGeradoraMinima();

	return;
}

/* Metodo que calcula o Numero de Pares Nao Conectados na rede
 * */
void Grafo::calc_ParesNaoConectados(void)
{
	int arestasPossiveis;

	arestasPossiveis = (this->numVerticesRede * (this->numVerticesRede - 1))/2;
	this->ind_NaoConectados = arestasPossiveis - this->numArestasRede;

	return;
}

/* Metodo que calcula o Caminho Minimo enre dois vertices quaisquer da rede
 * */
int Grafo::calc_CaminhoMinimo(long int origem, long int destino)
{
	queue<int> fila;
	vector<int> marcadores;
	int k, primeiro, sair;

	marcadores.assign(this->numVerticesRede,0);
	fila.push(origem);
	marcadores.at(origem) = 0;
	sair = 0;

	while((!fila.empty()) && (!sair))
	{
		primeiro = fila.front();
		k=0;
		while ((k<this->numVerticesRede) && (!sair))
		{
			if ((this->mat_Adjacencias.at(primeiro).at(k) == 1) && (marcadores.at(k) == 0) && (!sair))
			{
				marcadores.at(k) = marcadores.at(primeiro) + 1;
				fila.push(k);
				if (k == destino)
				{
					sair = 1;
				}
			}
			k++;
		}
		fila.pop();
	}
	if (!sair)
	{
		marcadores.at(destino) = -1;
	}

	return(marcadores.at(destino));	
}

/* Metodo que calcula a matriz de Caminhos Minimos
 * */
void Grafo::calc_MatrizCaminhosMinimos(void)
{
	int i,j,caminho;

	for (i=0;i<this->numVerticesRede;i++)
	{
		for (j=0;j<this->numVerticesRede;j++)
		{
			if (i!=j)
			{
				caminho = this->calc_CaminhoMinimo(i,j);
				this->mat_CamMin.at(i).at(j) = caminho;
				this->mat_CamMin.at(j).at(i) = caminho;
			}
			else
			{
				this->mat_CamMin.at(i).at(j) = 0;
			}
		}
	}

	return;
}

void Grafo::calc_Betweeness(void)
{
	vector<int> vert_CaminhoMinimo;

	return;
}

/* Metodo que calcula o Caminho Minimo Medio de cada Vertice
 * */
void Grafo::calc_CaminhoMinimoMedio_vert(void)
{
	int i,j;
	int cont=0;

	for (i=0;i<this->numVerticesRede;i++)
	{
		cont = 0;
		for (j=0;j<this->numVerticesRede;j++)
		{
			if ((this->mat_CamMin.at(i).at(j) != -1)&&(i!=j))
			{
				this->caminhoMinimoMedio_vert.at(i) += (float)this->mat_CamMin.at(i).at(j);			
				cont++;
			}
		}
		if (cont)
		{
			this->caminhoMinimoMedio_vert.at(i) =((float)this->caminhoMinimoMedio_vert.at(i)/cont);
		}
		else
		{
			this->caminhoMinimoMedio_vert.at(i) = 0;
		}
	}

	return;
}

/* Metodo que calcula o Caminho Minimo Medio da Rede, considerando os vertices isolados
 * */
void Grafo::calc_CaminhoMinimoMedio_rede_ci(void)
{
	int i;


	this->ind_CamMin_ci = 0;
	for (i=0;i<this->numVerticesRede;i++)
	{
		this->ind_CamMin_ci += this->caminhoMinimoMedio_vert.at(i);
	}
	this->ind_CamMin_ci /= this->numVerticesRede;

	return;
}

/* Metodo que calcula o Caminho Minimo Medio da Rede, desconsiderando os vertices isolados
 * */
void Grafo::calc_CaminhoMinimoMedio_rede_si(void)
{
	int i,cont=0;

	this->ind_CamMin_si = 0;
	for (i=0;i<this->numVerticesRede;i++)
	{
		if (this->grauVertices.at(i))
		{
			this->ind_CamMin_si += this->caminhoMinimoMedio_vert.at(i);
			cont++;
		}
	}
	this->ind_CamMin_si /= cont;

	return;
}

/* Metodo que calcula o Diametro da Rede
 * */
void Grafo::calc_Diametro(void)
{
	int i,j;

	for (i=0;i<this->numVerticesRede;i++)
	{
		for (j=0;j<this->numVerticesRede;j++)
		{
//			cout << this->mat_CamMin.at(i).at(j) << " ";
			if (this->mat_CamMin.at(i).at(j) > this->ind_Diametro)
			{
				this->ind_Diametro = this->mat_CamMin.at(i).at(j);
			}
		}
//		cout << endl;
	}
	
	return;
}

/* Metodo que calcula o numero de arestas da rede
 * */
void Grafo::calc_Arestas(void)
{
	int i,j;
	sAresta arestaAux;

	for (i=0;i<this->numVerticesRede;i++)
	{
		for (j=i+1;j<this->numVerticesRede;j++)
		{
			if (this->mat_Adjacencias.at(i).at(j) != 0)
			{
				arestaAux.i = i;
				arestaAux.j = j;
				this->arestasRede.push_back(arestaAux);
				arestaAux.i = j;
				arestaAux.j = i;
				this->arestasRede.push_back(arestaAux);
				this->numArestasRede++;
			}
		}
	}
}

/* Metodo que calcula o Grau de cada vertice da rede
 * */
void Grafo::calc_GrauVertices(void)
{
	int i,j;

	for (i=0;i<this->numVerticesRede;i++)
	{
		for (j=0;j<this->numVerticesRede;j++)
		{
			if (this->mat_Adjacencias.at(i).at(j) != 0)
			{
				this->grauVertices.at(i)++;
			}
		}
	}
	return;
}

/* Metodo que calcula o Grau Medio da Rede
 * */
void Grafo::calc_GrauMedio(void)
{
	int i,somatorioGraus=0;

	this->calc_GrauVertices();
	for (i=0;i<this->numVerticesRede;i++)
	{
		somatorioGraus+=this->grauVertices.at(i);
	}
	this->ind_GrauMedio = (float)somatorioGraus/this->numVerticesRede;

	return;
}

/* Metodo que calcula o Coeficiente de Aglomeracao de um vertice 'i' da Rede
 * */
void Grafo::calc_AglomVertices(int i)
{
	int arestasVizinhos_teo,arestasVizinhos_efe;
	int *verticesVizinhos;
	int j,cont,k;

	arestasVizinhos_teo = (this->grauVertices.at(i)*(this->grauVertices.at(i) - 1))/2;

	verticesVizinhos = (int*)malloc(sizeof(int)*this->grauVertices.at(i));
	cont =0;
	// IDENTIFICANDO OS VIZINHOS DO VERTICE 'i'
	for (j=0;j<this->numVerticesRede;j++)
	{
		if (this->mat_Adjacencias.at(i).at(j) != 0)
		{
			verticesVizinhos[cont] = j;	
			cont++;
		}
	}
	// CONTABILIZANDO QUANTOS DOS VIZINHOS DO VERTICE 'i' SAO VIZINHOS ENTRE SI
	arestasVizinhos_efe =0;
	for (j=0;j<this->grauVertices.at(i);j++)
	{
		for (k=j+1;k<this->grauVertices.at(i);k++)
		{
			if (this->mat_Adjacencias.at(verticesVizinhos[j]).at(verticesVizinhos[k]) != 0)
			{
				arestasVizinhos_efe++;
			}
		}
	}	
	// CALCULANDO A AGLOMERACAO
	if (arestasVizinhos_teo != 0)
	{
		this->aglomVertices.at(i) = ((float)arestasVizinhos_efe/arestasVizinhos_teo);
	}
	else// SE FOR UM VERTICE ISOLADO
	{
		this->aglomVertices.at(i) = 0.0;
	}

	return;
}

/* Metodo que calcula os Coeficientes de Aglomeracao de todos os vertices da Rede
 * */
void Grafo::calc_VetCoeficienteAglom(void)
{
	int i;

	for (i=0;i<this->numVerticesRede;i++)
	{
		this->calc_AglomVertices(i);
	}

	return;
}

/* Metodo que calcula o numero de vertices nao isolados da Rede
 * */
void Grafo::calc_NumVerticesNaoIsolados(void)
{
	int i;
	
	this->numVerticesNaoIsolados = 0;
	for (i=0;i<this->numVerticesRede;i++)
	{
		if (this->grauVertices.at(i) > 0) this->numVerticesNaoIsolados++;
	}
	return;
}

/* Metodo que calcula o Coeficiente de Aglomeracao Medio da Rede
 * */
void Grafo::calc_AglomeracaoMedia(void)
{
	int i;
	float somatorioAglom=0.0;
	
	this->calc_NumVerticesNaoIsolados();

	for (i=0;i<this->numVerticesRede;i++)
	{
		somatorioAglom= somatorioAglom + this->aglomVertices.at(i);
	}
	this->ind_AglomeracaoMedia = somatorioAglom/this->numVerticesNaoIsolados;

	return;
}

/********************* M E T O D O S             P U B L I C O S ****************/

/* Metodo generico para leitura do grafo
 * */
void Grafo::ler_Grafo(char tipoArquivo[5])
{
	if (strstr("mat",tipoArquivo))
	{
		this->ler_GrafoMatriz();
	}
	else if (strstr("lis",tipoArquivo))
	{
		this->ler_GrafoLista();
	}
	else
	{
		cout << endl << "O tipo de arquivo Pajek solicitado nao eh conhecido pelo NetAll!" << endl << endl;
		exit(1);
	}

	return;
}

/* Metodo que imprime os valores indices de cada vertice da rede
 * */
void Grafo::imprime_Estatisticas(void)
{
	int i;
	fstream arq;

	this->nomeArquivoSaidaIndices += ".pth";
	arq.open(this->nomeArquivoSaidaIndices.c_str(),ios::out);
	arq << "<vertice>\t<grau>\t<aglomeracao>\t<caminhoMinimoMedio>" << endl;
	for(i=0;i<this->numVerticesRede;i++)
	{
		arq << this->nomesVertices.at(i) << "\t" << this->grauVertices.at(i) << "\t" << this->aglomVertices.at(i) << "\t" << this->caminhoMinimoMedio_vert.at(i) << endl;
	}
	arq.close();

	return;
}

/*
 * */
void Grafo::imprime_MatrizVizinhanca(void)
{
	int i,j;
	fstream arq;

	this->nomeArquivoSaidaVizinhanca += ".mat";
	arq.open(this->nomeArquivoSaidaVizinhanca.c_str(),ios::out);
	for (i=0;i<this->numVerticesRede;i++)
	{
		for (j=0;j<this->numVerticesRede;j++)
		{
			if (this->mat_CamMin.at(i).at(j) == -1)
			{
				arq << "0 ";
			}
			else
			{
				arq << this->mat_CamMin.at(i).at(j) << " ";
			}
		}
		arq << endl;
	}
	arq.close();
	
	return;
}

/* Metodo que imprime os valores dos indices medios calculados na tela
 * */
void Grafo::imprime_Saida(void)
{
	cout << this->nomeArquivoPajek << " " << this->numVerticesRede << " " << this->numArestasRede << " " << this->ind_Diametro << " " << this->ind_AglomeracaoMedia << " " << this->ind_CamMin_si << " " << this->ind_CamMin_ci << " " << this->ind_GrauMedio << " " << this->ind_NaoConectados << endl;

	this->imprime_Estatisticas();
	this->imprime_MatrizVizinhanca();

	return;
}

/* Metodo para imprimir a Arvore Geradora Minima
 * */
void Grafo::imprime_ArvoreGeradoraMinima(void)
{
	int i,j;

	cout << endl << "ARVORE MINIMA GERADORA" << endl;
	for (i=0;i<this->numVerticesRede;i++)
	{
		for (j=0;j<this->numVerticesRede;j++)
		{
			cout << this->mat_ArvoreGeradoraMinima.at(i).at(j) << " ";
		}
		cout << endl;
	}
}

/* Metodo para imprimir na tela a matriz de adjacencias associada ao Grafo lido
 * */
void Grafo::imprime_MatrizAdjacencias(void)
{
	int i,j;

	for (i=0;i<this->numVerticesRede;i++)
	{
		for (j=0;j<this->numVerticesRede;j++)
		{
			cout << this->mat_Adjacencias.at(i).at(j) << " ";
		}
		cout << endl;
	}

	cout << endl << endl;
}

