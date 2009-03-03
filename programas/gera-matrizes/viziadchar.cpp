# include <iostream>
# include <cstdlib>

using namespace std;

int main(int argc, char **argv) {

      FILE *in, *out;
      in = fopen(argv[1], "r");
      int size = atoi(argv[2]), count = 0, total = 0;
      if(in != NULL) {
            string str = "";
            str += argv[1];
            cout << str << " ";
            str += "_adj";
            cout << str << endl;
            out = fopen(str.c_str(), "w");
            if(out != NULL) {
                  while(!feof(in)) {
                        int x;
                        char c;
                        fscanf(in, "%d%c", &x, &c);
                        count++;
                        if(total < size * size) {
                              if(x != 1) {
                                    fprintf(out, "%d", 0, c);
                                    if(count == size) {
                                          //fprintf(out, "%d", 0);
                                          fprintf(out, "\n");
                                          count = 0;
                                    } //else
                                          //fprintf(out, "%d%c", 0, c);
                              }else {
                                    fprintf(out, "%d", x, c);
                                    if(count == size) {
                                          //fprintf(out, "%d", x);
                                          fprintf(out, "\n");
                                          count = 0;
                                    } //else
                                          //fprintf(out, "%d%c", x, c);
                              }
                        }
                        total++;
                        //getchar();
                  }
                  fclose(in);
            } else {
                  printf("Arquivo de entrada nulo\n");
                  exit(0);
            }
      }else {
            printf("Arquivo de entrada nulo\n");
            exit(0);
      }

      return 0;
}
