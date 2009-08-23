# include <iostream>
# include <cstdlib>
# include <cstring>

// argumento 1 eh o primeiro txt alterado contendo os vertices em ordem e sua respectiva comunidade
// argumento 2 eh o segundo txt alterado contendo os vertices em ordem e sua respectiva comunidade
//./congrua acetyl_2.txt udp_2.txt
// acetyl_2.txt e udp_2.txt sao gerados a partir de pre-congrua.cpp

using namespace std;

int main(int argc, char **argv) {
      FILE *arq = fopen(argv[1], "r");
      FILE *arq2 = fopen(argv[2], "r");
      if (arq != NULL && arq2 != NULL) {
            string str = "", str2 = "";
            char *tok;
            int counter = 1;
            int mat[12][12];
            
            for( int i = 0; i < 12; i++) {
                  for( int j = 0; j < 12; j++) {
                        mat[i][j] = 0;
                  }
            }
            
            tok = strtok(argv[1], ".");
            str2 += tok;
            tok = strtok(argv[2], ".");
            str2 += tok;
            str2 += ".txt";
            FILE *out = fopen(str2.c_str(), "w");

            int maxd1 = 0, maxd2 = 0;
            while(!feof(arq)) {
                  if(counter == 383) break;
                  
                  int d, d1 = 0, d2 = 0;
                  fscanf(arq, "%d\t%d", &d, &d1);
                  fscanf(arq2, "%d\t%d", &d, &d2);
                  
                  maxd1 = (d1 > maxd1) ? d1 : maxd1;
                  maxd2 = (d2 > maxd2) ? d2 : maxd2;
                  
                  if(d1 && d2) {
                        mat[d1 - 1][d2 - 1]++;
                  }
                  
                  counter++;
            }
            
            for( int i = 0; i < maxd1; i++) {
                  for( int j = 0; j < maxd2; j++) {
                        if(mat[i][j] <= 9) {
                              fprintf(out, "   %d", mat[i][j]);
                        } else {
                              fprintf(out, "  %d", mat[i][j]);
                        }
                  }
                  fprintf(out, "\n");
            }
            
            fclose(arq);
            fclose(out);
      }else {
            exit(0);
      }
}
