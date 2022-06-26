
#import <AppKit/AppKit.h>

#define NB_MAX_OF_COLS 5000

@interface colManager:NSApplication
{
    id nbOfPopTxtField;

    id allowRecopySwitch;
    id displaySwitch;
    id noSimulSwitch;

    id	accessoryView_SaveTXTPanel;
    id	accViewInfoMatrix;
    id	accViewFormatMatrix;

    id	progressTxtField;

    id	colonneNumberTxtField;
    id  colList;
    id	colButtonMatrix;
    id	connexButtonMatrix;

    id	managerWindow;
    id	KValueWindow;
    id	signalWindow;
    id	signalView;
    id	signalSumView;

    id	spectreWindow;
    id	spectreView;

    id 	minYTxtField;
    id 	maxYTxtField;
    id 	labelXSwitch;
    id 	labelYSwitch;

    id	KValueTxtField;
    id	minRandomKValueTxtField;
    id	maxRandomKValueTxtField;
    id  allLineSwitch;

    id fromPopTxtField;
    id toPopTxtField;
    id masterPopTxtField;

    id	deltaKValueTxtField;
    id	finalTimeTxtField;

    id	offsetTxtField;
    id	fEchTxtField;
    id	sigNameTxtField;

    id	nbOfEventsTxtField;

    id	nbOfSimuleTxtField;
    id	frameSavingDirectoryTxtField;
    id	frameCmptTxtField;
    id	multipleFrameCmptTxtField;
    id tifCompressionFactorTxtFld;

    id	texteView;
    id	texteWindow;
    
    id  alpha;
    id  checkAlpha;
   
    float **Leadfield;
    float **K;
    float **sigV;
    float **spectrum;
    float *tpsLabel ;
    float *freqLabel ;
    float **sumV;
    float sum_sf, sum_fb, sum_eG;
    int nbEch;
    float F_ECH;
}

+ (void)initialize;


-(void)setPop2:(id)pop2 toPop1:(id)pop1;

- simule:sender;
- simuleI2I3:sender;

- nSimule:sender;
- resetCols:sender;

- setConnexValue:sender;
- setK:sender;
- setRandomKValue:sender;
- setAllKToConstantValue:sender;
- setAllKToRandomValue:sender;

-(void)recopyMasterPop:(id)sender;

- (void)newPopulation:(id)sender;
- (void)createANewPopulation;


- showColParameters:sender;
- updateColButtonMatrix:(char *)colName :(int)colNumber;
- updateConnexButtonMatrix;

- saveSignals:sender;
- (void)saveSignalsInBinFile:sender;

- incK:sender;
- decK:sender;
- clearK:sender;

- generateInfoFile:(char *)fileName :(int)nbCol;

- displayParameters:sender;
- saveParameters:sender;
- loadParameters:sender;
- loadLeadField:sender;

- displaySignals:sender;

- saveSignalViewAsTIF:sender;

- (int)processSignal:(float*)s spectrum:(float*)spectre nbEch:(int)n nbPFFT:(int)nbPtsFFT;
- calculeSpectreOfSig:(float*)sig :(int)nbPts :(float*)spectrum :(int)nbPtsFFT :(float)overLap;

- (float)distance:(float*)v1 :(float*)v2 :(int)n;
- (int)typeOfActivity:(float*)w;

- (double)randomKValue;




@end
