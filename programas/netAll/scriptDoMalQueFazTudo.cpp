# include <iostream>
# include <cstring>
# include <cstdlib>
//# include "geraRedes.cpp"

int cmpStrings(const char*, const char*);

int main(int argc, char **argv) {

    int i = 0;

    if(argc - 1) {
        while(i++ < argc - 1) {
            if(cmpStrings(argv[i], "geraRedes")) {
                system("chmod +x geraRedes.sh && ./geraRedes.sh");
            }
            
            if(cmpStrings(argv[i], "netAll")) {
                i++;
                int numDivisoes = atoi(argv[i]);
                
                system("cp Grafo2.cpp Grafo2.h Redes/ && cp Makefile Redes/");
                system("chmod 777 netAll && cp netAll NetAll.cpp Redes/");
                system("cd Redes/ && make");
                
                switch(numDivisoes) {
                    case 1:
                        printf("entrou em 1\n");
                        system("./escrevaScriptNetAll 0 100");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        break;
                    case 2:
                        printf("entrou em 2\n");
                        system("./escrevaScriptNetAll 0 50");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        system("./escrevaScriptNetAll 51 100");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        break;
                    case 3:
                        system("./escrevaScriptNetAll 0 33");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        system("./escrevaScriptNetAll 34 68");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        system("./escrevaScriptNetAll 69 100");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        break;
                    case 4:
                        system("./escrevaScriptNetAll 0 25");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        system("./escrevaScriptNetAll 26 50");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        system("./escrevaScriptNetAll 51 75");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        system("./escrevaScriptNetAll 76 100");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        break;
                    case 5:
                        system("./escrevaScriptNetAll 0 20");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        system("./escrevaScriptNetAll 21 40");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        system("./escrevaScriptNetAll 41 60");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        system("./escrevaScriptNetAll 61 80");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        system("./escrevaScriptNetAll 81 100");
                        system("chmod +x scriptNETALL.sh");
                        system("cp scriptNETALL.sh Redes/ && cd Redes/ && ./scriptNETALL.sh");
                        break;
                    default:
                        printf("Escolha dividir as execucoes do netAll entre 1 e 5 vezes.\n");
                        exit(0);
                        break;
                }
            }
        }
    }else {
        //Fazer paradinha bonitinha interativa passo a passo
    }

    return 0;
}

int cmpStrings(const char *s1, const char *s2) {
    
    if(strstr(s1, s2) && !strcmp(s1, s2)) {
        return 1;    
    }

    return 0;
}
