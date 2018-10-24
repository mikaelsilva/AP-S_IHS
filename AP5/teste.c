#include <stdio.h>

extern void sen(float*, float*, float, float);

int main(){
	float angulo, diferenca, resultado, numInter;
	fflush(stdin);
	printf("Integração c-assmbly");
	scanf(" %f\n ", &angulo);
	scanf(" %f\n ", &diferenca);
	fflush(stdin);

	cone(&resultado, &numInter, angulo, diferenca);
	printf("o valor do seno é: %f\n",resultado );
	printf("em %f passos\n",numInter);
} 
