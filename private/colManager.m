#import "colManager.h"
#import "colonne.h"
#import "XYPlotView.h"
#import <Foundation/Foundation.h>

#define DEFAULT_COUPLING 0.
#define TAG_VALUE 10000
#define nbOfAct 7

@implementation colManager

+ (void)initialize
{   
    printf("colManager: init\n");
    [super initialize];

    return;
}

-(void)recopyMasterPop:(id)sender
{
    int i, fromPop, toPop, masterPop, nbOfPop, j, k;
	
    nbOfPop = [colList count];


    fromPop = [fromPopTxtField intValue];
    if(fromPop<=0)
      {
        fromPop=0;
        [fromPopTxtField setIntValue:fromPop];
      }
    if(fromPop>=nbOfPop)
      {
        fromPop=nbOfPop-1;
        [fromPopTxtField setIntValue:fromPop];
      }

    toPop = [toPopTxtField intValue];
    if(toPop<=0)
      {
        toPop=0;
        [toPopTxtField setIntValue:toPop];
      }
    if(toPop>=nbOfPop)
      {
        toPop=nbOfPop-1;
        [toPopTxtField setIntValue:toPop];
      }

    masterPop = [masterPopTxtField intValue];
    if(masterPop<=0)
      {
        masterPop=0;
        [masterPopTxtField setIntValue:masterPop];
      }
    if(masterPop>=nbOfPop)
      {
        masterPop=nbOfPop-1;
        [masterPopTxtField setIntValue:masterPop];
      }

    if(fromPop <= toPop)
      {
        j = fromPop;
        k = toPop;
      }
    else
      {
        j = toPop;
        k = fromPop;
      }

    for(i=j;i<=k;i++)
      {
        [self setPop2:[colList objectAtIndex:i] toPop1:[colList objectAtIndex:masterPop]];
      }

}

-(void)setPop2:(id)pop2 toPop1:(id)pop1
{
    [pop2 setA:[pop1 A]];
    [pop2 setARand:[pop1 ARand]];
    [pop2 setB:[pop1 B]];
    [pop2 setBRand:[pop1 BRand]];
    [pop2 setG:[pop1 G]];
    [pop2 setJ:[pop1 J]];
    [pop2 setg:[pop1 g]];
    [pop2 seta:[pop1 a]];
    [pop2 setb:[pop1 b]];
    [pop2 setj1:[pop1 j1]];
    [pop2 setj2:[pop1 j2]];

    [pop2 setC:[pop1 C]];
    [pop2 setC1:[pop1 C1] / [pop1 C]];
    [pop2 setC2:[pop1 C2] / [pop1 C]];
    [pop2 setC3:[pop1 C3] / [pop1 C]];
    [pop2 setC4:[pop1 C4] / [pop1 C]];
    [pop2 setC5:[pop1 C5] / [pop1 C]];
    [pop2 setC6:[pop1 C6] / [pop1 C]];
    [pop2 setC7:[pop1 C7] / [pop1 C]];
    [pop2 setC8:[pop1 C8] / [pop1 C]];
    [pop2 setC9:[pop1 C9] / [pop1 C]];

    [pop2 setAd:[pop1 ad]];

    [pop2 setMoyP:[pop1 moyP]];
    [pop2 setSigmaP:[pop1 sigmaP]];
    [pop2 setCoefMultP:[pop1 coefMultP]];
    [pop2 setGaussianSigma:[pop1 GaussianSigma]];
    [pop2 setStartInt:[pop1 StartInt]];
    [pop2 setEndInt:[pop1 EndInt]]; 

    [pop2 setTimeShift:[pop1 timeShift]];
    [pop2 setTimeShiftRand:[pop1 timeShiftRand]]; 

    [pop2 setVolleyAPDuration:[pop1 volleyAPDuration]];
    [pop2 setVolleyAPGain:[pop1 volleyAPGain]];
    [pop2 setVolleyAPGainRand:[pop1 volleyAPGainRand]];

    [[pop2 getOccurTimeSwitch] selectCellWithTag:[[[pop1 getOccurTimeSwitch] selectedCell]tag]];
    [[pop2 getIESCanOverlapSwitch] setIntValue:[[pop1 getIESCanOverlapSwitch] intValue]];
    [[pop2 getRandAPNumberCheck] setIntValue:[[pop1 getRandAPNumberCheck] intValue]];

    [pop2 setParameters];

    //[pop2 recopyAPVolleysOcurrenceTimes:[pop1 APVolleysOcurrenceTimes] :[pop1 inputNoiseNbEch]];
}

- (void)awakeFromNib
{
    static int flag = 0;
    int i,j;

    printf("awakeFromNib:debut\n");



    if (!flag)
      {
        printf("alloc K\n");
        flag = 1;
        K = (float**)malloc(NB_MAX_OF_COLS * sizeof(float*));
        for(i=0;i<NB_MAX_OF_COLS;i++) K[i] = (float*)malloc(NB_MAX_OF_COLS * sizeof(float));

        for(i=0;i<NB_MAX_OF_COLS;i++)
            for(j=0;j<NB_MAX_OF_COLS;j++)
                if (i!=j) K[i][j] = DEFAULT_COUPLING; else K[i][j] = 0.;

      }

    //[managerWindow miniaturize:self];
    //[spectreWindow makeKeyAndOrderFront:self];
    //[signalWindow makeKeyAndOrderFront:self];
    [managerWindow makeKeyAndOrderFront:self];
    printf("awakeFromNib:fin\n");
}

- showColParameters:sender
{
    int n = [[sender selectedCell] tag];

    [[colList objectAtIndex:n] showParameters:50+10*n :50+0*n];

    return self;
}

-(void)newPopulation:(id)sender
{
    int i, nbOfPop;

    nbOfPop = [nbOfPopTxtField intValue];


    for(i=0;i<nbOfPop;i++)
      {
        [self createANewPopulation];
      }

    [toPopTxtField setIntValue:[colList count]-1];
}

- (void)createANewPopulation
{
    int i;
    id aColonne;
    char buf[64], buf1[16];

    if (!colList) colList=[[NSMutableArray alloc] init];

    aColonne = [[colonne alloc] init];
    [colList addObject:aColonne];

    sprintf(buf, "Modele a %d populations", [colList count]);
    [managerWindow setTitle:[NSString stringWithCString:buf]];

    [NSBundle loadNibNamed:@"colonne.nib" owner:[colList lastObject]];

    strcpy(buf,"POP ");
    sprintf(buf1,"%d",[colList count]-1);
    strcat(buf, buf1);
    strcat(buf, "\0");

    [[colList lastObject] setWindowTitle:buf];
    [self updateColButtonMatrix:buf :[colList count]];
    //[self updateConnexButtonMatrix];

    if (sigV)
      {
        for(i=0; i<[colList count]-1;i++) free(sigV[i]);
      }
    sigV = NULL;
    spectrum = NULL;
    tpsLabel = NULL;
    freqLabel = NULL;

    sum_sf = 0.; sum_fb = 0.; sum_eG = 0.;
}

- updateColButtonMatrix:(char *)colName :(int)colNumber
{	
    int nr, nc;

    if (colNumber > 1)	
        [colButtonMatrix addColumn];

    [colButtonMatrix getNumberOfRows:&nr columns:&nc];

    [[colButtonMatrix cellAtRow:nr-1 column:nc-1] setTitle:[NSString stringWithCString:colName]];

    [colButtonMatrix sizeToCells];
    [colButtonMatrix display];

    [[colButtonMatrix cellAtRow:nr-1 column:nc-1] setTag:nc-1];

    return self;
}

- updateConnexButtonMatrix
{	
    int i,j,nbCol;
    char buf[20];

    nbCol = [colList count];

    if (nbCol>1)
      {
        [connexButtonMatrix addRow];
        [connexButtonMatrix addColumn];

        for(i=0;i<nbCol;i++)
          {
            for(j=0;j<nbCol;j++)
              {
                sprintf(buf,"K%d_%d=%.1f",i,j,K[i][j]);
                if (j == i) [[connexButtonMatrix cellAtRow:i column:j] setEnabled:NO];
                else
                  {
                    [[connexButtonMatrix cellAtRow:i column:j] setTitle:[NSString stringWithCString:buf]];
                    [[connexButtonMatrix cellAtRow:i column:j] setTag:(i+1)*TAG_VALUE+j+1];
                  }
              }
          }
        [connexButtonMatrix sizeToCells];
        [connexButtonMatrix display];
      }
    return self;
}

- setConnexValue:sender
{
    int v,l,c;

    v = [[connexButtonMatrix selectedCell] tag];
    l = v / TAG_VALUE;
    c = v - (l*TAG_VALUE);
    l--; c--;

    printf("%d -> l:%d c:%d\n",v,l,c);

    [KValueWindow setTitle:[[connexButtonMatrix selectedCell] title]];
    [KValueTxtField setDoubleValue:K[l][c]];
    [KValueWindow makeKeyAndOrderFront:self];

    return self;
}

- setK:sender
{
    int v,l,c;
    char buf[20];

    v = [[connexButtonMatrix selectedCell] tag];
    l = v / TAG_VALUE;
    c = v - (l*TAG_VALUE);
    l--; c--;

printf("l & c: %d %d\n",l,c);

    K[l][c] = [KValueTxtField floatValue];

    sprintf(buf,"K%d_%d=%.1f",l,c,K[l][c]);
    [[connexButtonMatrix cellAtRow:l column:c] setTitle:[NSString stringWithCString:buf]];
    [KValueWindow setTitle:[NSString stringWithCString:buf]];

    if ([allLineSwitch intValue])
      {
        int i,nbCol;

        nbCol = [colList count];

        for(i=0;i<nbCol;i++)
          {
            K[l][i] = [KValueTxtField floatValue];
            if (l!=i)
              {
                sprintf(buf,"K%d_%d=%.1f",l,c,K[l][i]);
                [[connexButtonMatrix cellAtRow:l column:i] setTitle:[NSString stringWithCString:buf]];
              }

          }
      }

    return self;
}

- setRandomKValue:sender
{
   [KValueTxtField setDoubleValue:[self randomKValue]];

    [self setK:self];

    return self;
}

- (double)randomKValue
{
    double x1,x2,x;

    x1 = [minRandomKValueTxtField doubleValue];
    x2 = [maxRandomKValueTxtField doubleValue];

    x = (double)rand()/(double)RAND_MAX * (x2-x1) + x1;

    return (double)((int)(x * 10.)/10.);
}

- setAllKToConstantValue:sender
{
    int i,j,nbCol;
    char buf[20];

    nbCol = [colList count];

    for(i=0;i<nbCol;i++)
      {
        for(j=0;j<nbCol;j++)
          {
            if (i != j) {
                K[i][j] = [KValueTxtField doubleValue];
                sprintf(buf,"K%d_%d=%.1f",i,j,K[i][j]);
                [[connexButtonMatrix cellAtRow:i column:j] setTitle:[NSString stringWithCString:buf]];
            }
          }
      }
    return self;
}

- setAllKToRandomValue:sender
{
    int i,j,nbCol;
    char buf[20];

    nbCol = [colList count];

    for(i=0;i<nbCol;i++)
      {
        for(j=0;j<nbCol;j++)
          {
            if (i != j) {
                K[i][j] = [self randomKValue];
                sprintf(buf,"K%d_%d=%.1f",i,j,K[i][j]);
                [[connexButtonMatrix cellAtRow:i column:j] setTitle:[NSString stringWithCString:buf]];
            }
          }
      }
    return self;
}

- clearK:sender
{
    [KValueTxtField setDoubleValue:0.];
    [self setK:self];
    return self;
}


- incK:sender
{
    [KValueTxtField setDoubleValue:[KValueTxtField doubleValue] + [deltaKValueTxtField doubleValue]];
    [self setK:self];
    return self;
}

- decK:sender
{
    [KValueTxtField setDoubleValue:[KValueTxtField doubleValue] - [deltaKValueTxtField doubleValue]];
    [self setK:self];
    return self;
}

- (void)saveSignalsInBinFile:sender
{
    FILE *fp;
    int i;

    fp = (FILE *)fopen("C:/Documents and Settings/All Users/Application Data/Amadeus/dat/amd.des","wt");
    fprintf(fp,"[patient] SIMUL\n[date] 01/01/2000\n[time] 00:00:00\n[extractedFrom] N_A\n[samplingfreq] %f\n[nbsegments] 1\n[enabled] 1\n[nbsamples] %d\n[segmentsize] %d\n[segmentInitialTimes] 0.0\n[nbchannels] %d\n[channelnames] :\n", F_ECH, nbEch,nbEch, [colList count]);

    for (i=1;i<=[colList count];i++)
      {
        fprintf(fp,"POP%d ------\n",i);
      }

    fclose(fp);

    saveAsBinMux("C:/Documents and Settings/All Users/Application Data/Amadeus/dat/amd.bin", sigV, [colList count], nbEch);
}

- saveSignals:sender
{   
    id col,coln;
    int i,nbCol,save,k=0;
    float offset;
    float epsilon=0.0001;
    char chosenfile[255];
    char tamp[255];
    char buf[64];
    char param[255];
    char forwardDes[255];
    char forwardSig[255];

    int *unique;

    int tt = 0;
    FILE *fp;

    NSSavePanel *panneau_sauvegarde;
    col = [colList objectAtIndex:0];
    unique=(int*)calloc([colList count], sizeof(int));

    panneau_sauvegarde = [NSSavePanel savePanel];
    [panneau_sauvegarde setTitle:@"Signaux"];
    [panneau_sauvegarde setAccessoryView:accessoryView_SaveTXTPanel];
    [panneau_sauvegarde setRequiredFileType:@""];

    strcpy(tamp,[[sigNameTxtField stringValue] cString]);
    strcpy(param,[[sigNameTxtField stringValue] cString]);
    strcpy(forwardDes,[[sigNameTxtField stringValue] cString]);
    strcpy(forwardSig,[[sigNameTxtField stringValue] cString]);

    sprintf(buf,"%d",(int)[KValueTxtField doubleValue]);
    strcat(tamp,buf);
    strcat(param,buf);
    strcat(forwardDes,buf);
    strcat(forwardSig,buf);

    save = [panneau_sauvegarde runModalForDirectory:@"" file:@""];

    if (save == NSOKButton)
      {
        nbCol = [colList count];

        strcpy(chosenfile, [[panneau_sauvegarde filename] cString]);

        if ([[accViewFormatMatrix cellAtRow:0 column:0] intValue] == 1)
            strcat(chosenfile,".txt");
        else
          {
            strcpy(tamp,chosenfile);
            strcat(tamp,".des");
            //[self generateInfoFile:tamp :nbCol];
            strcpy(param,chosenfile);
            strcat(param,".Param");

            strcpy(forwardDes,chosenfile);
            strcat(forwardDes,"_Forward.des");

            strcpy(forwardSig,chosenfile);
            strcat(forwardSig,"_Forward.dat");
	    // Save simulated signals .
            fp = (FILE *)fopen(tamp,"wt");
            fprintf(fp,"[patient] SIMUL\n[date] 01/01/2000\n[time] 00:00:00\n[extractedFrom] N_A\n[samplingfreq] %f\n[nbsegments] 1\n[enabled] 1\n[nbsamples] %d\n[segmentsize] %d\n[segmentInitialTimes] 0.0\n[nbchannels] %d\n[channelnames] :\n", F_ECH, nbEch,nbEch, [colList count]);

            for (i=1;i<=[colList count];i++)
              {
                fprintf(fp,"POP%d ------\n",i);
              }

            fclose(fp);
            // Save Forward Solution .des file
            fp = (FILE *)fopen(forwardDes,"wt");
            fprintf(fp,"[patient] SIMUL\n[date] 01/01/2016\n[time] 00:00:00\n[extractedFrom] N_A\n[samplingfreq] %f\n[nbsegments] 1\n[enabled] 1\n[nbsamples] %d\n[segmentsize] %d\n[segmentInitialTimes] 0.0\n[nbchannels] %d\n[channelnames] :\n", F_ECH, nbEch,nbEch, 4);

            for (i=1;i<=4;i++)
              {
                fprintf(fp,"POP%d ------\n",i);
              }

            fclose(fp);

            strcat(chosenfile,".dat");
            [[accViewInfoMatrix cellAtRow:0 column:0] setIntValue:0];
            [[accViewInfoMatrix cellAtRow:0 column:1] setIntValue:0];
            [accViewInfoMatrix display];
          }

        if ([[accViewInfoMatrix cellAtRow:0 column:0] intValue] == 1)
            offset = [offsetTxtField floatValue];
        else
            offset = 0.;

        fp = (FILE *)fopen(chosenfile,"wt");

        for(tt=0;tt<nbEch;tt++)
          {
            if ([[accViewInfoMatrix cellAtRow:0 column:1] intValue] == 1) fprintf(fp,"%f ",1./F_ECH * tt);
            for(i=0;i<nbCol;i++)
              {
                fprintf(fp,"%f ",sigV[i][tt] + offset * i);
              }
            fprintf(fp,"\n");
          }
        fclose(fp);

        fp = (FILE *)fopen(forwardSig,"wt");

        for(tt=0;tt<nbEch;tt++)
          {
            if ([[accViewInfoMatrix cellAtRow:0 column:1] intValue] == 1) fprintf(fp,"%f ",1./F_ECH * tt);
        for(i=0;i<4;i++)
                      {
               fprintf(fp,"%f ",sumV[i][tt]);
                      }
            fprintf(fp,"\n");
          }
        fclose(fp);

        // Add Parameters file
        unique[0]= 0;
        fp = (FILE *)fopen(param,"wt");
        for (i=0;i<=[colList count]-2;i++)
	{
        coln = [colList objectAtIndex:i+1];
        col=[colList objectAtIndex:i];
        if ((abs([col timeShiftRand]-[coln timeShiftRand])>epsilon) ||(abs([col A]- [coln A])>epsilon)||(abs([col B]- [coln B])>epsilon)||(abs([col G]-[coln G])>epsilon)||(abs([col J]- [coln J])>epsilon)||(abs([col a]- [coln a])>epsilon)||(abs([col b]-[coln b])>epsilon)||(abs([col j1]- [coln j1])>epsilon)||(abs([col j2]- [coln j2])>epsilon)||(abs([col C]- [coln C])>epsilon)||(abs([col C1]- [coln C1])>epsilon)||(abs([col C2]- [coln C2])>epsilon)||(abs([col C3]-[coln C3]>epsilon))||(abs([col C4]- [coln C4])>epsilon)||(abs([col C5]- [coln C5])>epsilon)||(abs([col C6]-[coln C6])>epsilon)||(abs([col C7]-[coln C7])>epsilon)||(abs([col C8]-[coln C8])>epsilon)||(abs([col C9]-[coln C9])>epsilon)||(abs([col moyP]-[coln moyP])>epsilon)||(abs([col sigmaP]-[coln sigmaP])>epsilon)||(abs([col coefMultP]-[coln coefMultP])>epsilon))
       		 {
       			 k++;
        		unique[k]=i+1;
       		 }

	}
		k++;
        unique[k]=[colList count];
        for (i=0;i<k;i++)
        {   col=[colList objectAtIndex:unique[i]];
            fprintf(fp,"\n From: %i to %i",unique[i],unique[i+1]-1);
            fprintf(fp,"\n-------------------- Jitter --------------------");
            fprintf(fp,"\n Jstd: %.2f",[col timeShiftRand]);
            fprintf(fp,"\n-------------------- Magnitudes ----------------");
            fprintf(fp,"\n A: %.2f",[col A]);
            fprintf(fp,"\n B: %.2f",[col B]);
            fprintf(fp,"\n G: %.2f",[col G]);
            fprintf(fp,"\n J: %.2f",[col J]);
            fprintf(fp,"\n-------------------- Dynamics ------------------");
            fprintf(fp,"\n a: %.2f",[col a]);
            fprintf(fp,"\n b: %.2f",[col b]);
            fprintf(fp,"\n j1: %.2f",[col j1]);
            fprintf(fp,"\n j2: %.2f",[col j2]);
            fprintf(fp,"\n-------------------- Connectivity --------------");
            fprintf(fp,"\n C: %.2f",[col C]);
            fprintf(fp,"\n Cpp': %.2f",[col C1]/[col C]);
            fprintf(fp,"\n Cp'p: %.2f",[col C8]/[col C]);
            fprintf(fp,"\n Ci1p: %.2f",[col C2]/[col C]);
            fprintf(fp,"\n Cpi1: %.2f",[col C3]/[col C]);
            fprintf(fp,"\n Ci2p: %.2f",[col C4]/[col C]);
            fprintf(fp,"\n Cpi2: %.2f",[col C5]/[col C]);
            fprintf(fp,"\n Cpi3: %.2f",[col C6]/[col C]);
            fprintf(fp,"\n Ci3p: %.2f",[col C7]/[col C]);
            fprintf(fp,"\n Ci1i2: %.2f",[col C9]/[col C]);
            fprintf(fp,"\n-------------------- Input Noise ---------------");
            fprintf(fp,"\n moyenne: %.2f",[col moyP]);
            fprintf(fp,"\n std: %.2f",[col sigmaP]);
            fprintf(fp,"\n Coef: %.2f",[col coefMultP]);
            fprintf(fp,"\n************************************************\n\n");

        }
	fclose(fp);
      }
    return self;
}

- generateInfoFile:(char *)fileName :(int)nbCol
{
    FILE *fp;
    int i;
    float g=10.;

    fp = (FILE *)fopen(fileName,"wt");

    fprintf(fp,"[unitX]\nsec\n[typeSignal]\nSIMU\n[unitY]\nuV\n[samplingFreq]\n%f\n[nbChannels]\n%d\n[channelNames]\n",F_ECH, nbCol);

    for(i=0;i<nbCol;i++) fprintf(fp,"C%d ",i);

    fprintf(fp,"\n[gainFactors]\n");

    for(i=0;i<nbCol;i++) fprintf(fp,"%1.1f ",g);

    fprintf(fp,"\n[sessionDate]\n01-Jan-00\n[patientName]\nSIMUL\n[patientID]\nSIMUL000\n");

    fclose(fp);

    return self;
}

- resetCols:sender
{
    int i;
    int nbCol = [colList count];
    id aCol;

    for(i=0;i<nbCol;i++)
      {
        aCol = [colList objectAtIndex:i];
        [aCol reset];
      }

    return self;
}

- displayParameters:sender
{
    int i,j;
    int nbCol = [colList count];
    id aCol;
    char buf[62000];
    char buf1[10];

    strcpy(buf,"Parametres des populations :\n");
    for(i=0;i<nbCol;i++)
      {
        aCol = [colList objectAtIndex:i];
        strcat(buf,"- ");
        strcat(buf,[aCol getName]);strcat(buf,":\n");

        strcat(buf,"   - A : ");
        sprintf(buf1,"%.2f",[aCol A]);
        strcat(buf,buf1);

        strcat(buf,"  - B : ");
        sprintf(buf1,"%.2f",[aCol B]);
        strcat(buf,buf1);strcat(buf,"\n");

        strcat(buf,"  - G : ");
        sprintf(buf1,"%.2f",[aCol G]);
        strcat(buf,buf1);strcat(buf,"\n");

        strcat(buf,"   - C : ");
        sprintf(buf1,"%.2f",[aCol C]);
        strcat(buf,buf1);

        strcat(buf,"  - C1 : ");
        sprintf(buf1,"%.2f",[aCol C1]);
        strcat(buf,buf1);

        strcat(buf,"  - C2 : ");
        sprintf(buf1,"%.2f",[aCol C2]);
        strcat(buf,buf1);

        strcat(buf,"  - C3 : ");
        sprintf(buf1,"%.2f",[aCol C3]);
        strcat(buf,buf1);

        strcat(buf,"  - C4 : ");
        sprintf(buf1,"%.2f",[aCol C4]);
        strcat(buf,buf1);strcat(buf,"\n");

        strcat(buf,"  - C5 : ");
        sprintf(buf1,"%.2f",[aCol C5]);
        strcat(buf,buf1);strcat(buf,"\n");

        strcat(buf,"  - C6 : ");
        sprintf(buf1,"%.2f",[aCol C6]);
        strcat(buf,buf1);strcat(buf,"\n");

        strcat(buf,"   - m : ");
        sprintf(buf1,"%.2f",[aCol moyP]);
        strcat(buf,buf1);

        strcat(buf,"  - sigma : ");
        sprintf(buf1,"%.2f",[aCol sigmaP]);
        strcat(buf,buf1);

        strcat(buf,"  - coefMult : ");
        sprintf(buf1,"%.2f",[aCol coefMultP]);
        strcat(buf,buf1);strcat(buf,"\n");

        strcat(buf,"   - ad : ");
        sprintf(buf1,"%.2f",[aCol ad]);
        strcat(buf,buf1);strcat(buf,"\n");
      }
    strcat(buf,"\nMatrice des couplages :\n");
    for(i=0;i<nbCol;i++)
      {
        for(j=0;j<nbCol;j++)
          {
            sprintf(buf1,"%10.2f",K[i][j]);strcat(buf,buf1);
            strcat(buf," ");
          }
        strcat(buf,"\n");
      }

    [texteView setString:[NSString stringWithCString:buf]];
    [texteWindow makeKeyAndOrderFront:self];	

    return self;
}
- loadLeadField:sender
{
int open,i;
const char *chosenfile;
char buf[64];
int nbPops = 0,k=0,contact=0;
FILE *fp;
NSOpenPanel *panneauOuverture;

panneauOuverture = [NSOpenPanel openPanel];
[panneauOuverture setTitle:@"LeadField Matrix file"];
[panneauOuverture setAccessoryView:NULL];
[panneauOuverture setRequiredFileType:@"txt"];
open = [panneauOuverture runModal];
if (open == NSOKButton)
 {	free(Leadfield);
	Leadfield = (float **)malloc(4 * sizeof(float*));
        chosenfile = [[panneauOuverture filename] cString];
        fp = (FILE *)fopen(chosenfile,"rt");
        fscanf(fp,"%s",buf);
        printf(buf);
        if (strcmp(buf,"NbPop:") == 0)
            {
               fscanf(fp,"%s",buf); nbPops=atoi(buf); printf("nbPop=%d\n", nbPops);
            }

        for(i=0;i<4;i++) Leadfield[i] = (float *)calloc(nbPops, sizeof(float));

        while(!feof(fp))
      {  
         if (k==nbPops) {k=0;contact++;}
         fscanf(fp,"%s",buf);
         k++;
         if (contact<4)
		{
         		Leadfield[contact][k]= atof(buf);	
        		// printf("nbPop=%i\n", k);
		}

      }
        fclose(fp);

 }
return self;
}

- loadParameters:sender
{
    int i,j=0,open,from,to;
    int nbCol = 0;
    float c;
    const char *chosenfile;
    NSOpenPanel *panneauOuverture;
    FILE *fp;
    char buf[64];

    panneauOuverture = [NSOpenPanel openPanel];
    [panneauOuverture setTitle:@"Fichier PARAMETRES"];
    [panneauOuverture setAccessoryView:NULL];
    [panneauOuverture setRequiredFileType:@"Param"];
    open = [panneauOuverture runModal];
    if (open == NSOKButton)
      {
        chosenfile = [[panneauOuverture filename] cString];
        fp = (FILE *)fopen(chosenfile,"rt");
        while(!feof(fp))
          {
            fscanf(fp,"%s",buf);

            if (strcmp(buf,"[nbCol]") == 0)
              {
                fscanf(fp,"%s",buf); nbCol=atoi(buf); printf("nbCol=%d\n", nbCol);
              }

            if (strcmp(buf,"[couplages]") == 0)
              {
                for(i=0;i<nbCol;i++)
                    for(j=0;j<nbCol;j++)
                      {
                        fscanf(fp,"%s",buf);
                        K[i][j] = atof(buf);
                        printf("K[%d][%d]=%f\n", i,j,K[i][j]);
                      }
              }

                if (strcmp(buf,"[colonne]") == 0)
                  {
                    fscanf(fp,"%s",buf);j=atoi(buf);printf("col:%d\n", j);
                    [self newPopulation:self];
                  }
                if (strcmp(buf,"From:") == 0)
                  {
                    fscanf(fp,"%s",buf);from=atoi(buf);printf("col:%d\n", from);
                    [self newPopulation:self];
                  }
                if (strcmp(buf,"to") == 0)
                  {
                    fscanf(fp,"%s",buf);to=atoi(buf);printf("col:%d\n", to);
                  }
                if (strcmp(buf,"A:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setA:atof(buf)];printf("A:%.2f\n", [[colList objectAtIndex:from] A]);
                  }
                if (strcmp(buf,"B:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setB:atof(buf)];printf("B:%.2f\n", [[colList objectAtIndex:from] B]);
                  }
                if (strcmp(buf,"G:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setG:atof(buf)];printf("G:%f\n", [[colList objectAtIndex:from] G]);
                  }
                if (strcmp(buf,"J:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setJ:atof(buf)];printf("J:%f\n", [[colList objectAtIndex:from] J]);
                  }
		if (strcmp(buf,"a:") == 0)
 		{
		    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] seta:atof(buf)];printf("a:%f\n", [[colList objectAtIndex:from] a]);
 		}
		if (strcmp(buf,"b:") == 0)
  		{
		    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setb:atof(buf)];printf("b:%f\n", [[colList objectAtIndex:from] b]);
		}
		if (strcmp(buf,"j1:") == 0)
		{
		    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setj1:atof(buf)];printf("j1:%f\n", [[colList objectAtIndex:from] j1]);
 		}
		if (strcmp(buf,"j2:") == 0)
		{
		    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setj2:atof(buf)];printf("j2:%f\n", [[colList objectAtIndex:from] j2]);
		}
                if (strcmp(buf,"C:") == 0)
                  {
                    fscanf(fp,"%s",buf);c=atof(buf);[[colList objectAtIndex:from] setC:c];printf("C:%f\n", [[colList objectAtIndex:from] C]);
                  }
                if (strcmp(buf,"Cpp':") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setC1:atof(buf)];printf("C1:%f\n", [[colList objectAtIndex:from] C1]);
                  }
                if (strcmp(buf,"Ci1p:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setC2:atof(buf)];printf("C2:%f\n", [[colList objectAtIndex:from] C2]);
                  }
                if (strcmp(buf,"Cpi1:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setC3:atof(buf)];printf("C3:%f\n", [[colList objectAtIndex:from] C3]);
                  }
                if (strcmp(buf,"Ci2p:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setC4:atof(buf)];printf("C4:%f\n", [[colList objectAtIndex:from] C4]);
                  }
                if (strcmp(buf,"Cpi2:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setC5:atof(buf)];printf("C5:%f\n", [[colList objectAtIndex:from] C5]);
                  }
                if (strcmp(buf,"Ci3p:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setC6:atof(buf)];printf("C6:%f\n", [[colList objectAtIndex:from] C6]);
                  }
                if (strcmp(buf,"Cpi3:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setC7:atof(buf)];printf("C7:%f\n", [[colList objectAtIndex:from] C7]);
                  }
                if (strcmp(buf,"Cp'p:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setC8:atof(buf)];printf("C8:%f\n", [[colList objectAtIndex:from] C8]);
                  }
                if (strcmp(buf,"Ci1i2:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setC9:atof(buf)];printf("C9:%f\n", [[colList objectAtIndex:from] C9]);
                  }
                if (strcmp(buf,"moyenne:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setMoyP:atof(buf)];printf("moyP:%f\n", [[colList objectAtIndex:from] moyP]);
                  }
                if (strcmp(buf,"std:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setSigmaP:atof(buf)];printf("sigmaP:%f\n", [[colList objectAtIndex:from] sigmaP]);
                  }
                if (strcmp(buf,"Coef:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setCoefMultP:atof(buf)];printf("coefMultP:%f\n", [[colList objectAtIndex:from] coefMultP]);
                  }               
		if (strcmp(buf,"Jstd:") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setTimeShiftRand:atof(buf)];printf("ad:%f\n", [[colList objectAtIndex:from] timeShiftRand]);
                  }

                if (strcmp(buf,"[ad]") == 0)
                  {
                    fscanf(fp,"%s",buf); [[colList objectAtIndex:from] setAd:atof(buf)];printf("ad:%f\n", [[colList objectAtIndex:from] ad]);
                  }
            if (strcmp(buf,"************************************************") == 0 && !feof(fp))
                {printf("from - to:%i\n", to-from);
                    for (i=from+1;i<=to;i++)
                    { printf("i:%i\n", i);
                      [self newPopulation:self];
                      [[colList objectAtIndex:i] setA:[[colList objectAtIndex:from] A]];
                      [[colList objectAtIndex:i] setB:[[colList objectAtIndex:from] B]];
                      [[colList objectAtIndex:i] setG:[[colList objectAtIndex:from] G]];
                      [[colList objectAtIndex:i] setJ:[[colList objectAtIndex:from] J]];
                      [[colList objectAtIndex:i] seta:[[colList objectAtIndex:from] a]];
                      [[colList objectAtIndex:i] setb:[[colList objectAtIndex:from] b]];
                      [[colList objectAtIndex:i] setj1:[[colList objectAtIndex:from] j1]];
                      [[colList objectAtIndex:i] setj2:[[colList objectAtIndex:from] j2]];
                      [[colList objectAtIndex:i] setC:[[colList objectAtIndex:from] C]];
                      [[colList objectAtIndex:i] setC1:[[colList objectAtIndex:from] C1]/[[colList objectAtIndex:from] C]];
                      [[colList objectAtIndex:i] setC2:[[colList objectAtIndex:from] C2]/[[colList objectAtIndex:from] C]];
                      [[colList objectAtIndex:i] setC3:[[colList objectAtIndex:from] C3]/[[colList objectAtIndex:from] C]];
                      [[colList objectAtIndex:i] setC4:[[colList objectAtIndex:from] C4]/[[colList objectAtIndex:from] C]];
                      [[colList objectAtIndex:i] setC5:[[colList objectAtIndex:from] C5]/[[colList objectAtIndex:from] C]];
                      [[colList objectAtIndex:i] setC6:[[colList objectAtIndex:from] C6]/[[colList objectAtIndex:from] C]];
                      [[colList objectAtIndex:i] setC7:[[colList objectAtIndex:from] C7]/[[colList objectAtIndex:from] C]];
                      [[colList objectAtIndex:i] setC8:[[colList objectAtIndex:from] C8]/[[colList objectAtIndex:from] C]];
                      [[colList objectAtIndex:i] setC9:[[colList objectAtIndex:from] C9]/[[colList objectAtIndex:from] C]];
                      [[colList objectAtIndex:i] setMoyP:[[colList objectAtIndex:from] moyP]];
                      [[colList objectAtIndex:i] setSigmaP:[[colList objectAtIndex:from] sigmaP]];
                      [[colList objectAtIndex:i] setCoefMultP:[[colList objectAtIndex:from] coefMultP]];
                      [[colList objectAtIndex:i] setTimeShiftRand:[[colList objectAtIndex:from] timeShiftRand]];

                    }
                  }

          }
            fclose(fp);
            for(i=0;i<nbCol;i++)
                [[colList objectAtIndex:i] showParameters:50+230*i :50+0*i];

      }
        return self;
}

- saveParameters:sender
{
    int i,j,save;
    int nbCol = [colList count];
    id aCol;
    const char *chosenfile;
    NSSavePanel *panneau_sauvegarde;
    FILE *fp;

    panneau_sauvegarde = [NSSavePanel savePanel];
    [panneau_sauvegarde setTitle:@"Fichier PARAMETRES"];
    [panneau_sauvegarde setAccessoryView:NULL];
    [panneau_sauvegarde setRequiredFileType:@"par"];
    save = [panneau_sauvegarde runModal];
    if (save == NSOKButton)
      {
        chosenfile = [[panneau_sauvegarde filename] cString];
        fp = (FILE *)fopen(chosenfile,"wt");

        fprintf(fp,"[nbCol] %d", nbCol);

        fprintf(fp,"\n\n[couplages]\n");
        for(i=0;i<nbCol;i++)
          {
            for(j=0;j<nbCol;j++)
              {
                fprintf(fp,"%10.2f ",K[i][j]);
              }
            fprintf(fp,"\n");
          }

        for(i=0;i<nbCol;i++)
          {
            aCol = [colList objectAtIndex:i];
            fprintf(fp,"\n[colonne] %d",i);
            fprintf(fp,"\n  [A] %.2f",[aCol A]);
            fprintf(fp,"\n  [B] %.2f",[aCol B]);
            fprintf(fp,"\n  [G] %.2f",[aCol G]);
            fprintf(fp,"\n  [C] %.2f",[aCol C]);
            fprintf(fp,"\n  [C1] %.2f",[aCol C1]);
            fprintf(fp,"\n  [C2] %.2f",[aCol C2]);
            fprintf(fp,"\n  [C3] %.2f",[aCol C3]);
            fprintf(fp,"\n  [C4] %.2f",[aCol C4]);
            fprintf(fp,"\n  [C5] %.2f",[aCol C5]);
            fprintf(fp,"\n  [C6] %.2f",[aCol C6]);
            fprintf(fp,"\n  [m] %.2f",[aCol moyP]);
            fprintf(fp,"\n  [sigma] %.2f",[aCol sigmaP]);
            fprintf(fp,"\n  [coefMult] %.2f",[aCol coefMultP]);
            fprintf(fp,"\n  [ad] %.2f",[aCol ad]);
          }

        fclose(fp);
      }
    return self;
}

- simuleI2I3:sender
{    
     int i,l,nbCol,from1,from2,to1,to2,i2,i3;
     float Alpha,offset,jitter;
     FILE *fp;
     id currentCol;
     char filename[255], I2S[15], I3S[15],filename2[255],filename3[255],AlphaS[15],JitterS[15];   
     float t =0., dt;
     int tt = 0, timeInitialArtefact, noSimulflag;
     float finalTime=[finalTimeTxtField floatValue];
     F_ECH = [fEchTxtField floatValue];
     dt = 1./F_ECH;
     noSimulflag = [noSimulSwitch intValue];
     timeInitialArtefact = 2*F_ECH;
     jitter= [[colList objectAtIndex:0] GaussianSigma];



     if ([checkAlpha intValue])
      {
       //read alpha  value
      Alpha = [alpha floatValue];
      // check alpha is in bounds [0,1]
     if(Alpha<0)
      {
      Alpha=0;
      [alpha setIntValue:0];
      }
     if(Alpha>1)
     {
       Alpha = 1;
    	  [alpha setIntValue:1];
     }

     nbCol = [colList count]; if (nbCol == 0) return;
     from1 = 2;
     from2 = ceil(Alpha*nbCol);
     to1 = ceil(Alpha*nbCol)-1;
     to2 = nbCol-1;
     //printf("from1: %i to1: %i from2: %i to2: %i",from1,to1,from2,to2);
     for (i=from1;i<=to1;i++)
      {
      if (Alpha != 1)
     [self setPop2:[colList objectAtIndex:i] toPop1:[colList objectAtIndex:0]];
      else
     [self setPop2:[colList objectAtIndex:1] toPop1:[colList objectAtIndex:0]];
      }
     for (i=from2;i<=to2;i++)
      {
     [self setPop2:[colList objectAtIndex:i] toPop1:[colList objectAtIndex:1]];
      }

    }


       if (tpsLabel) free (tpsLabel);
      tpsLabel = (float*)malloc(nbEch*sizeof(float));

      for(tt=0;tt<nbEch;tt++) tpsLabel[tt] = (float)tt/F_ECH;

    for (i2 = 1;i2<=10;i2++)
    {     //[[colList objectAtIndex:1] setG:i2];
          [[colList objectAtIndex:1] setG:5];
          [[colList objectAtIndex:1] setJ:0];

          for(i3 = 5;i3<=15;i3++)
        {
          strcpy(filename,"D:/ZZZ_JournalSimulations/AutoSimulations10/slowave/SIM");
  
        //[[colList objectAtIndex:0] setJ:i3];
        [[colList objectAtIndex:0] setJ:13];
        [[colList objectAtIndex:0] setG:0];

        for (i=from1;i<=to1;i++)
         {
         if (Alpha != 1)
        {[[colList objectAtIndex:i] setG:5];
        [[colList objectAtIndex:i] setJ:0];}
         else
         {[[colList objectAtIndex:1] setG:5];
         [[colList objectAtIndex:1] setJ:0];}
         }
        for (i=from2;i<=to2;i++)
         {
        [[colList objectAtIndex:i] setJ:13];
        [[colList objectAtIndex:i] setG:0];
         }
       
        [self resetCols:self];
         for(i=0;i<nbCol;i++)
           {
             currentCol = [colList objectAtIndex:i];
             [currentCol setParameters];
             [currentCol setNbOfAfferentCols:nbCol-1];
             //printf("%s |", [currentCol getName]);
           }

          nbEch = finalTime / dt;
          if (sigV)
            {
              for(i=0;i<nbCol;i++) free(sigV[i]);
              free(sigV);
	      printf("deleted");
            }

          sigV = (float **)malloc(nbCol * sizeof(float*));
          for(i=0;i<nbCol;i++) sigV[i] = (float *)calloc(nbEch, sizeof(float));
	    //--------------------------------
          if (![allowRecopySwitch intValue])
            { 
              for(i=0;i<nbCol;i++)
                {  
                  [[colList objectAtIndex:i] setAPVolleysOcurrenceTimes:[nbOfEventsTxtField intValue] :nbEch :F_ECH];
                  [[colList objectAtIndex:i] setNoiseWithNbEch:nbEch :F_ECH];
                }
            }
          else
            {

              [[colList objectAtIndex:[masterPopTxtField intValue]] setAPVolleysOcurrenceTimes:[nbOfEventsTxtField intValue] :nbEch :F_ECH];
              [[colList objectAtIndex:[masterPopTxtField intValue]] setNoiseWithNbEch:nbEch :F_ECH];

              for(i=[fromPopTxtField intValue];i<=[toPopTxtField intValue];i++)
                { 
              [[colList objectAtIndex:i] recopyAPVolleysOcurrenceTimes:[[colList objectAtIndex:[masterPopTxtField intValue]] APVolleysOcurrenceTimes] :[[colList objectAtIndex:[masterPopTxtField intValue]] inputNoiseNbEch]];

              [[colList objectAtIndex:i] setNoiseWithNbEch:nbEch :F_ECH];
                }
            }

          for(tt=0;tt<nbEch;tt++)
            { 
              if ((tt % (int)F_ECH ) == 0)
                {
                  printf("t=%f| ", t);
                  [progressTxtField setIntValue:(int)t];
                  [progressTxtField display];
                }

 	     if (!noSimulflag)
	      {
       	       for(i=0;i<nbCol;i++)
          	      {
           	       [[colList objectAtIndex:i] integre:tt:dt];
           	      [[colList objectAtIndex:i] updateStateVector];
            	      }

           	   t+= dt;

           	   for(i=0;i<nbCol;i++)
            	    {
               		   sigV[i][tt] = [[colList objectAtIndex:i] EEGoutput]+1.0;
               	    }
            }
          }

           for(i=0;i<nbCol;i++)
           for(tt=0;tt<timeInitialArtefact;tt++) sigV[i][tt] = 0.;

           for(i=0;i<nbCol;i++) sigV[i] += timeInitialArtefact;
           nbEch -= timeInitialArtefact;

           for(i=0;i<nbCol;i++)
            {
               centre_signal(sigV[i], nbEch);
            }

          sprintf(I2S, "%d", i2);
           sprintf(I3S, "%d", i3);
           sprintf(AlphaS, "%.2f", Alpha);
           sprintf(JitterS, "%.0f", jitter);

           strcat(filename,"_A_");
           strcat(filename,AlphaS);
           strcat(filename,"_J_");
           strcat(filename,JitterS);
           strcat(filename,"_I2_");
           strcat(filename,I2S);
           strcat(filename,"_I3_");
           strcat(filename,I3S);

           strcpy(filename2,filename);
           strcpy(filename3,filename);

	   strcat(filename2,".des");
           strcat(filename3,".dat");
           printf("%s\n",filename2);
                
           fp = (FILE *)fopen(filename2,"wt");
           fprintf(fp,"[patient] SIMUL\n[date] 01/01/2000\n[time] 00:00:00\n[extractedFrom] N_A\n[samplingfreq] %f\n[nbsegments] 1\n[enabled] 1\n[nbsamples] %d\n[segmentsize] %d\n[segmentInitialTimes] 0.0\n[nbchannels] %d\n[channelnames] :\n", F_ECH, nbEch,nbEch, [colList count]);
        
          if ([[accViewInfoMatrix cellAtRow:0 column:0] intValue] == 1)
               offset = [offsetTxtField floatValue];
           else
               offset = 0.;

           for (i=1;i<=[colList count];i++)
             {
               fprintf(fp,"POP%d ------\n",i);
             }

           fclose(fp);
           fp = (FILE *)fopen(filename3,"wt");
           for(tt=0;tt<nbEch;tt++)
              {
                if ([[accViewInfoMatrix cellAtRow:0 column:1] intValue] == 1) fprintf(fp,"%f ",1./F_ECH * tt);
                for(i=0;i<nbCol;i++)
                  {
                    fprintf(fp,"%f ",sigV[i][tt] + offset * i);
                  }
                fprintf(fp,"\n");
              }
            fclose(fp);
           printf("I2: %i, I3: %i\n",i2,i3);

     }
 }
    return self;

}


- simule:sender
{
    //float g, a, c3, c4,c5,c6;
    int transitionTime, n3;

    int i,nbCol,from1,from2,to1,to2,kk;
    id currentCol;
    float t =0, dt;
    int tt = 0, timeInitialArtefact, noSimulflag;

    //float * tabK;
    //float * AffCol;

    float Alpha;

    int nbPtsFFT = 256;

    FILE *fp;
    char filename[255];

    int singleSim = 1;

    float finalTime=[finalTimeTxtField floatValue];

    nbCol = [colList count]; if (nbCol == 0) return;

// set all populations to fisrt two populations if alpha is checked

    if ([checkAlpha intValue])
      {
	//read alpha  value
       Alpha = [alpha floatValue];
       // check alpha is in bounds [0,1]
    if(Alpha<0)
      {
        Alpha=0;
        [alpha setIntValue:0];
      }
    if(Alpha>1)
      {
        Alpha = 1;
        [alpha setIntValue:1];
      }
       from1 = 2;
       from2 = ceil(Alpha*nbCol);
       to1 = ceil(Alpha*nbCol)-1;
       to2 = nbCol-1;
       printf("from1: %i to1: %i from2: %i to2: %i",from1,to1,from2,to2);
       for (i=from1;i<=to1;i++)
	{
	if (Alpha != 1)
       [self setPop2:[colList objectAtIndex:i] toPop1:[colList objectAtIndex:0]];
	else
       [self setPop2:[colList objectAtIndex:1] toPop1:[colList objectAtIndex:0]];
	}
       for (i=from2;i<=to2;i++)
        {
       [self setPop2:[colList objectAtIndex:i] toPop1:[colList objectAtIndex:1]];
        }

      }
//************************************************    
//------------------------------------------------
    F_ECH = [fEchTxtField floatValue];
    dt = 1./F_ECH;
    noSimulflag = [noSimulSwitch intValue];
    timeInitialArtefact = 1.5*F_ECH;

    [self resetCols:self];

    //tabK = (float *)calloc(nbCol-1,sizeof(float));
    for(i=0;i<nbCol;i++)
      {
        currentCol = [colList objectAtIndex:i];
        [currentCol setParameters];
        [currentCol setNbOfAfferentCols:nbCol-1];
/*
        k = 0;
        for(j=0;j<nbCol;j++)
          {
            if(j != i)
              {
                tabK[k] = K[j][i];
                k++;
              }
          }
        [currentCol setTabK:tabK];
*/
        printf("%s |", [currentCol getName]);
        //[currentCol showTabK];
      }

    //AffCol = (float *)calloc(nbCol-1,sizeof(float));
    nbEch = finalTime / dt;
    
    if (sigV)
      {
        for(i=0;i<nbCol;i++) free(sigV[i]);
        free(sigV);
      }

    sigV = (float **)malloc(nbCol * sizeof(float*));
    sumV = (float **)malloc(4*sizeof(float*));

    for(i=0;i<nbCol;i++) sigV[i] = (float *)calloc(nbEch, sizeof(float));
    for(i=0;i<4;i++) sumV[i] = (float *)calloc(nbEch, sizeof(float));

    if (!singleSim)
      {
        fp = fopen(filename,"wt");
        fclose(fp);
      }

    //--------------------------------
    if (![allowRecopySwitch intValue])
      { 
        for(i=0;i<nbCol;i++)
          {  
            [[colList objectAtIndex:i] setAPVolleysOcurrenceTimes:[nbOfEventsTxtField intValue] :nbEch :F_ECH];
            [[colList objectAtIndex:i] setNoiseWithNbEch:nbEch :F_ECH];
          }
      }
    else
      {
        
        [[colList objectAtIndex:[masterPopTxtField intValue]] setAPVolleysOcurrenceTimes:[nbOfEventsTxtField intValue] :nbEch :F_ECH];
        [[colList objectAtIndex:[masterPopTxtField intValue]] setNoiseWithNbEch:nbEch :F_ECH];

        for(i=[fromPopTxtField intValue];i<=[toPopTxtField intValue];i++)
          { 
            //[[colList objectAtIndex:i] setAPVolleysOcurrenceTimes:[nbOfEventsTxtField intValue] :nbEch :F_ECH];
            //[[colList objectAtIndex:i] setNoiseWithNbEch:nbEch :F_ECH];

            //[[colList objectAtIndex:i] recopyAPVolleysOcurrenceTimes:[[colList objectAtIndex:0] APVolleysOcurrenceTimes] :[[colList objectAtIndex:[masterPopTxtField intValue]] inputNoiseNbEch]];

        [[colList objectAtIndex:i] recopyAPVolleysOcurrenceTimes:[[colList objectAtIndex:[masterPopTxtField intValue]] APVolleysOcurrenceTimes] :[[colList objectAtIndex:[masterPopTxtField intValue]] inputNoiseNbEch]];

            [[colList objectAtIndex:i] setNoiseWithNbEch:nbEch :F_ECH];
          }
      }
    for(tt=0;tt<nbEch;tt++)
      { 
        if ((tt % (int)F_ECH ) == 0)
          {
            printf("t=%f| ", t);
            [progressTxtField setIntValue:(int)t];
            [progressTxtField display];
          }
/*
        for(i=0;i<nbCol;i++)
          {
            k = 0;
            for(j=0;j<nbCol;j++)
              {
                if(j != i)
                  {
                    AffCol[k] = [[colList objectAtIndex:j] pulseOutput]; //29/09/99
                    k++;
                  }
              }
            currentCol = [colList objectAtIndex:i];
            [currentCol setTabInputs:AffCol];
          }
*/

if (!noSimulflag)
{
        for(i=0;i<nbCol;i++)
          {
            [[colList objectAtIndex:i] integre:tt:dt];
            [[colList objectAtIndex:i] updateStateVector];
          }

        t += dt;
        
        for(i=0;i<nbCol;i++)
          {
            sigV[i][tt] = [[colList objectAtIndex:i] EEGoutput]+1.0;
          }
}
      }
	//--------------------------------
       for(kk=0;kk<4;kk++)
         {
           for(i=0;i<nbCol;i++)
           {
             for(tt=0;tt<nbEch;tt++)
              {
                sumV[kk][tt] = sumV[kk][tt]+sigV[i][tt]; //*Leadfield[kk][i];
              }
           }
         }
    if (tpsLabel) free (tpsLabel);
    tpsLabel = (float*)malloc(nbEch*sizeof(float));

    for(tt=0;tt<nbEch;tt++) tpsLabel[tt] = (float)tt/F_ECH;
    
    for(i=0;i<nbCol;i++)
    for(tt=0;tt<timeInitialArtefact;tt++) sigV[i][tt] = 0.;

    for(i=0;i<4;i++) 
    for(tt=0;tt<timeInitialArtefact;tt++) sumV[i][tt] = 0.;
   
    for(i=0;i<4;i++)
    sumV[i] += timeInitialArtefact;

    for(i=0;i<nbCol;i++) sigV[i] += timeInitialArtefact;
    nbEch -= timeInitialArtefact;

    for(i=0;i<4;i++) centre_signal(sumV[i], nbEch);

    for(i=0;i<nbCol;i++)
     {
        centre_signal(sigV[i], nbEch);
     }


    if ([displaySwitch intValue])
      {
        [signalWindow makeKeyAndOrderFront:self];
        [signalView setX:tpsLabel andY:sigV nbVoies:nbCol nbPoints:nbEch];
        [signalSumView setX:tpsLabel andY:sumV nbVoies:1 nbPoints:nbEch];

        if(freqLabel)  free(freqLabel);
        freqLabel = (float*)malloc(nbPtsFFT*sizeof(float));

        if(!spectrum){
            spectrum = (float**)malloc(nbCol * sizeof(float*));
            for(i=0;i<nbCol;i++)
                spectrum[i] = (float*)calloc(nbPtsFFT,sizeof(float));
        }
      }
    //free(tabK);
    //free(AffCol);
    return self;
}

- (int)typeOfActivity:(float*)w
{
    int imemo=-1,i;
    float d, dmin;
    float V[nbOfAct][3];


    V[0][0] = 7.77;  V[0][1] = 7.17;  V[0][2] = 0.43;
    V[1][0] = 4.68;  V[1][1] = 4.15;  V[1][2] = 0.11;
    V[2][0] = 4.50;  V[2][1] = 3.76;  V[2][2] = 0.09;
    V[3][0] = 11.40; V[3][1] = 5.44;  V[3][2] = 0.29;
    V[4][0] = 17.50; V[4][1] = 9.35;  V[4][2] = 14.10;
    V[5][0] = 8.90;  V[5][1] = 3.02;  V[5][2] = 0.09;
    V[6][0] = 5.12;  V[6][1] = 3.79;  V[6][2] = 0.08;

    dmin = 1.0e99;
    for(i=0;i<nbOfAct;i++)
      {
        d = [self distance:w :V[i] :3];
        if (d<dmin)
          {
            dmin = d;
            imemo = i;
          }
      }

    return imemo;
}

- (float)distance:(float*)v1 :(float*)v2 :(int)n
{
    int i;
    float d;

    d = 0.;
    for(i = 0;i<n;i++)
      {
        d += (v1[i] - v2[i]) * (v1[i] - v2[i]);
      }

    return sqrt(d);
}

- (int)processSignal:(float*)s spectrum:(float*)spectre nbEch:(int)n nbPFFT:(int)nbPtsFFT
{
    int i,a,f;
    float sum, sumP, fb, sf, ni, nn, eG;
    static int k =1;
    float v[3];
    int nbCol = [colList count];

    [self calculeSpectreOfSig:s :n :spectre :nbPtsFFT :75];

    for(f=0;f<nbPtsFFT/2;f++)
      {
        //printf("%f %f\n", (float)f/(float)nbPtsFFT*F_ECH, spectrum[f]);
        freqLabel[f] = (float)f/(float)nbPtsFFT*F_ECH ;
      }

    [spectreWindow makeKeyAndOrderFront:self];
    [spectreView setX:freqLabel andY:spectrum nbVoies:nbCol nbPoints:nbPtsFFT/2];

    nn = (int)((float)nbPtsFFT / F_ECH  * 40.);
    sumP = 0.;

    for(i=0;i<nbCol;i++)
    for(f=1;f<nn;f++) sumP += spectre[f];

    fb = 0.;
    for(f=1;f<nn;f++)
        fb += spectre[f] * f;
    fb /= sumP;
    fb = fb * F_ECH/(float)nbPtsFFT;v[0]=fb;

    sum = 0.;
    for(f=1;f<nn;f++)
        sum += (f - fb) * (f - fb) * spectre[f];

    sf = sqrt (sum / sumP);
    sf = sf * F_ECH/(float)nbPtsFFT;
    v[1]=sf;

    ni = (int)((float)nbPtsFFT / F_ECH  * 60.);
    nn = (int)((float)nbPtsFFT / F_ECH  * 80.);

    sumP = 0.;
    for(f=0;f<nbPtsFFT/2;f++)
        sumP += spectre[f];

    sum = 0.;
    for(f=ni;f<nn;f++)
        sum += spectre[f];

    eG = sum / sumP * sumP;
    v[2]=eG;

    a = [self typeOfActivity:v];

    sum_sf += sf; sum_fb += fb; sum_eG += eG;
    
    //printf("sum: %d -> V[][0] = %.2f; V[][1] = %.2f; V[][2] = %.2f;\n", k,sum_fb/k, sum_sf/k, sum_eG/k);
    //printf("cur:%.2f,  %.2f,  %.2f -> %d\n", v[0],v[1], v[2], a);

    k ++;

    return a;
}


- calculeSpectreOfSig:(float*)sig :(int)nbPts :(float*)spectre :(int)nbPtsFFT :(float)overLap
{
    float	*Re;
    float	*Im;
    float *tamp;
    float a, energie;
    int f,i,nbBlocs,cmptBlocs = 0;

    
    //printf("\nNb Pts FFT : %d | overLap:%g\n", nbPtsFFT, overLap);

    nbBlocs = (int)(ceil((float)nbPts/(float)nbPtsFFT));
    //printf("nb blocs:%d\n", nbBlocs);

    tamp = (float*)calloc((nbBlocs+1)*nbPtsFFT,sizeof(float));
    Re = (float*)calloc(nbPtsFFT,sizeof(float));
    Im = (float*)calloc(nbPtsFFT,sizeof(float));

    for(f=0;f<nbPtsFFT;f++) spectre[f]=0.0;

    for(i=0;i<nbBlocs*nbPtsFFT;i++)	
      {
        if (i<nbPts) tamp[i] = sig[i];
        else tamp[i] = 0.;
      }

    energie = 0.;
    for(i=0;i<nbPts;i++)
      {
        energie += sig[i] * sig[i];
      }
    energie /= (float)nbPts;

    a = 0.;
    while(a < nbBlocs)
      {
        for(f=0;f<nbPtsFFT;f++)
          {
            Re[f] = tamp[f+(int)(a*nbPtsFFT)];
            Im[f] = 0.;
          }
        FFT1D(Re,Im, nbPtsFFT,-1);

        for(f=0;f<nbPtsFFT/2;f++)
          {
            spectre[f] += Re[f]*Re[f]+Im[f]*Im[f];
          }

        cmptBlocs++;
        a += (1. - overLap/100.);
        //printf("a:%g\n",a);
      }
    
    //for(f=0;f<nbPtsFFT/2;f++) spectre[f] = 1/(float)(cmptBlocs * nbPtsFFT) * log(spectre[f]) / energie;

    for(f=0;f<nbPtsFFT/2;f++) spectre[f] =  1/(float)(cmptBlocs * nbPtsFFT) * spectre[f] / energie;

    free(Re);
    free(Im);
    free(tamp);
    return self;
}


- displaySignals:sender
{

    [signalView setYMinValue:[minYTxtField floatValue]];
    [signalView setYMaxValue:[maxYTxtField floatValue]];
    [signalView display];

    return self;
}

- nSimule:sender
{
    int i,n;

    n = [nbOfSimuleTxtField intValue];

    for (i = 0;i<n;i++)
      {
        [self incK:self];
        [self simule:self];

        [self saveSignals:self];
      }

    return self;
}

- saveSignalViewAsTIF:sender
{
    NSImage * anImage;
    NSData * tiffData;
    NSRect aRect;
    char filename[255], buf[10];
    int i,cmpt;

     for(i=0;i<[multipleFrameCmptTxtField intValue];i++)
     {
         cmpt = [frameCmptTxtField intValue];

         strcpy(filename,[[frameSavingDirectoryTxtField stringValue] cString]);
         sprintf(buf,"%d.tif", cmpt);
         strcat(filename, buf);

         anImage = [NSImage alloc];

         aRect = [[signalWindow contentView] frame];
         [anImage initWithData:[signalWindow dataWithEPSInsideRect:aRect]];
         //tiffData = [anImage TIFFRepresentation];

         tiffData = [anImage TIFFRepresentationUsingCompression:5 factor:[tifCompressionFactorTxtFld floatValue]];

         [tiffData writeToFile:[NSString stringWithCString:filename] atomically:NO];

         cmpt++;
         [frameCmptTxtField setIntValue:cmpt];
     }

     return self;
}

@end
