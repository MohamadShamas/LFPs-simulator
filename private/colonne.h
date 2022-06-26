
#import <AppKit/AppKit.h>
#include "fonctionsC.h"
#include "colonneParam.h"

@interface colonne:NSObject
{
    id	ATxtField, ARandTxtField;
    id	BTxtField, BRandTxtField;
    id	GTxtField;
    id	JTxtField;
    id	gTxtField;
    id	aTxtField;
    id	bTxtField;
    id	j1TxtField;
    id	j2TxtField;

    id	C1TxtField;
    id	C2TxtField;
    id	C3TxtField;
    id	C4TxtField;
    id	C5TxtField;
    id	C6TxtField;
    id	C7TxtField;
    id  C8TxtField;
    id  C9TxtField;

    id	coefMultPTxtField;
    id	CTxtField;
    id	moyPTxtField;
    id	sigmaPTxtField;
   
    id	GaussianSigmaTxtField;
    id	StartIntTxtField;
    id	EndIntTxtField;
    id  RandAPNumberCheck;
	
    id	timeShiftTxtField, timeShiftRandTxtField;
    id	volleyAPGainTxtField, volleyAPGainRandTxtField;
    id	volleyAPDurationTxtField;

    id	IESCanOverlapSwitch;
    id	interIESTxtField;

    id	opposSwitch;
    id	occurTimeSwitch;

    id	adTxtField;

    id	parametersWindow;
    id testField;
    char * colName;

    int nb_fonc;
    float *y, *yout, *dydx;

    //float output;

    COLONNE_PARAM * P;

    int nbOfAfferentCols;
}
- acceptParameters:sender;

- (void)reset;
- setNbOfAfferentCols:(int)n;

- init;

- showParameters:(float)xx :(float)yy;
- setParameters;
- showTabK;

- setTabK:(float *)tab;
- setTabInputs:(float *)tab;

- setWindowTitle:(const char *)colName;
- (char *) getName;

- (float)TEST;

- (float)A;
- (float)ARand;
- (float)B;
- (float)BRand;
- (float)G;
- (float)J;
- (float)g;
- (float)a;
- (float)b;
- (float)j1;
- (float)j2;

- (float)C;
- (float)C1;
- (float)C2;
- (float)C3;
- (float)C4;
- (float)C5;
- (float)C6;
- (float)C7;
- (float)C8;
- (float)C9;

- (float)ad;

- (float)moyP;
- (float)sigmaP;

- (float)GaussianSigma;
- (float)StartInt;
- (float)EndInt;

- (float)timeShift;
- (float)timeShiftRand;
- (float)coefMultP;

-(int*)APVolleysOcurrenceTimes;
-(int)inputNoiseNbEch;

- (int)volleyAPDuration;
- (float)volleyAPGain;
- (float)volleyAPGainRand;

- setA:(float)x;
- setARand:(float)x;
- setB:(float)x;
- setBRand:(float)x;
- setG:(float)x;
- setJ:(float)x;
- setg:(float)x;
- seta:(float)x;
- setb:(float)x;
- setj1:(float)x;
- setj2:(float)x;

- setC:(float)x;
- setC1:(float)x;
- setC2:(float)x;
- setC3:(float)x;
- setC4:(float)x;
- setC5:(float)x;
- setC6:(float)x;
- setC7:(float)x;
- setC8:(float)x;
- setC9:(float)x;

- setAd:(float)x;
- setMoyP:(float)x;
- setSigmaP:(float)x;
- setCoefMultP:(float)x;
- setGaussianSigma:(float)x;
- setStartInt:(float)x;
- setEndInt:(float)x;

- setTimeShift:(float)x;
- setTimeShiftRand:(float)x;
- setVolleyAPGain:(float)x;
- setVolleyAPGainRand:(float)x;
- setVolleyAPDuration:(int)x;


- (id)getOccurTimeSwitch;
- (id)getIESCanOverlapSwitch;
- (id)getRandAPNumberCheck;

- (float) EEGoutput;
- (float) pulseOutput;


//- (void)setNoiseForRecup:(int)m;

- (void)setNoiseWithNbEch:(int)m :(float)fEch;
- (void)setAPVolleysOcurrenceTimes:(int)nb :(int)m :(float)fEch;
- (void)recopyAPVolleysOcurrenceTimes:(int*)ot :(int)nbEch;


- integre:(float)t :(float)dt;
- updateStateVector;


- (id) parametersWindow;
- (id) Window;
- (void)dealloc;

@end
