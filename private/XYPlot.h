
/* Generated by Interface Builder */

#import <Foundation/NSObject.h>
/*#import <AppKit/nextstd.h>*/	/* gets stdio */
#import <AppKit/NSForm.h>		/* for NXCoord, etc. */
#import <AppKit/NSColor.h>
#import <streams/streams.h>

typedef struct _datahunk {
    char  *filename;
    float *x;
    float *ex;			/* for error bars */
    float **y;
    float **ey;			/* for error bars */
    int   npoints;
    int   ncurves;
    NSPoint datamin;
    NSPoint datamax;
    BOOL    xaxislin;
    BOOL    yaxislin;
    BOOL    has_exbars;		/* for error bars */
    BOOL    has_eybars;		/* for error bars */
} datahunk;

@interface XYPlot:NSObject
{
    id  datahunkArray;		/* array of datahunk structs (a Storage object) */
    id	canvas;			/* the PlotView object */

	BOOL	xAxisIsLog;
	BOOL	yAxisIsLog;
	
	int		errorBars;
	int		lineStyle;
	int		symbolStyle;
	int		cycleLineStyle;
	int		cycleSymbolStyle;
				
	
    int ncurvestotal;		/* total number of curves  */
    int nfilestotal;		/* total no. of files "open" */

    NSPoint globaldatamin;	/* xmin and ymin from the data */
    NSPoint globaldatamax;	/* xmax and ymax from the data */

    NSPoint oldMin;		/* for use by "previous view" */
    NSPoint oldMax;		/* ditto */
    NSPoint oldInc;		/* ditto */
    NSPoint currentMin;		/* ditto */
    NSPoint currentMax;		/* ditto */
    NSPoint currentInc;		/* ditto */

	float	xLimitsMin;
	float	xLimitsMax;
	float	xLimitsInc;
	float	yLimitsMin;
	float	yLimitsMax;
	float	yLimitsInc;

    int beepError;

    NSColor * backgroundcolor, *textcolor;
    NSColor **curvecolors;
    BOOL colorOption;

}


/* instance methods */
- init;
- initWithCanvas:aView;

- (float *)xdata:(int)n;
- (float *)exdata:(int)n;
- (float **)ydata:(int)n;
- (float **)eydata:(int)n;
- (BOOL)has_exbars:(int)n;
- (BOOL)has_eybars:(int)n;

- (int) nPoints:(int)n;
- (int) nCurves:(int)n;
- (char *) filename:(unsigned)n;
- open:sender;
- openFile:(char *)dataFile :(char *)realName;

- (int) nCurvesTotal;
- (int) nFiles;

- (int)providelinestyle: (int)aCurve;
				/* 0=solid, 1=dash, 2=dot, 3=chain dash */
				/* 4=chain dot, 5=none : see defs.h */
- (int)providesymbolstyle: (int)aCurve;
				/* 0=none, 1=circle, 2=x, 3=up triangle */
				/* 4=down triangle, 5=diamond, 6=square  */
				/* 7=plus : see defs.h */

- (double)provideXmin;
- (double)provideXmax;
- (double)provideXinc;
- (double)provideYmin;
- (double)provideYmax;
- (double)provideYinc;

- (float)provideGlobalXmin;
- (float)provideGlobalYmin;

- (BOOL)xAxisIsLog;
- (BOOL)yAxisIsLog;

- resetXmin:(double)x;
- resetXmax:(double)x;
- resetXinc:(double)x;
- resetYmin:(double)x;
- resetYmax:(double)x;
- resetYinc:(double)x;

- resetMinMax:sender;

- drawPlot:sender;

- (int) readData:(NXStream *)aDataStream  :(char *)fname;

- setYAxisToLinear;
- setYAxisToLog;
- setXAxisToLinear;
- setXAxisToLog;

- checkLinLog:(datahunk *)pdh;
- checkGlobalLinLog;

- findMinMax:(datahunk *)pdh;
- findGlobalMinMax;
- niceMinMaxInc;

- plotPrepAndDraw;

- removeAllFiles:sender;

- removeAndOpen:sender;

- sanityCheck;

- (NSColor *) provideBackgroundColor;
- (NSColor *) provideTextColor;
- (NSColor *) provideCurveColor:(int)aCurve;

- (void)setBackgroundColor:(NSColor *)aColor;
- (void)setTextColor:(NSColor *)aColor;
- setCurveColor:(int)curvenum :(NSColor *)aColor;
- makeCurvesColorful:(datahunk *)pdh;

- colorOn:(BOOL)onOff;

- stackOldMinMax:(float)xmin :(float)xmax :(float)ymin :(float)ymax;

- preludeToReading:(char *)fname :(datahunk **)pdh;

- postludeToReading:(char *)fname :(int)oldncurves :(datahunk *)pdh;

- previousView:sender;

//- handleCompressedFile:(char *)fname;

@end