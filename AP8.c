#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>
//gcc -fopenmp AP8.c -o AP8
#define N 100000000

int main (void){
	int i;
	int x,y;
	float x2;
	float y2;
	float resultado=0;

	#pragma omp parallel for private(i) reduction(+:resultado)
	for(i=1;i<10000;i++){
	  x=rand() % (N +1);
	  x2=((float)x)/N;
	  y=rand()% (N +1);
	  y2=((float)y)/N;
	  printf ("[%f] and [%f]\n",x2,y2);
	  if((x2*x2 + y2*y2) <= 1 ){
          resultado++;
	  }	
	}
	resultado=(resultado*4)/10000;	
	printf ("[%f]\n",resultado);
	return 0;
}
