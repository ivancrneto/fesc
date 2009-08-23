#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include <vector>
#include <algorithm>

using namespace std;

//http://oopweb.com/CPP/Documents/CPPHOWTO/Volume/C++Programming-HOWTO-7.html

void tokenize(const string& str,
                      vector<string>& tokens,
                      const string& delimiters = " ")
{
    // Skip delimiters at beginning.
    string::size_type lastPos = str.find_first_not_of(delimiters, 0);
    // Find first "non-delimiter".
    string::size_type pos     = str.find_first_of(delimiters, lastPos);

    while (string::npos != pos || string::npos != lastPos)
    {
        // Found a token, add it to the vector.
        tokens.push_back(str.substr(lastPos, pos - lastPos));
        // Skip delimiters.  Note the "not_of"
        lastPos = str.find_first_not_of(delimiters, pos);
        // Find next "non-delimiter"
        pos = str.find_first_of(delimiters, lastPos);
    }
}

/*  converte planilha congruencia1.csv para planilha de formato binario, que
    serve como entrada para o congrua
    ./congtabin congruencia1.csv
*/


int main(int argc, char **argv) {

    string str;
    ifstream file;
    vector<string> tokens;
    int matrix[382][44];
            
    for( int i = 0; i < 382; i++) {
        for( int j = 0; j < 44; j++) {
            matrix[i][j] = 0;
        }
    }
    
    file.open(argv[1]);
    
    while(!file.eof()) {
        getline(file, str);
        //cout << str << endl;
        
        tokenize(str, tokens, "|");
        
        int i, j, modif;
        if(tokens[4] != "sp" && tokens[4] != "gb*") {
            /*cout << tokens[0] << " ";
            cout << tokens[1] << " ";
            cout << tokens[2] << " ";
            cout << tokens[3] << " ";            
            cout << tokens[4] << " ";
            cout << tokens[5] << " ";    
            cout << "*" << endl;*/
            i = atoi(tokens[8].c_str()) - 1;
            switch(tokens[0].c_str()[0]) {
                case 'a': modif = -1; break;
                case 'g': modif = 12; break;
                case 'h': modif = 18; break;
                case 'p': modif = 29; break;
                case 'u': modif = 36; break;
            }
            j = modif + atoi(tokens[1].c_str());
            //cout << "TK8 " << tokens[8] << endl;
            if(matrix[i][j] == 0) { //pode ser tirado esse if caso queira informacoes sobre as isoformas
                matrix[i][j] += 1;
            }
            //cout << "MAT[" << i << "][" << j << "]" << " = " << matrix[i][j] << endl;
        } else {
            /*cout << tokens[0] << " ";
            cout << tokens[1] << " ";
            cout << tokens[2] << " ";
            cout << tokens[3] << " ";            
            cout << tokens[4] << " ";
            cout << tokens[5] << " ";    
            cout << tokens[6] << endl; */
            i = atoi(tokens[9].c_str()) - 1;
            switch(tokens[0].c_str()[0]) {
                case 'a': modif = -1; break;
                case 'g': modif = 12; break;
                case 'h': modif = 18; break;
                case 'p': modif = 29; break;
                case 'u': modif = 36; break;
            }
            j = modif + atoi(tokens[1].c_str());
            //cout << "TK9 " << tokens[9] << endl;
            if(matrix[i][j] == 0) { //pode ser tirado esse if caso queira informacoes sobre as isoformas
                matrix[i][j] += 1;
            }
            //cout << "MAT[" << i << "][" << j << "]" << " = " << matrix[i][j] << endl;
        }
        
        while(!tokens.empty()) {
            tokens.pop_back();
        }
    }
    
    for( int i = 0; i < 382; i++) {
           for( int j = 0; j < 12; j++) {
               cout << matrix[i][j] << "\t";
           }
           cout << endl;
    }
    
    cout << endl << endl;
    
    for( int i = 0; i < 382; i++) {
           for( int j = 13; j < 18; j++) {
               cout << matrix[i][j] << "\t";
           }
           cout << endl;
    }

    cout << endl << endl;
    
    for( int i = 0; i < 382; i++) {
           for( int j = 19; j < 29; j++) {
               cout << matrix[i][j] << "\t";
           }
           cout << endl;
    }

    cout << endl << endl;
    
    for( int i = 0; i < 382; i++) {
           for( int j = 30; j < 36; j++) {
               cout << matrix[i][j] << "\t";
           }
           cout << endl;
    }

    cout << endl << endl;
    
    for( int i = 0; i < 382; i++) {
           for( int j = 37; j < 44; j++) {
               cout << matrix[i][j] << "\t";
           }
           cout << endl;
    }

    return 0;
}
























