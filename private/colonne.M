
#import "colonne.h"

@implementation colonne
- acceptParameters:sender
{    


	[self setParameters];
	return self;
}

- init
{       [super init];
	nb_fonc = 16;
	
    	y = (float *)calloc(nb_fonc, sizeof(float));
	yout = (float *)calloc(nb_fonc, sizeof(float));
	dydx = (float *)calloc(nb_fonc, sizeof(float));
	P = (COLONNE_PARAM *)malloc(1 * sizeof(COLONNE_PARAM));
	P->a = 100.; // 250 FW
	P->b = 30.; // 100
	P->g = 6.;
	P->GaussianSigma = 2;
	P->v0 = 6;
	P->e0 = 2.5;
        P->r = 0.56; //0.56

        P->inputNoise = NULL;
        P->occurenceTimeInt = NULL;

        P->noise = (float *)calloc(8192*4, sizeof(float));

	return self;
}

-(int*)APVolleysOcurrenceTimes
{
    return  P->occurenceTimeInt;
}

-(int)inputNoiseNbEch
{
    return  P->nbEch;
}
//----------------------------------------------------------------

- (void)recopyAPVolleysOcurrenceTimes:(int*)ot :(int)nbEch
{   int NbOfAp;
    int i,k,j,a;
    j=0;
    NbOfAp=0;
    for (a=0;a<nbEch-512;a++)
    {
	if (ot[a]==1 && ot[a+1]!=1)
		NbOfAp+=1;
    }
    NbOfAp=(int)GaussianNumber(NbOfAp,2) % (int)(NbOfAp)+1;
    if (P->occurenceTimeInt) free(P->occurenceTimeInt);
    P->occurenceTimeInt = (int*)calloc(nbEch, sizeof(int));

    for(i=0;i<nbEch-512 ;i++)
      {
    if(ot[i]==1 && j<=NbOfAp)
          {
            //k = i + (int)(P->timeShift) + (int)(normalizedRandom() * P->timeShiftRand);
            k = i + (int)(P->timeShift) + (int)(GaussianNumber(0, P->timeShiftRand));



            P->occurenceTimeInt[k] = 1;
            if (ot[i+1]!=1) 
	       j+=1;
           // printf("%s:recopyOcurrenceTimes:%d\n", [self getName], j);

          }
	
      }
}

//----------------------------------------------------------------
- (void)setAPVolleysOcurrenceTimes:(int)nbOfEvents :(int)m :(float)fEch
{
    int i, aTag;
    float dt;
    float t = 0.;
    float rate, interIES;
    float StartInt, EndInt;
    //float *occurenceTime;

    interIES = [interIESTxtField floatValue];

    
//FILE *fp;
//fp = (FILE*)fopen("c:\\tmp\\poisson.txt","wt");
    
    //printf("%s: setAPVolleysOcurrenceTimes\n",[self getName]);
    //printf("alloc P->occurenceTimeInt\n");

    if (P->occurenceTimeInt) free(P->occurenceTimeInt);
    P->occurenceTimeInt = (int*)calloc(m, sizeof(int));

    rate = 2.*(float)(nbOfEvents)/((float)m/fEch);
    
    //occurenceTime = (float*)calloc(nbOfEvents, sizeof(float));
    StartInt=([StartIntTxtField floatValue]+2)*fEch;
    EndInt=([EndIntTxtField floatValue]+2)*fEch;

    aTag = [occurTimeSwitch selectedRow];
    if (aTag==2 && [RandAPNumberCheck intValue])
            {
    nbOfEvents=(int)GaussianNumber(nbOfEvents,2) % (int)(nbOfEvents)+1;
            }
    for(i=0;i<nbOfEvents ;i++)
      {
	  if (aTag==0)
          {
            dt = nextTime(rate); // POISSON PROCESS
          }
        else
        	if (aTag==1)

         	 {
			dt = (float)m/(nbOfEvents+1)/fEch; //EQUIDISTANT EVENTS
         	 }
		else
		 {
                dt=((int)GaussianNumber((EndInt+StartInt)/2,P->GaussianSigma*fEch)%(int)(EndInt-StartInt+1)+(int)StartInt)/fEch ;
                //dt=(int)((EndInt+StartInt)/2/fEch);
                printf(" dt=%f\n", dt);


		 }

        if(![IESCanOverlapSwitch intValue])
            while (dt<1.0)
              {
                //printf("av:t=%f, dt=%f\n", t, dt);
                dt = nextTime(rate);
              }
	if (aTag!=2)               
		t = t + dt;		
	else
		t=dt;
        //printf("t=%f [%d <--> %d]\n",t,(int)(t*fEch),m);
       //fprintf(fp, "%.1f\t%.0f\t1\n",t,t*fEch);
        if(t*fEch<m)
          {
            //occurenceTime[i] = t;
            P->occurenceTimeInt[(int)(t*fEch)] = 1;
           // printf("dt=%f, ot=%f\n",dt,t);
          }
        else
          {
            P->occurenceTimeInt[m-512] = 1;
            printf("t>nbEch\n");
          }
      }
    //free(occurenceTime);
    
//fclose(fp);

}


//----------------------------------------------------------------

- (void)setNoiseWithNbEch:(int)m :(float)fEch
{
    int i,j,volleyAPDuration;
    float volleyAPGain;

    volleyAPDuration = P->volleyAPDuration;
    volleyAPGain = P->volleyAPGain;
    P->nbEch = m;
    if (P->inputNoise) free(P->inputNoise);
    P->inputNoise = (float*)calloc(m, sizeof(float));
    for(i=0;i<m;i++)
      {
        P->inputNoise[i]=p(P);
       //P->inputNoise[i]=P->noise[i];
        if (P->occurenceTimeInt[i])
          {
            volleyAPGain = randomize(P->volleyAPGain, P->volleyAPGainRand);
            for(j=0;j< volleyAPDuration;j++)
              {
                P->inputNoise[i+j]= volleyAPGain;
              }
            i = i+ volleyAPDuration;
           //printf("fin toto\n");
          }
      }

    //printf("fin setNoiseWithNbEch\n");

}


//----------------------------------------------------------------
- showParameters:(float)xx :(float)yy
{
	[parametersWindow makeKeyAndOrderFront:self];
	[parametersWindow setFrameOrigin:NSMakePoint(xx, yy)];
	[self setParameters];

	return self;
}

- setParameters
{
    P->A = [self A]; P->B = [self B];
    P->ARand = [self ARand]; P->BRand = [self BRand];

    P->G = [self G];P->C = [self C];P->J = [self J];
    P->C1 = [self C1]; P->C2 = [self C2]; P->C3 = [self C3]; P->C4 = [self C4];P->C5 = [self C5];P->C6 = [self C6];P->C7 = [self C7];P->C8 = [self C8];P->C9 = [self C9];

    P->g = [self g];
    P->a = [self a];
    P->b = [self b];
    P->j1 = [self j1];
    P->j2 = [self j2];

    P->ad = [self ad];

    P->moyP = [self moyP];
    P->sigmaP = [self sigmaP];
    P->coefMultP = [self coefMultP];

    P->timeShift = [self timeShift];
    P->timeShiftRand = [self timeShiftRand];
    P->volleyAPDuration = [self volleyAPDuration];
    P->volleyAPGain = [self volleyAPGain];
    P->volleyAPGainRand = [self volleyAPGainRand];
    P->GaussianSigma = [self GaussianSigma];

    return self;
}
//----------------------------------------------------------------
- showTabK
{	
	int i;

	for(i=0;i<nbOfAfferentCols;i++)
		printf("%f\n",P->K[i]);

	return self;
}

//----------------------------------------------------------------
- setWindowTitle:(const char *)aName
{
	colName = (char *)malloc(strlen(aName)+1);
	strcpy(colName, aName);

	[parametersWindow setTitle:[NSString stringWithCString:colName]];

	return self;
}

- (char *) getName
{
	return colName;
}

//----------------------------------------------------------------
- (float)A { return [ATxtField floatValue]; }
- (float)ARand { return [ARandTxtField floatValue]; }
- (float)B { return [BTxtField floatValue]; }
- (float)BRand { return [BRandTxtField floatValue]; }
- (float)G { return [GTxtField floatValue]; }
- (float)J { return [JTxtField floatValue]; }
- (float)g { return [gTxtField floatValue]; }
- (float)a { return [aTxtField floatValue]; }
- (float)b { return [bTxtField floatValue]; }
- (float)j1 { return [j1TxtField floatValue]; }
- (float)j2 { return [j2TxtField floatValue]; }

- (float)C { return [CTxtField floatValue]; }
- (float)C1 { return [C1TxtField floatValue] * [CTxtField floatValue]; }
- (float)C2 { return [C2TxtField floatValue] * [CTxtField floatValue]; }
- (float)C3 { return [C3TxtField floatValue] * [CTxtField floatValue]; }
- (float)C4 { return [C4TxtField floatValue] * [CTxtField floatValue]; }
- (float)C5 { return [C5TxtField floatValue] * [CTxtField floatValue]; }
- (float)C6 { return [C6TxtField floatValue] * [CTxtField floatValue]; }
- (float)C7 { return [C7TxtField floatValue] * [CTxtField floatValue]; }
- (float)C8 { return [C8TxtField floatValue] * [CTxtField floatValue]; }
- (float)C9 { return [C9TxtField floatValue] * [CTxtField floatValue]; }

//----------------------------------------------------------------
- (float)ad { return [adTxtField floatValue]; }
//----------------------------------------------------------------
- (float)moyP { return [moyPTxtField floatValue]; }
- (float)sigmaP { return [sigmaPTxtField floatValue]; }
- (float)coefMultP { return [coefMultPTxtField floatValue]; }
- (float)timeShift { return [timeShiftTxtField floatValue]; }
- (float)timeShiftRand { return [timeShiftRandTxtField floatValue]; }
- (float)volleyAPGain { return [volleyAPGainTxtField floatValue]; }
- (float)volleyAPGainRand { return [volleyAPGainRandTxtField floatValue]; }
- (int)volleyAPDuration { return [volleyAPDurationTxtField intValue]; }
- (float)GaussianSigma { return [GaussianSigmaTxtField floatValue]; }
- (float)StartInt { return [StartIntTxtField floatValue]; }
- (float)EndInt { return [EndIntTxtField floatValue]; }



//----------------------------------------------------------------
//----------------------------------------------------------------
- setA:(float)x {[ATxtField setFloatValue:x]; return self;}
- setARand:(float)x {[ARandTxtField setFloatValue:x]; return self;}
- setB:(float)x {[BTxtField setFloatValue:x]; return self;}
- setBRand:(float)x {[BRandTxtField setFloatValue:x]; return self;}
- setG:(float)x {[GTxtField setFloatValue:x]; return self;}
- setJ:(float)x {[JTxtField setFloatValue:x]; return self;}
- setg:(float)x {[gTxtField setFloatValue:x]; return self;}
- seta:(float)x {[aTxtField setFloatValue:x]; return self;}
- setb:(float)x {[bTxtField setFloatValue:x]; return self;}
- setj1:(float)x {[j1TxtField setFloatValue:x]; return self;}
- setj2:(float)x {[j2TxtField setFloatValue:x]; return self;}

- setC:(float)x {[CTxtField setFloatValue:x]; return self;}
- setC1:(float)x {[C1TxtField setFloatValue:x]; return self;}
- setC2:(float)x {[C2TxtField setFloatValue:x]; return self;}
- setC3:(float)x {[C3TxtField setFloatValue:x]; return self;}
- setC4:(float)x {[C4TxtField setFloatValue:x]; return self;}
- setC5:(float)x {[C5TxtField setFloatValue:x]; return self;}
- setC6:(float)x {[C6TxtField setFloatValue:x]; return self;}
- setC7:(float)x {[C7TxtField setFloatValue:x]; return self;}
- setC8:(float)x {[C8TxtField setFloatValue:x]; return self;}
- setC9:(float)x {[C9TxtField setFloatValue:x]; return self;}

//----------------------------------------------------------------
- setAd:(float)x {[adTxtField setFloatValue:x]; return self;}
//----------------------------------------------------------------
- setMoyP:(float)x {[moyPTxtField setFloatValue:x]; return self;}
- setSigmaP:(float)x {[sigmaPTxtField setFloatValue:x]; return self;}
- setCoefMultP:(float)x {[coefMultPTxtField setFloatValue:x]; return self;}
- setTimeShift:(float)x {[timeShiftTxtField setFloatValue:x]; return self;}
- setTimeShiftRand:(float)x {[timeShiftRandTxtField setFloatValue:x]; return self;}
- setVolleyAPGain:(float)x {[volleyAPGainTxtField setFloatValue:x]; return self;}
- setVolleyAPGainRand:(float)x {[volleyAPGainRandTxtField setFloatValue:x]; return self;}
- setGaussianSigma:(float)x {[GaussianSigmaTxtField setFloatValue:x]; return self;}
- setVolleyAPDuration:(int)x {[volleyAPDurationTxtField setIntValue:x]; return self;}
- setStartInt:(float)x {[StartIntTxtField setFloatValue:x]; return self;}
- setEndInt:(float)x {[EndIntTxtField setFloatValue:x]; return self;}

- (id)getOccurTimeSwitch
{
    return occurTimeSwitch;
}

- (id)getIESCanOverlapSwitch
{
    return IESCanOverlapSwitch;
}
- (id)getRandAPNumberCheck
{
return RandAPNumberCheck;
}

//----------------------------------------------------------------

- setTabK:(float *)tab
{
	int i;

	for(i=0;i<nbOfAfferentCols;i++)
		P->K[i] = tab[i];

	return self;
}

- setTabInputs:(float *)tab
{
	int i;

	for(i=0;i<nbOfAfferentCols;i++)
		P->inCol[i] = tab[i];

	return self;
}
//----------------------------------------------------------------
- (float) pulseOutput
{
	return y[10];
}
//----------------------------------------------------------------
- (float) EEGoutput
{	float C1,C2,C4,C6,C8;
	int s = 1;
	if ([opposSwitch intValue]) s = -1;
	C1=P->C1;
        C2=P->C2;
        C4=P->C4;
        C6=P->C6;
	C8=P->C8;

        return s * (C8*y[2]-C2*y[4]-C4*y[8]+C6*y[12]);
        //return C6*y[12];
}
//----------------------------------------------------------------
- integre:(float)t :(float)dt
{
	rk4(y,dydx,nb_fonc,t,dt,yout,derivs,P);
	return self;
}
//----------------------------------------------------------------
- updateStateVector
{
    int i;

    for(i=0;i<nb_fonc;i++)
      {
        y[i] = yout[i];
      }
    return self;
}

//----------------------------------------------------------------
- setNbOfAfferentCols:(int)n
{
	nbOfAfferentCols = n;

	P->n = n;
	P->K = (float*) calloc(n, sizeof(float));
	P->inCol = (float*) calloc(n, sizeof(float));
	return self;
}

//----------------------------------------------------------------
- (void)reset
{
	int i;

	for(i=0;i<nb_fonc;i++)
	{
		y[i] = 0.;
		yout[i] = 0.;
		dydx[i] = 0.;
	}

	for(i=0;i<nbOfAfferentCols;i++)
	{
		P->K[i] = 0.;
		P->inCol[i] = 0.;
	}
}

- (id) parametersWindow
{
	return parametersWindow;
}


//----------------------------------------------------------------
- (void)dealloc
{	
	free(y);
	free(yout);
	free(dydx);
	free(P);
	free(colName);
	[super dealloc];
}

@end
