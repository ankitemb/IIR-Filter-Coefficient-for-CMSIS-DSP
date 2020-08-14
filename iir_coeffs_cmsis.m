## @author Ankit Chudasama
## @date 14-08-2020
## @Version 1.0.0
##
## @brief M file to design IIR filter and get coefficient for CMSIS DSP
##
## @arg iir_filter - IIR Filter Type (Butterworth, Chebyshev - 1, Bessel)
## @arg order - Order of the Filter
## @arg fs - Sampling Frequency
## @arg fc - Cut-off Frequency
## @arg ft - Filter Type
##
## Low pass filter 
##
## @example
## iir_coeffs_cmsis("IIR Filter type", order, sampling frequency, cut-off freq, 'low')
## @endexample
##
## High pass filter 
##
## @example
## iir_coeffs_cmsis("IIR Filter type", order, sampling frequency, cut-off freq, 'high')
## @endexample
##
## Bandpass filter % Bessel filter yet not available
##
## @example
## iir_coeffs_cmsis("IIR Filter type", order, sampling frequency, [cut-off freq1, cut-off freq2], 'pass')
## @endexample
##
## Bandstop filter % Bessel filter yet not available 
##
## @example
## iir_coeffs_cmsis("IIR Filter type", order, sampling frequency, [cut-off freq1, cut-off freq2], 'stop')
## @endexample


function iir_coeffs_cmsis(iir_filter, order, fs, fc, ft, plot_on)  
  
  fNyq = fs / 2; % Nyquist sample frequency
  filt = iir_filter; % IIR fliter type (butterworth, chebyshev, bessel)
  
  % Finding Numerator and Denominator polynomials
  switch (filt)
    case {"butter" "Butter" "BUTTER"} % Butterworth Filter
      [b, a] = butter(order, fc / fNyq, ft);
    case {"chebyshev" "Chebyshev" "CHEBYSHEV"} % Chebyshev type 1 Filter
      % Chebyshev filter only required passband ripple.
      % So, interactively asking to user for value.
      rp = input("Enter Value of Passband ripple: ")
      [b, a] = cheby1(order, rp, fc / fNyq, ft);
    case {"bessel" "Bessel" "BESSEL"} % Bessel Filter
      % Highpass and lowpass filters are only possible.
      % Bandpass and Bandstop filters yet not developed.
      [b, a] = besself(order, fc / fNyq, ft, 'z');
    case
      error("filter type is wrong.");
  endswitch
  
  
  %Getting series second order coeffs from numerator and denominator polynomials
  [sos] = tf2sos(b, a);
  %Making coeffs ready to use in the CMSIS library of ARM
  % Numerator polynomials - b0 b1 b2
  % Denominator polynomials - a0 a1 a2
  % a0 is always 1. So, a0 is not required in CMSIS library.
  % Compute biquad coefficient
  coeffs = sos(:,[1 2 3 5 6]); % removed a0 from sos.
  % CMSIS expect a1 and a2 negated
  coeffs(:,4) = -coeffs(:,4);
  coeffs(:,5) = -coeffs(:,5);

  % print coefficient
  coeffs
  
endfunction
