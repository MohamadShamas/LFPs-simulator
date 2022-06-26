#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include "fonctionsC.h"

//----------------------------------------------------------------------

float GaussianNumber(float m, float sigma)
{     float gauss, alea1, alea2;
      alea1 = (float)rand()/(float)(RAND_MAX+1);
      alea2 = (float)rand()/(float)RAND_MAX;
      gauss = sigma * sqrt(-2.0*log(1.0-alea1)) * cos(2.0*M_PI*alea2)+m;

      return(gauss);
}            


float normalizedRandom()
{
    float alea;

    alea = ((float)rand() / (RAND_MAX + 1) );
    return (alea);
}


float randomize(float parameter, float rate)
{
    float alea;

    alea = ((float)rand() / (RAND_MAX + 1) - 0.5) * 2.;
    //alea = ((float)rand() / (RAND_MAX + 1) ) ;
    return (parameter + parameter * alea * rate);
}

//-----------------------------------------------------------------------
float nextTime(float rateParameter)
{
   return -log(1.0f - (float) rand() / (RAND_MAX + 1)) / rateParameter;
}


//-----------------------------------------------------------------------
void saveAsBin(char *fileName, float **data, int nbC, int nbL)
{
   int j;
   FILE *fpBin;

   fpBin = (FILE*)fopen(fileName,"wb");

   for(j=0;j<nbC;j++){
       fwrite(data[j], sizeof(float), nbL, fpBin);
   }

   fclose(fpBin);
}

//-----------------------------------------------------------------------
void saveAsBinMux(char *fileName, float **data, int nbC, int nbL)
{
  int i,j;
  FILE *fpBin;
  float x;

  fpBin = (FILE*)fopen(fileName,"wb");

  for(i=0;i<nbL;i++)
      for(j=0;j<nbC;j++){
          x = data[j][i];
          fwrite(&x, sizeof(float), 1, fpBin);
      }

  fclose(fpBin);
}

//------------------------------------------------------------------
float * vector(int n)
{
	float *v;
	v = (float*) malloc(n * sizeof(float) );
	return v;
}
//------------------------------------------------------------------
void free_vector(float *v)
{
	free (v);
}
//------------------------------------------------------------------
float sigm(float v, COLONNE_PARAM *P)
{
	float e0, v0, r;

	v0 = P->v0; e0 = P->e0; r = P->r;

        return 2*e0/(1+exp(r*(v0-v))) ;
}
//------------------------------------------------------------------
float p(COLONNE_PARAM *P)
{
	float x, coefMultP, moyP, sigmaP;

	moyP = P->moyP; sigmaP = P->sigmaP;coefMultP = P->coefMultP; 

        //x = coefMultP * (sqrt(12. * sigmaP) * ((double)rand() / (double)RAND_MAX - 0.5) + moyP); //UNIFORM normalized noise
        x = coefMultP * bruitGaussien(sigmaP,moyP);

	return x;
}
//----------------------------------------------------------------------
float bruitGaussien(float sigma,float m)
{
       float gauss, alea1, alea2;
       
       alea1 = (float)rand()/(float)(RAND_MAX+1);
       alea2 = (float)rand()/(float)RAND_MAX;
       gauss = sigma * sqrt(-2.0*log(1.0-alea1)) * cos(2.0*M_PI*alea2)+m;

       return(gauss);
}

//----------------------------------------------------------------------
float PSP(float *y,float Finput,int input,int param, COLONNE_PARAM *P,float bruit,int yes)
{	
	float A, a;

	if (param==1)
	{
	A = P->A;
	a = P->a;
	}
        if (param==2)
	{
        A = P->B;
        a = P->b;
        }
	if (param==3)
	{
         A = P->G;
         a = P->g;
        }

        if (param==4)
        {
         A = P->J;
         a = P->j1;
        }

	//switch (input)
	//{
	//case 1:
	//	C = P->C1
	//case 2:
	//	C = P->C2
        //case 3:
        //       C = P->C1
        //case 4:
        //        C = P->C2
        //case 5:
        //        C = P->C1
        //case 6:
        //       C = P->C2
        //case 7:
        //        C = P->C1
	//}
return A * a * (sigm(Finput,P)+yes*bruit) - 2 * a * y[input+1] - a*a * y[input];
    
}           
//------------------------------------------------------------------
void derivs(float t, float *y, float *dydx, COLONNE_PARAM *P, float bruit)
{
	int i;
	float A, B, G, C, C1, C2, C3, C4, C5, C6, C7, C8,C9 , a, b, g, ad, J, j1,j2,trise,gainFactor;
	float sumOfAfferences = 0.;
	A = P->A; B = P->B; G = P->G; C = P->C; J=P->J; j1=P->j1;j2=P->j2;
        C1 = P->C1; C2 = P->C2; C3 = P->C3; C4 = P->C4;C5 = P->C5;C6 = P->C6;C7 = P->C7;C8 = P->C8;C9 = P->C9;
	a = P->a; b = P->b;g = P->g;
	ad = P->ad;

        //***************************************************************************************************
        trise = log(j1/j2)/(j1-j2);
        gainFactor = exp(j2*trise);  // equivalent a gainFactor = pow(v1/v2,v2/(v1-v2)) ;
        //***************************************************************************************************


        if (P->n > 0){
            for(i=0;i<P->n;i++) sumOfAfferences += (P->K[i] * P->inCol[i]); //sumOfAfferences /= P->n;
        }

	dydx[0] = y[1];

        //dydx[1] =A * a * sigm(y[2]-C2*y[4]-C4*y[8]+C6*y[12],P) - 2 * a * y[1] - a*a * y[0];
        dydx[1] = PSP(y,C8*y[2]-C2*y[4]-C4*y[8]+C6*y[12],0,1,P,bruit,0);

	dydx[2] = y[3];

        //dydx[3] = PSP(y,C1*y[0],2,1,P,bruit,1);
        dydx[3] =  A * a * (sigm(C1*y[0],P)+bruit) - 2 * a * y[3] - a*a * y[2];
        //dydx[3] =  A * a * (bruit) - 2 * a * y[3] - a*a * y[2];

        dydx[4] = y[5];

        //dydx[5] = B * b * (sigm(C3*y[6],P)) - 2 * b * y[5] - b*b * y[4];
        dydx[5] = PSP(y,C3*y[6],4,2,P,bruit,1);

	dydx[6] = y[7];

        //dydx[7] =  A * a * sigm(y[2]-C2*y[4]-C4*y[8]+C6*y[12],P) - 2 * a * y[7] - a*a * y[6];
        dydx[7] = PSP(y,C8*y[2]-C2*y[4]-C4*y[8]+C6*y[12],6,1,P,bruit,0);

        dydx[8] = y[9];

        //dydx[9] =  G * g * (sigm(C5*y[10],P)) - 2 * g * y[9] - g*g * y[8];
        //dydx[9] = PSP(y,C5*y[10]-C9*y[4],8,3,P,bruit,1);
        //dydx[9] = PSP(y,0,8,3,P,bruit,1);
        dydx[9] = G*j2*gainFactor* (sigm(C5*y[10]-C9*y[4],P)+bruit) - (j1+j2)* y[9] - j1*j2* y[8];

        dydx[10] = y[11];

        //dydx[11] =  A * a * sigm(y[2]-C2*y[4]-C4*y[8]+C6*y[12],P) - 2 * a * y[11] - a*a * y[10];
        dydx[11] = PSP(y,C8*y[2]-C2*y[4]-C4*y[8]+C6*y[12],10,1,P,bruit,0);

        dydx[12] = y[13];
        //dydx[13] = PSP(y,C7*y[14],12,4,P,bruit,1);
        // dydx[13] =  J * j1 * (sigm(C7*y[14],P)+bruit) - 2 * j1 * y[13] - j1*j1 * y[12];
       
        dydx[13] = J*j2*gainFactor* (sigm(C7*y[14],P)+bruit) - (j1+j2)* y[13] - j1*j2* y[12];
        //dydx[13] = J*j2*gainFactor* (bruit) - (j1+j2)* y[13] - j1*j2* y[12];

        dydx[14] = y[15];
        //dydx[15] =  A * a * sigm(y[2]-C2*y[4]-C4*y[8]+C6*y[12],P) - 2 * a * y[15] - a*a * y[14];
        dydx[15] = PSP(y,C8*y[2]-C2*y[4]-C4*y[8]+C6*y[12],14,1,P,bruit,0);




}
//------------------------------------------------------------------
void rk4(float *y, float *dydx, int n, float x, float h, float *yout, void aDerivFunction(float, float *, float *, COLONNE_PARAM *, float), COLONNE_PARAM *P )
{
        int i;
        float xh,hh,h6,*dym,*dyt,*yt;
        float bruit;

        float *vector(int n);
        void free_vector(float *v);

        bruit = p(P); //p(t) est le bruit d'entree dans le modele

	/*if ((( ((x/3.) - (int)x/3)) * 3 ) == 0)
          { bruit = p(P) + 5500;}*/

        bruit = P->inputNoise[(int)x];

        if (P->occurenceTimeInt[(int)x])
          {
            P->A = randomize(P->A, P->ARand);
            P->B = randomize(P->B, P->BRand);

            //printf("%.3f %f %f\n", x, P->A, P->B);
          }


        aDerivFunction(x,y,dydx,P,bruit); //1

        dym=vector(n);
        dyt=vector(n);
        yt=vector(n);

        hh=h*0.5;
        h6=h/6.0;
        xh=x+hh;

        for (i=0;i<n;i++) yt[i]=y[i]+hh*dydx[i];

        aDerivFunction(xh,yt,dyt,P,bruit); //2

        for (i=0;i<n;i++) yt[i]=y[i]+hh*dyt[i];

        aDerivFunction(xh,yt,dym,P,bruit); //3

        for (i=0;i<n;i++)
        {
                yt[i]=y[i]+h*dym[i];
                dym[i] += dyt[i];
        }

        aDerivFunction(x+h,yt,dyt,P,bruit); //4

        for (i=0;i<n;i++)
            yout[i]=y[i]+h6*(dydx[i]+dyt[i]+2.0*dym[i]);

        free_vector(yt);
        free_vector(dyt);
        free_vector(dym);
}
//------------------------------------------------------------------
void centre_signal(float *s,int Nbp)
 {
   float Moy=0.0;
   int i;

   for(i=0; i < Nbp; i++)
       Moy += s[i];

   Moy /= Nbp;

   for(i=0; i < Nbp; i++)
       s[i] = s[i]-Moy;
 }

//------------------------------------------------------------------
/*    
 *
 *     Programme de FFT 1D
 *     flottant float precision
 *
 */

/*

FFT1D(zr,zi,n,sign)


Programme de FFT 1D en flottant float precision

PARAMETRES D'ENTREE

zr[] : tableau de la partie reelle du signal a transformer
zi[] : tableau de la partie imaginaire du signal a transformer
n    : dimension des tableaux d'entree = 2 a la puissance m
sign : si sign = -1 -> FFT directe
       si sign = 1  -> FFT inverse
          
PARAMETRES DE SORTIE

zr[] : tableau de la partie reelle du signal transforme
zi[] : tableau de la partie imaginaire du signal transforme

*/
 
#include<math.h>
#include<stdio.h>

void FFT1D(float *zr,float *zi,short n,short sign)
{
 short i,j;
 short ip;
 short k,l;
 short m;        /* puiss de 2 */  
 short le,le1;
 short mm1,nm1,nv2;
 
 float u,ui;
 float w,wi;
 float t,ti;
 float r,ri;

 /* dimension des tableaux */
 m=log(n)/log(2);
 
 /* test du signe de la FFT */
 if(sign!=1 && sign!=-1)
  {
   printf("\n    ERREUR DANS L'APPEL DE LA FONCTION FFT1D \n");
   printf("    sign DOIT ETRE EGAL A +1 OU -1 \n");
  }
 else
  {
   
   /* calcul de la FFT */
   mm1=m-1;
   for(l=1;l<=mm1;l++)
    {  
     le=(short)(pow(2.,(float)(m+1-l)));
     le1=(float)(le)/2.;
     u=w=cos((float)(sign)*M_PI/(float)(le1));
     ui=wi=sin((float)(sign)*M_PI/(float)(le1));
     for(i=1;i<=n;i+=le)
      {
       ip=i+le1;
       t=zr[i-1]+zr[ip-1]; ti=zi[i-1]+zi[ip-1];
       zr[ip-1]=zr[i-1]-zr[ip-1]; zi[ip-1]=zi[i-1]-zi[ip-1];
       zr[i-1]=t; zi[i-1]=ti;
      }
     for(j=2;j<=le1;j++)
      {
       for(i=j;i<=n;i+=le)
        {
         ip=i+le1;
         t=zr[i-1]+zr[ip-1]; ti=zi[i-1]+zi[ip-1];
         r=((zr[i-1]-zr[ip-1])*u)-((zi[i-1]-zi[ip-1])*ui);
         ri=((zr[i-1]-zr[ip-1])*ui)+((zi[i-1]-zi[ip-1])*u);
         zr[ip-1]=r; zi[ip-1]=ri;
         zr[i-1]=t; zi[i-1]=ti;
        }
       t=u*w-ui*wi;
       ti=ui*w+wi*u;
       u=t; ui=ti;
      }
    }
   for(i=1;i<=n;i+=2)
    {
     ip=i+1;
     t=zr[i-1]+zr[ip-1]; ti=zi[i-1]+zi[ip-1];
     zr[ip-1]=zr[i-1]-zr[ip-1]; zi[ip-1]=zi[i-1]-zi[ip-1];
     zr[i-1]=t; zi[i-1]=ti;
    }
   nv2=(float)(n)/2.;
   nm1=n-1;
   j=1;
   for(i=1;i<=nm1;i++)
    {
     if(i<j)
      {
       t=zr[j-1]; ti=zi[j-1];
       zr[j-1]=zr[i-1]; zi[j-1]=zi[i-1];
       zr[i-1]=t; zi[i-1]=ti;
      }
     k=nv2;
     while(k<j)
      {
       j=j-k;
       k=(float)(k)/2.;
      }
     j=j+k;
    }
   
   /* si FFT inverse normalisation par 1/2 puissance m */
    if(sign==1)
     {
      for(i=0;i<n;i++)
       {
        zr[i]/=(float)(n);
        zi[i]/=(float)(n);
       }
     }
  }
}

