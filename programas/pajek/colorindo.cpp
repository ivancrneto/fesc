// programa para montar parte do .net para o pajek colorido

#include <stdio.h>


#define NV 327
// NV : numero de vertices
#define NC 7
// NC : numero de comunidades EXCLUINDO os vertices quase-isolados:
        // q serao pintados de preto 


	int main (int argc, char **argv) {
        
        
	FILE *entrada;
	entrada = fopen(argv[1], "r");
// nesse arquivo deve estar o valor da comunidade de cada vertice, na ordem dos vertices            


	FILE *saida;
	saida = fopen("colorido.net", "w");	
// nesse arquivo so FALTA A MATRIZ (OU LISTA) DE ADJACENCIA
// para estar pronto para ser levado ao pajek


            
        int cor, k, p;


    fprintf(saida,"*Vertices %d\n",NV);
    

	for(k=1;k<=NV;k++) {

        p=k;
        
	fscanf(entrada,"%d",&cor);

	if( cor==(NC+1))  {
        
    fprintf(saida,"%d \"H%dH\" ic Magenta\n",p, p);
    
                      }else{
                            
	if( cor==1 ) fprintf(saida,"%d \"H%dH\" ic Black\n",p, p);
	if( cor==2 ) fprintf(saida,"%d \"H%dH\" ic Green\n",p, p);
	if( cor==3 ) fprintf(saida,"%d \"H%dH\" ic Red\n",p, p);
	if( cor==4 ) fprintf(saida,"%d \"H%dH\" ic Blue\n",p, p);
	
	if( cor==5 ) fprintf(saida,"%d \"H%dH\" ic Cyan\n",p, p);
	if( cor==6 ) fprintf(saida,"%d \"H%dH\" ic Yellow\n",p, p);
	if( cor==7 ) fprintf(saida,"%d \"H%dH\" ic Magenta\n",p, p);
	if( cor==8 ) fprintf(saida,"%d \"H%dH\" ic BrickRed\n",p, p);
	
	if( cor==9 ) fprintf(saida,"%d \"H%dH\" ic OliveGreen\n",p, p);
	if( cor==10 ) fprintf(saida,"%d \"H%dH\" ic DarkOrchid\n",p, p);
	if( cor==11 ) fprintf(saida,"%d \"H%dH\" ic BrickRed\n",p, p);
	if( cor==12 ) fprintf(saida,"%d \"H%dH\" ic OliveGreen\n",p, p);

                           }

                      } // for
    


	fclose(entrada);
	fclose(saida);

    return(0);
    
}

