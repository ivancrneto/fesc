/***************************************************************************
 *            Clusters.h
 *
 *  Mon Sep 10 17:21:31 2007
 *  Copyright  2007  User Alex Novaes de Santana
 *  Email alex.santana@gmail.com
 ****************************************************************************/

/*
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#ifndef _CLUSTERS_H_
#define _CLUSTERS_H_

#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <queue>
#include <stdlib.h>

using namespace std;

class Clusters{
	
	public:
		Clusters();
		Clusters(int);
		Clusters(vector<vector<int> >, int);
		vector< vector <int> > clusters; // vetores contento os elementos de cada cluster
		void clear();
		void searchClusters();
		void readNet(string file_net);
		void sortBySize();
		int getGreaterCluster(vector<int> *); //retorna o tamanho do maior cluster e coloca seus vertices na variavel passada.
		int getNohGreaterCluster();
		void removeNoh(int);
		void print();
	private:
		vector< int > marcadores;  // marcadores da busca em largura
		vector< vector <int> > matrix_adj; //matriz de adjacencias que representa a rede
		int vertices;
		int greaterClusterInd;
		int greaterClusterSize;
		int erroCod;
		void searchBreadth(vector< vector<int> >, int,int);
		bool cmp(vector<int>,vector<int>);
		void change(vector< vector<int> >::iterator,vector< vector<int> >::iterator);
		void erro(int);
};

#endif
