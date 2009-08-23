# include <iostream>
# include <cstdlib>
# include <fstream>
# include <cstring>
# include <vector>
# include <algorithm>

// ./congruencia congruencia1.csv a u > a-u.csv
// Nesse exemplo pega entrada de congruencia1

using namespace std;

class Sequencia {
      private:
            char proteina;
            int naosei1;
            int naosei2;
            int gi;
            string complemento;
            string ecnumber;
            string comunidade;
            string nome;
            int id;
            int codcomuna;
      public:
            Sequencia();
            ~Sequencia();
            char getProteina();
            void setProteina(char proteina);
            int getNaosei1();
            void setNaosei1(int naosei1);
            int getNaosei2();
            void setNaosei2(int naosei2);
            int getGi();
            void setGi(int gi);
            string getComplemento();
            void setComplemento(string complemento);
            string getEcnumber();
            void setEcnumber(string ecnumber);
            string getComunidade();
            void setComunidade(string comunidade);
            string getNome();
            void setNome(string nome);
            int getId();
            void setId(int id);
            int getCodcomuna();
            void setCodcomuna(int codcomuna);
            void imprime();    
};

Sequencia::Sequencia() {}
Sequencia::~Sequencia() {}

char Sequencia::getProteina() {
      return proteina;      
}

void Sequencia::setProteina(char proteina) {
      Sequencia::proteina = proteina;
}

int Sequencia::getNaosei1() {
      return naosei1;
}

void Sequencia::setNaosei1(int naosei1) {
      Sequencia::naosei1 = naosei1;
}

int Sequencia::getNaosei2() {
      return naosei2;
}

void Sequencia::setNaosei2(int naosei2) {
      Sequencia::naosei2 = naosei2;
}

int Sequencia::getGi() {
      return gi;
}

void Sequencia::setGi(int gi) {
      Sequencia::gi = gi;
}

string Sequencia::getComplemento() {
      return complemento;
}

void Sequencia::setComplemento(string complemento) {
      Sequencia::complemento = complemento;
}

string Sequencia::getEcnumber() {
      return ecnumber;
}

void Sequencia::setEcnumber(string ecnumber) {
      Sequencia::ecnumber = ecnumber;
}

string Sequencia::getComunidade() {
      return comunidade;
}

void Sequencia::setComunidade(string comunidade) {
      Sequencia::comunidade = comunidade;
}

string Sequencia::getNome() {
      return nome;
}

void Sequencia::setNome(string nome) {
      Sequencia::nome = nome;
}

int Sequencia::getId() {
      return id;
}

void Sequencia::setId(int id) {
      Sequencia::id = id;
}

int Sequencia::getCodcomuna() {
      return codcomuna;
}

void Sequencia::setCodcomuna(int codcomuna) {
      Sequencia::codcomuna = codcomuna;
}

void Sequencia::imprime() {
      if(getComplemento() != "sp" && getComplemento() != "gb*") {
            cout << getProteina() << "|" << getNaosei1() << "|" << getNaosei2();
            cout << "|" << getGi() << "|" << getComplemento() << "||" << getEcnumber();
            cout << "|" << getComunidade() << "|" << getNome() << "|" << getId();
            cout << "|" << getCodcomuna() << endl;
      } else {
            cout << getProteina() << "|" << getNaosei1() << "|" << getNaosei2();
            cout << "|" << getGi() << "|" << getComplemento() << "|" << getEcnumber();
            cout << "|" << getComunidade() << "|" << getNome() << "|" << getId();
            cout << "|" << getCodcomuna() << endl;
      }
}

bool compare(Sequencia seq1, Sequencia seq2) {
      return (seq1.getId() < seq2.getId());
}

int main(int argc, char **argv) {
      ifstream arquivo;
      vector<Sequencia> vec_sec;
      
      arquivo.open (argv[1], ifstream::in);
      if (arquivo.good()) {
            
            char chr[512], **chr_t;
            int cont = 0, num;
            
            chr_t = (char **) malloc(sizeof(char *) * 12);
            
            while(!arquivo.eof()) {
                  arquivo.getline(chr, 512);
                  //getchar();
                  //cout << chr << endl;
                  int i = 1;
                  chr_t[0] = strtok(chr,"|");
                  Sequencia seq = Sequencia();
                  while(chr_t[0] != NULL)
                  {
                        //printf("%s\n", chr_t[0]);
                        chr_t[i] = chr_t[0];
                        chr_t[0] = strtok(NULL, "|");
                        i++;
                  }
                  
                  if(chr_t[1][0] != argv[2][0] && chr_t[1][0] != argv[3][0]) {
                        continue;
                  }
                  
                  seq.setProteina(chr_t[1][0]);
                  seq.setNaosei1(atoi(chr_t[2]));
                  seq.setNaosei2(atoi(chr_t[3]));
                  seq.setGi(atoi(chr_t[4]));
                  
                  string str = "";
                  str += chr_t[5];
                  seq.setComplemento(str);
                  if(str == "sp" || str == "gb*") {
                        str = "";
                        str += chr_t[6];
                        str += "|";
                        str += chr_t[7];
                        //cout << "STR: " << str << endl;
                        seq.setEcnumber(str);
                        chr_t[7] = chr_t[8];
                        chr_t[8] = chr_t[9];
                        chr_t[9] = chr_t[10];
                        chr_t[10] = chr_t[11];
                  }else {
                        str = "";
                        str += chr_t[6];
                        seq.setEcnumber(str);
                  }
                  str = "";
                  str += chr_t[7];
                  seq.setComunidade(str);
                  str = "";
                  str += chr_t[8];
                  seq.setNome(str);
                  seq.setId(atoi(chr_t[9]));
                  seq.setCodcomuna(atoi(chr_t[10]));
                  /*printf("BLA\n");
                  for(i = 1; i < 11; i++) {
                        printf("%d = %s\n", i, chr_t[i]);
                  }
                  printf("BLI\n"); */
                  //seq.imprime();
                  vec_sec.push_back(seq);
            }
            
            //vec_sec.pop_back();
            
            sort(vec_sec.begin(), vec_sec.end(), compare);
            
            /*for(int i = 0; i < vec_sec.size(); i++) {
                  if(vec_sec[i].getProteina() != argv[2][0] || 
                     vec_sec[i].getProteina() != argv[3][0]) {
                        vec_sec.erase(vec_sec.begin() + i);
                  }
            }*/
            
            for(int i = 0; i < vec_sec.size(); i++) {
                  vec_sec[i].imprime();
            }
      }else {
            exit(0);
      }
}
