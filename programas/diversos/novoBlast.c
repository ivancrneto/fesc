#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int diff(char *p1, char *p2);

int main(){
  char *pal1, *pal2;

  for(;;){
    scanf("%as", &pal1);
    if(strcmp(pal1, "0") == 0){
      free(pal1);
      break;
    }
    scanf("%as", &pal2);

    printf("%d\n", diff(pal1,pal2));

    free(pal1);
    free(pal2);
  }
}

int diff(char *p1, char *p2){
  int table[2][strlen(p1)+1];
  int i,j;
  int len1, len2;

  len1 = strlen(p1);
  len2 = strlen(p2);
  
  for(i=0;i<=len1;i++){
    table[0][i] = -2*i;
  }

  for(j=1;j<=len2;j++){
    table[j%2][0] = -2*j;
    for(i=1;i<=len1;i++){
      double valul, valu, vall;
      double max;

      valu = table[(j+1)%2][i] - 0.5;//valu = table[(j+1)%2][i] - 2;
      vall = table[j%2][i-1] - 0.5;//vall = table[j%2][i-1] - 2;
      if(p1[i-1] == p2[j-1]){
	valul = table[(j+1)%2][i-1] + 1;
      }
      else{
	valul = table[(j+1)%2][i-1];// - 1;
      }

      max = valul;
      if(valu > max)
	max = valu;
      if(vall > max)
	max = vall;

      table[j%2][i] = max;      
    }
  }
  
  double percent = 0.0;
  if(len1 > len2) {
    percent = (double) table[len2%2][len1] / (double) len1;
  } else {
    percent = (double) table[len2%2][len1] / (double) len2;
  }
  
  return percent >= 0.0 ? percent * 100 : 0.0;
}

