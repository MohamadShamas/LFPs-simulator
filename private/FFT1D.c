

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

void FFT1D(zr,zi,n,sign)
float *zr;
float *zi;
short n;		/* dimension du tableau */
short sign;
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

