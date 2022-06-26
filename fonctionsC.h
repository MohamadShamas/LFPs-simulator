#define M_PI 3.1415926535897932384626433832795

typedef struct
{
	float A, ARand;
	float B, BRand;
	float G;
        float J;

	float C;
	float C1;
	float C2;
	float C3;
	float C4;
	float C5;
	float C6;
	float C7;
        float C8;
        float C9;

	float a;
	float b;
	float g;
        float j1;
        float j2;

	float v0;
	float e0;
	float r;

	float ad;

	float moyP;
	float sigmaP;
	float coefMultP;


	float n; //nb. of Afferent Cols
	float *K;
	float *inCol;

        float* inputNoise;
        int *occurenceTimeInt;
        int nbEch;

        float timeShift,timeShiftRand;
        int volleyAPDuration;
        float volleyAPGain, volleyAPGainRand;
	float GaussianSigma;

        float* noise;

}	COLONNE_PARAM;

//------------------------------------------------------------------
float randomize(float parameter, float rate);
float normalizedRandom();
float GaussianNumber(float m, float sigma);

//------------------------------------------------------------------
float nextTime(float rateParameter); //Poisson distrib
//------------------------------------------------------------------
//------------------------------------------------------------------
void saveAsBin(char *fileName, float **data, int nbC, int nbL);
void saveAsBinMux(char *fileName, float **data, int nbC, int nbL);
//------------------------------------------------------------------
void rk4(float *y, float *dydx, int n, float x, float h, float *yout, void aDerivFunction(float, float *, float *, COLONNE_PARAM*,float), COLONNE_PARAM *P );
//------------------------------------------------------------------
float sigm(float v, COLONNE_PARAM *P);
//------------------------------------------------------------------
float p(COLONNE_PARAM *P);
//------------------------------------------------------------------
float bruitGaussien(float sigma,float m);
//------------------------------------------------------------------
void derivs(float t, float *y, float *dydx, COLONNE_PARAM *P, float bruit);

//------------------------------------------------------------------
float * vector(int n);
//------------------------------------------------------------------
void free_vector(float *v);

void centre_signal(float *s,int Nbp);

void FFT1D(float *zr,float *zi,short n,short sign);

