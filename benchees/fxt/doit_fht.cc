#define NAME "fxt-fht"
#define NOTES "FFT by FHT algorithm, split real/imag format"

#define NO_Complex 1

#define DOIT_FFT fht_fft(inr, ini, m, is)

#include "doit.cc"
