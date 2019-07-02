#include <stdio.h>

extern void sen(float*,float*,float,float);
//retorna o sen, quantidade de interações, e eu passo angulo e a diferença máxima
int main(void){
	float angulo, maxDiference, seno, contaInteracao;
	printf("por favor digite o valor do angulo para ser calculado\n");
	scanf("%f", &angulo);
	printf("por favor digite o valor da diferença máxima\n");
	scanf("%f",&maxDiference);
	sen(seno, contaInteracao, angulo,maxDiference);
	printf("valor do seno = %f\n",seno);
	printf("numero de interações = %f\n",contaInteracao);
}
