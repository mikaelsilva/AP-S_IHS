#include <stdio.h>

extern void sen(float*, float*, float, float);

int main(){
	float angulo, diferenca, resultado, numInter;
	printf("Integração c-assmbly");
	scanf("%f %f", &angulo,&diferenca);
	fflush(stdin);

	sen(&resultado, &numInter, angulo, diferenca);
	printf("o valor do seno é: %f\n",resultado );
	printf("em %f passos\n",numInter);
} 
