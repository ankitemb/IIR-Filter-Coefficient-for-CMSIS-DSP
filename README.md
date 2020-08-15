# IIR Filter Coefficient for CMSIS DSP

IIR filter implementation on ARM Cortex cores requires coefficient while using CMSIS DSP Library. A GNU Octave script is use to compute coefficient for IIR filter which runs on ARM Cortex core.  
  
The script compute coefficients for IIR filter implemented as [Biquad Cascade IIR Filters Using Direct Form I Structure](https://www.keil.com/pack/doc/CMSIS/DSP/html/group__BiquadCascadeDF1.html) and [Biquad Cascade IIR Filters Using a Direct Form II Transposed Structure](https://www.keil.com/pack/doc/CMSIS/DSP/html/group__BiquadCascadeDF2T.html). ARM's [CMSIS DSP](https://www.keil.com/pack/doc/CMSIS/DSP/html/index.html) library IIR filter implementation can run efficiently and optimally on ARM Coretx cores with floating point data.
  
  
# Supporting IIR Filters
1. Butterworth Filter (Lowpass, Highpass, Bandpass and Bandstop)  
2. Chebyshev-1 Filter (Lowpass, Highpass, Bandpass and Bandstop)  
3. Bessel Filter (Lowpass and Highpass)  
4. Elliptic Filter (Lowpass, Highpass, Bandpass and Bandstop)  

# Example Usage
  
See the [iir coefficient generator examples](https://github.com/ac1215/IIR-Filter-Coefficient-for-CMSIS-DSP/blob/master/iir_filter_coeffs_usage.txt) for use of example. After running example, you will get coefficient in form which is required in CMSIS DSP library.
  
CMSIS DSP Library expects coefficient in second order section digital filter manner:
```
   {b10, b11, b12, a11, a12, b20, b21, b22, a21, a22, ...}
```
Ouput of example:
```
coeffs =

   0.00032   0.00063   0.00032   1.84850  -0.86742
   1.00000   1.00001  -0.00000   0.86679  -0.00000
```
  
The generated coefficient can be directly used in ARM's filter code like following:
  
```
#define TEST_LENGTH_SAMPLES 128
#define BLOCK_SIZE 32
#define NUM_BLOCKS (TEST_LENGTH_SAMPLES / BLOCK_SIZE)

#define NUM_STAGE_IIR 2
#define NUM_ORDER_IIR (NUM_STAGE_IIR * 2)
#define NUM_STD_COEFFS 5 // b0, b1, b2, a1, a2

static float32_t iirState[NUM_ORDER_IIR];
static float32_t iirCoeffs[NUM_STAGE_IIR * NUM_STD_COEFFS] = 
{
    0.96452, -1.92904, 0.96452, 1.94945, -0.95020,
    1.00000, -2.00000, 1.00000, 1.97831, -0.97906
}

float32_t OutputValues[TEST_LENGTH_SAMPLES];
float32_t InputValues[TEST_LENGTH_SAMPLES];

float32_t *InputValuesf32_ptr = &InputValues[0];  // declare Input pointer 
float32_t *OutputValuesf32_ptr = &OutputValues[0]; // declare Output pointer

arm_biquad_cascade_df2T_instance_f32 S;

int main()
{
    uint32_t k;
    
    for (k = 0; k < TEST_LENGTH_SAMPLES; n++)
    {
  	    InputValues[n]= arm_sin_f32(2*PI*50.0*n/500.0);
    }
    
    arm_biquad_cascade_df2T_init_f32(&S, NUM_STAGE_IIR, &iirCoeffs[0], &iirState[0]);
    
    for (k = 0; k < NUMBLOCKS; k++)
    {
	arm_biquad_cascade_df2T_f32 (&S, InputValuesf32_ptr + (k*BLOCKSIZE), OutputValuesf32_ptr + (k*BLOCKSIZE), BLOCKSIZE);    // perform filtering
    }
    
    while(1);
}
```  
  
**Note: Above examples is not written for particular filter design but aim is to shown full example of IIR filter using ARM's CMSIS DSP library.**
