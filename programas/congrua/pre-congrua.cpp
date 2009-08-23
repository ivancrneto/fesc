# include <iostream>
# include <cstdlib>
# include <cstring>

using namespace std;

// acetyl.dat e udp.dat sao os arquivos de 0's e 1's que sao saida do programa
// congtabin.cpp. o congtabin imprime os binarios de a, g, h, p e u, em ordem.
// ./congrua acetyl.dat 12 (numero de comunidades da acetyl)
// ./congrua udp.dat 7 (numero de comunidades da udp)
//

int main(int argc, char **argv) {
      FILE *arq = fopen(argv[1], "r");
      if (arq != NULL) {
            string str = "", str2 = "";
            char *tok;
            int counter = 1;
            tok = strtok(argv[1], ".");
            str2 += tok;
            str2 += "_2.txt";
            FILE *out = fopen(str2.c_str(), "w");
            while(!feof(arq)) {
                  if(counter == 383) break;
                  int d = 0;
                  for(int i = 0; i < atoi(argv[2]); i++) {
                        fscanf(arq, "%d", &d);
                        if(d != 0) {
                              fprintf(out, "%d\t%d\n", counter, i + 1);
                              for(int j = i + 1; j < atoi(argv[2]); j++) {
                                    fscanf(arq, "%d", &d);                                    
                              }
                              d = 1;
                              break;
                        }
                  }
                  if(d == 0) {
                        fprintf(out, "%d\t%d\n", counter, d);
                  }
                  counter++;
            }
            fclose(arq);
            fclose(out);
      }else {
            exit(0);
      }
}
