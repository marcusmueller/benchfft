dnl Process this file with autoconf to produce a configure script.
AC_INIT([benchfft], [3.2])
AC_CONFIG_SRCDIR([libbench/bench.h])
AC_CANONICAL_HOST
AM_INIT_AUTOMAKE([foreign color-tests parallel-tests silent-rules subdir-objects 1.11])
AM_CONFIG_HEADER(config.h)
AC_CONFIG_MACRO_DIR([m4])
AM_MAINTAINER_MODE

# configure options
AC_ARG_ENABLE(debug, [AC_HELP_STRING([--enable-debug],[compile benchfft with extra runtime checks for debugging])], ok=$enableval, ok=no)
if test "$ok" = "yes"; then
	AC_DEFINE(BENCHFFT_DEBUG,1,[Define to enable extra benchfft debugging code.])
fi

AC_ARG_ENABLE(single, [AC_HELP_STRING([--enable-single],[compile single-precision benchmark])], benchfft_single=$enableval, benchfft_single=no)
if test "$benchfft_single" = "yes"; then
	AC_DEFINE(BENCHFFT_SINGLE,1,[Define to benchmark in single precision.])
fi

AC_ARG_WITH(info-only, [AC_HELP_STRING([--with-info-only],[compile doits for info purposes only])], benchfft_info_only=$withval, benchfft_info_only=no)

if test "$benchfft_info_only" = yes; then
	AC_DEFINE(INFO_ONLY, 1, [define to compile for info only])
fi
AM_CONDITIONAL(INFO_ONLY, test "$benchfft_info_only" = "yes")

AM_CONDITIONAL(SINGLE, test "$benchfft_single" = "yes" || test "$benchfft_info_only" = "yes")
AM_CONDITIONAL(DOUBLE, test "$benchfft_single" = "no" || test "$benchfft_info_only" = "yes")

# Checks for programs.
AC_PROG_CC
AC_PROG_CC_STDC
AM_PROG_CC_C_O
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_RANLIB
AC_PROG_AWK

# check for c++, but allow the check to fail
AC_CHECK_PROGS(CXX, $CCC c++ g++ gcc CC cxx cc++ cl, nosuchprogram)
if test "$CXX" = nosuchprogram; then
    CXX=""
else
    AC_PROG_CXX
fi

AM_CONDITIONAL(CXX_GNU, test "x$ac_cv_cxx_compiler_gnu" = "xyes")

AC_CHECK_PROG(GZIP, gzip, gzip)
AC_CHECK_PROG(TAR, tar, tar)
AC_CHECK_PROG(MKDIR, mkdir, mkdir)
AC_CHECK_PROG(TR, tr, tr)
AC_CHECK_PROG(CP, cp, cp)
AC_CHECK_PROG(PATCH, patch, patch)

AC_PROG_F77
if test -n "$F77"; then
	AC_F77_LIBRARY_LDFLAGS
	AC_F77_DUMMY_MAIN([], bench_f77_fails=yes)
	if test "x$bench_f77_fails" = xyes; then
		AC_MSG_WARN([Cannot figure out how to link C code with Fortran libraries.])
		F77=""  # disable F77 benchmarks
	else
		AC_F77_WRAPPERS
		AX_F77_CMAIN_FFLAGS
	fi
fi

AC_PROG_FC([], [Fortran 90])
if test -n "$FC"; then
	AC_FC_LIBRARY_LDFLAGS
	AC_FC_DUMMY_MAIN([], bench_fc_fails=yes)
	if test "x$bench_fc_fails" = xyes; then
		AC_MSG_WARN([Cannot figure out how to link C code with Fortran libraries.])
		FC=""  # disable FC benchmarks
	else
		if test "x$FC_DUMMY_MAIN" = "x$F77_DUMMY_MAIN"; then
			AC_DEFINE([FC_F77_DUMMY_MAINS_IDENTICAL], [1], [if identical])
		fi
		AC_FC_WRAPPERS
		AC_LANG_PUSH(Fortran)
		AC_FC_SRCEXT(f90)
		AC_LANG_POP(Fortran)
	fi
fi

AM_CONDITIONAL(HAVE_CXX, test -n "$CXX")
AM_CONDITIONAL(HAVE_F77, test -n "$F77")
AM_CONDITIONAL(HAVE_FC, test -n "$FC")

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS(malloc.h sys/time.h unistd.h string.h)
AC_CHECK_HEADERS(alloca.h stddef.h libintl.h)

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE
AC_TYPE_SIZE_T
AC_HEADER_TIME

# Checks for library functions.
AC_FUNC_ALLOCA
AC_FUNC_MALLOC
AC_FUNC_VPRINTF
AC_CHECK_LIB(m, sin)
AC_CHECK_FUNCS(BSDgettimeofday)
AC_CHECK_FUNCS(gettimeofday)
AC_CHECK_FUNCS(drand48)
AC_CHECK_FUNCS(hypot)
AC_CHECK_FUNCS(sqrt)
AC_CHECK_FUNCS(strtod)
AC_CHECK_FUNCS(memset)
AC_CHECK_FUNCS(memalign)
AC_CHECK_DECLS(drand48)
AC_CHECK_DECLS(hypot,[],[],[#include <math.h>])

# Check for installed libraries
# check for pthreads library (required by MKL below)
AC_CHECK_LIB(pthread, pthread_attr_init)

# check for libdl (required by MKL-6.0)
AC_CHECK_LIB(dl, dlopen)

# Check for FFTW 2
AC_CHECK_LIB(fftw, fftw_create_plan_specific,
	[LFFTW="-lfftw"; have_fftw2=yes])
AC_CHECK_LIB(rfftw, rfftw_create_plan_specific,
	[LFFTW="-lrfftw $LFFTW"; have_rfftw2=yes],[],$LFFTW)
AC_CHECK_HEADERS(fftw.h, [have_fftw_h=yes])
AC_CHECK_HEADERS(rfftw.h, [have_rfftw_h=yes])
AC_SUBST(LFFTW)
test -n "$have_fftw2" && test -n "$have_rfftw2" && test -n "$have_fftw_h" && test -n "$have_rfftw_h" && have_fftw2_all=yes
AM_CONDITIONAL(HAVE_FFTW2, test -n "$have_fftw2_all")
AC_CHECK_LIB(sfftw, fftw_create_plan_specific,
	[LSFFTW="-lsfftw"; have_sfftw2=yes])
AC_CHECK_LIB(srfftw, rfftw_create_plan_specific,
	[LSFFTW="-lsrfftw $LSFFTW"; have_srfftw2=yes],[],$LSFFTW)
AC_CHECK_HEADERS(sfftw.h)
AC_CHECK_HEADERS(srfftw.h)
AC_SUBST(LSFFTW)
test -n "$have_sfftw2" && test -n "$have_srfftw2" && have_sfftw2_all=yes
AM_CONDITIONAL(HAVE_SFFTW2, test -n "$have_sfftw2_all")

# Check for FFTW 3
AC_CHECK_LIB(fftw3, fftw_execute,
		    [LFFTW3="-lfftw3"; have_fftw3=yes])
AC_SUBST(LFFTW3)
AC_CHECK_LIB(fftw3f, fftwf_execute, 
		     [LFFTW3F="-lfftw3f"; have_fftw3f=yes])
AC_SUBST(LFFTW3F)
AC_CHECK_HEADERS(fftw3.h, [have_fftw3_h=yes])
test -n "$have_fftw3" && test -n "$have_fftw3_h" && have_fftw3_all=yes
test -n "$have_fftw3f" && test -n "$have_fftw3_h" && have_fftw3f_all=yes
AM_CONDITIONAL(HAVE_FFTW3, test -n "$have_fftw3_all")
AM_CONDITIONAL(HAVE_FFTW3F, test -n "$have_fftw3f_all")

# Check for DEC Alpha DXML library
AC_CHECK_LIB(dxml, zfft_, [have_dxml=yes; DXML_LIB=-ldxml], [AC_CHECK_LIB(cxml, zfft_, [have_dxml=yes; DXML_LIB=-lcxml])])
AM_CONDITIONAL(HAVE_DXML, test -n "$have_dxml")
AC_SUBST(DXML_LIB)
AC_CHECK_HEADERS(dxmldef.h cxmldef.h)

# Check for HP MLIB (either 32-bit or 64-bit version)
AC_CHECK_LIB(cl, ZEXP, [:], [have_mlib=no])
if test "x$have_mlib" = x; then
    AC_CHECK_LIB(veclib, src3ft, 
       [AC_CHECK_HEADER(veclib.h, [have_mlib=yes; MLIB_LIB="-lveclib -lcl"])])
fi
if test "x$have_mlib" = x; then
    AC_CHECK_LIB(veclib8, src3ft, 
       [AC_CHECK_HEADER(veclib8.h, [have_mlib=yes; MLIB_LIB="-lveclib8 -lcl"
	  AC_DEFINE(HAVE_VECLIB8, 1, [yes if linking -lveclib8])])])
fi
AM_CONDITIONAL(HAVE_MLIB, test "x$have_mlib" = xyes)
AC_SUBST(MLIB_LIB)

# Check for Sun Performance library:
SAVE_LIBS=$LIBS
LIBS="-xlic_lib=sunperf $LIBS"
AC_CHECK_FUNCS(cfftc_, [LIBS="-xlic_lib=sunperf $LIBS";  have_sunperf=yes])
AM_CONDITIONAL(HAVE_SUNPERF, test -n "$have_sunperf")
AC_CHECK_HEADERS(sunperf.h)
AC_CHECK_FUNCS(sunperf_version_)
LIBS=$SAVE_LIBS  # sunperf's symbols may interfere with fftpack.

# Check for SGIMATH library:
AC_CHECK_LIB(complib.sgimath, zfft1d, [have_sgimath=yes])
AM_CONDITIONAL(HAVE_SGIMATH, test -n "$have_sgimath")
AC_CHECK_HEADERS(fft.h)

# Check for AMD Core Math Library (ACML):
AC_CHECK_LIB(acml, zfft1d_, [have_acml=yes], [], $FLIBS)
AM_CONDITIONAL(HAVE_ACML, test -n "$have_acml")
AC_CHECK_HEADERS(acml.h)

# Check for ESSL library (some versions have only one precision):
if test "x$benchfft_single" = xyes; then
	essl_prefix=s
else
	essl_prefix=d
fi
AC_CHECK_LIB(essl, ${essl_prefix}cft, [have_essl=yes], [], $FLIBS)
AM_CONDITIONAL(HAVE_ESSL, test -n "$have_essl")

# Check for NAG library:
AC_F77_FUNC(c06frf)
if test "x$LIBNAG" = x; then
	AC_CHECK_LIB(nag, $c06frf, [have_nag=yes; LIBNAG=-lnag], [], $FLIBS)
else # user-specified $LIBNAG
	my_LIBS="$LIBS"
	LIBS="$LIBNAG $LIBS $FLIBS"
	AC_CHECK_FUNC($c06frf, [have_nag=yes])
	LIBS="$my_LIBS"
fi
AM_CONDITIONAL(HAVE_NAG, test -n "$have_nag")
AC_SUBST(LIBNAG)

# Check for IMSL library:
if test "x$benchfft_single" = xyes; then
	AC_F77_FUNC(f2tcf, imsl_f2tcf)
else
	AC_F77_FUNC(df2tcf, imsl_f2tcf)
fi
if test "x$LIBIMSL" = x; then
        AC_CHECK_LIB(imsl, $imsl_f2tcf, [have_imsl=yes; LIBIMSL=-limsl], [], $FLIBS)
else # user-specified $LIBIMSL
        my_LIBS="$LIBS"
        LIBS="$LIBIMSL $LIBS $FLIBS"
        AC_CHECK_FUNC($imsl_f2tcf, [have_imsl=yes])
        LIBS="$my_LIBS"
fi
AM_CONDITIONAL(HAVE_IMSL, test -n "$have_imsl")
AC_SUBST(LIBIMSL)

# Check for Apple's vDSP/vecLib library:
xsave_CPPFLAGS="$CPPFLAGS"
CPPFLAGS="$CPPFLAGS -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/Headers"
test -z "$VECLIB" && VECLIB="-framework Accelerate"
AC_CHECK_HEADER(vDSP.h,
	[AC_CHECK_LIB(m, vDSP_fft_zop, [have_vdsp=yes],
		[CPPFLAGS="$xsave_CPPFLAGS"], $VECLIB)],
	[CPPFLAGS="$xsave_CPPFLAGS"])
AC_SUBST(VECLIB)
AM_CONDITIONAL(HAVE_VDSP, test -n "$have_vdsp")

# Check for Intel's MKL library:
AC_CHECK_LIB(mkl_rt, zfft1d_, [have_mkl=yes])
AM_CONDITIONAL(HAVE_MKL, test -n "$have_mkl")
AC_CHECK_LIB(mkl_rt, DftiCreateDescriptor, [have_mkl_dfti=yes])
AM_CONDITIONAL(HAVE_MKL_DFTI, test -n "$have_mkl_dfti")

AC_CHECK_HEADERS(mkl_dfti.h)
AC_CHECK_HEADERS(mkl_fft.h)
AC_CHECK_HEADERS(mkl_blas.h)


# Check for Intel's IPP library:
AC_CHECK_HEADERS(ipps.h)
AC_CHECK_LIB(ipps, ippsGetLibVersion, [have_ipps=yes])
AM_CONDITIONAL(HAVE_IPPS, test -n "$have_ipps")
AC_CHECK_LIB(ippsem64t, ippsGetLibVersion, [have_ippsem64t=yes])
AM_CONDITIONAL(HAVE_IPPSEM64T, test -n "$have_ippsem64t")
AC_CHECK_LIB(ipps64, ippsGetLibVersion, [have_ipps64=yes])
AM_CONDITIONAL(HAVE_IPPS64, test -n "$have_ipps64")

# check for Numerical Recipes source in benchees/nr
nr_dir=$srcdir/benchees/nr
test -r $nr_dir/four1.c && test -r $nr_dir/fourn.c && test -r $nr_dir/realft.c && test -r $nr_dir/rlft3.c && have_nrc=yes
test -r $nr_dir/four1.f && test -r $nr_dir/fourn.f && test -r $nr_dir/realft.f && test -r $nr_dir/rlft3.f && have_nrf=yes

dnl Check for the GNU Scientific Library
SAVE_LIBS=$LIBS
AC_CHECK_LIB(gslcblas, cblas_dsdot) dnl why on the hell does it use cblas?
AC_CHECK_LIB(gsl, gsl_fft_complex_forward, [have_gsl=yes])
AC_CHECK_HEADERS([gsl/gsl_fft.h gsl/gsl_fft_complex.h gsl/gsl_fft_real.h])
AC_CHECK_HEADERS([gsl/gsl_fft_halfcomplex.h gsl/gsl_version.h])
AM_CONDITIONAL(HAVE_GSL, test -n "$have_gsl")
LIBS=$SAVE_LIBS

dnl Check for libavcodec from the ffmpeg project
AC_CHECK_PROG(FFMPEG_CONFIG, ffmpeg-config, ffmpeg-config)
if test "x$FFMPEG_CONFIG" = "xffmpeg-config"; then
  have_ffmpeg=yes
  FFMPEG_LIBS=`$FFMPEG_CONFIG --libs avcodec`
  AC_SUBST(FFMPEG_LIBS)
fi
AM_CONDITIONAL(HAVE_FFMPEG, test -n "$have_ffmpeg")


dnl Check for SCSL library (SGI/Cray Scientific Library):
AC_CHECK_LIB(scs, zzfft)

dnl Check for Cray SCILIB library:
AC_CHECK_LIB(sci, CCFFT)

AC_MSG_CHECKING([for isnan])
AC_TRY_LINK([#include <math.h>
], if (!isnan(3.14159)) isnan(2.7183);, ok=yes, ok=no)
if test "$ok" = "yes"; then
	AC_DEFINE(HAVE_ISNAN,1,[Define if the isnan() function/macro is available.])
fi
AC_MSG_RESULT(${ok})


dnl check for optimization options
dnl This macro sets ANSI mode for certain compilers, and must
dnl thus come before the subsequenct checks
dnl TEMPORARY: disabling this, since I didn't find a way of overriding this from the command line.
dnl AX_CC_MAXOPT

AX_GCC_ARCHFLAG(no, [GCC_ARCH=`echo $ax_cv_gcc_archflag | cut -d= -f2`])
AC_SUBST(GCC_ARCH)

if test "$GCC" = "yes"; then
    AX_CHECK_COMPILER_FLAGS(-msse, SSE_CFLAGS="-msse2")
    AX_CHECK_COMPILER_FLAGS(-msse2, SSE2_CFLAGS="-msse2")
    AX_CHECK_COMPILER_FLAGS(-msse3, SSE3_CFLAGS="-msse3")
    AX_CHECK_COMPILER_FLAGS(-faltivec, ALTIVEC_CFLAGS="-faltivec",
	[AX_CHECK_COMPILER_FLAGS(-maltivec -mabi=altivec,
	    [ALTIVEC_CFLAGS="-maltivec -mabi=altivec -DOS_LINUXPPC"
	     ALTIVEC_ABIFLAGS="-mabi=altivec"])])
fi
AC_SUBST(SSE_CFLAGS)
AC_SUBST(SSE2_CFLAGS)
AC_SUBST(SSE3_CFLAGS)
AC_SUBST(ALTIVEC_CFLAGS)
AC_SUBST(ALTIVEC_ABIFLAGS)

dnl check whether SSE works:
AC_MSG_CHECKING([whether SSE instructions work])
save_CFLAGS=$CFLAGS
CFLAGS="$CFLAGS $SSE_CFLAGS"
AC_RUN_IFELSE([AC_LANG_PROGRAM([],[[
     __asm__ __volatile__ ("xorps %xmm0, %xmm0");
     return 0;
]])], [have_sse=yes], [have_sse=no], [have_sse=no])
CFLAGS=$save_CFLAGS
AC_MSG_RESULT($have_sse)
AM_CONDITIONAL(HAVE_SSE, test "x$have_sse" = xyes)

dnl check whether SSE2 works:
AC_MSG_CHECKING([whether SSE2 instructions work])
save_CFLAGS=$CFLAGS
CFLAGS="$CFLAGS $SSE2_CFLAGS"
AC_RUN_IFELSE([AC_LANG_PROGRAM([],[[
     __asm__ __volatile__ ("xorpd %xmm0, %xmm0");
     return 0;
]])], [have_sse2=yes], [have_sse2=no], [have_sse2=no])
CFLAGS=$save_CFLAGS
AC_MSG_RESULT($have_sse2)
AM_CONDITIONAL(HAVE_SSE2, test "x$have_sse2" = xyes)

dnl check whether SSE3 works:
AC_MSG_CHECKING([whether SSE3 instructions work])
save_CFLAGS=$CFLAGS
CFLAGS="$CFLAGS $SSE3_CFLAGS"
AC_RUN_IFELSE([AC_LANG_PROGRAM([],[[
     __asm__ __volatile__ ("addsubpd %xmm0, %xmm0");
     return 0;
]])], [have_sse3=yes], [have_sse3=no], [have_sse3=no])
CFLAGS=$save_CFLAGS
AC_MSG_RESULT($have_sse3)
AM_CONDITIONAL(HAVE_SSE3, test "x$have_sse3" = xyes)

dnl override CFLAGS selection when debugging
if test "${enable_debug}" = "yes"; then
	CFLAGS="-g"
fi

AC_DEFINE_UNQUOTED(BENCH_CC, "$CC $CFLAGS", [C compiler name and flags])
if test -n "$CXX"; then
	AC_DEFINE_UNQUOTED(BENCH_CXX, "$CXX $CXXFLAGS",
		[C++ compiler name and flags])
fi
if test -n "$F77"; then
	AC_DEFINE_UNQUOTED(BENCH_F77, "$F77 $FFLAGS",
		[Fortran 77 compiler name and flags])
fi
if test -n "$F90"; then
	AC_DEFINE_UNQUOTED(BENCH_F90, "$F90 $F90FLAGS",
		[Fortran 90 compiler name and flags])
fi


case $host_cpu in
	i*86*) PFFTW_ARCH=pentium ;;
	*sparc*) PFFTW_ARCH=ultrasparc ;;
esac
AC_SUBST(PFFTW_ARCH)
AM_CONDITIONAL(HAVE_PFFTW_ARCH, test -n "$PFFTW_ARCH")

AC_OUTPUT([
Makefile
libbench/Makefile
benchees/Makefile
scripts/Makefile

benchees/acml/Makefile
benchees/arprec/Makefile
benchees/bloodworth/Makefile
benchees/burrus/Makefile
benchees/cross/Makefile
benchees/cwplib/Makefile
benchees/dfftpack/Makefile
benchees/dsp/Makefile
benchees/duccfft/Makefile
benchees/dxml/Makefile
benchees/emayer/Makefile
benchees/esrfft/Makefile
benchees/essl/Makefile
benchees/ffmpeg/Makefile
benchees/ffte/Makefile
benchees/fftj/Makefile
benchees/fftpack/Makefile
benchees/fftreal/Makefile
benchees/fftw2/Makefile
benchees/fftw3/Makefile
benchees/fxt/Makefile
benchees/glassman/Makefile
benchees/goedecker/Makefile
benchees/gpfa/Makefile
benchees/green-ffts-2.0/Makefile
benchees/gsl/Makefile
benchees/harm/Makefile
benchees/hp-mlib/Makefile
benchees/imsl/Makefile
benchees/intel-ipps/Makefile
benchees/intel-mkl/Makefile
benchees/jmfft/Makefile
benchees/kissfft/Makefile
benchees/krukar/Makefile
benchees/mfft/Makefile
benchees/minfft/Makefile
benchees/mixfft/Makefile
benchees/monnier/Makefile
benchees/morris/Makefile
benchees/mpfun77/Makefile
benchees/mpfun90/Makefile
benchees/nag/Makefile
benchees/napack/Makefile
benchees/newsplit/Makefile
benchees/nr/Makefile
benchees/numutils/Makefile
benchees/ooura/Makefile
benchees/pocketfft/Makefile
benchees/pocketfft_cxx/Makefile
benchees/qft/Makefile
benchees/ransom/Makefile
benchees/rmayer/Makefile
benchees/scimark2c/Makefile
benchees/sciport/Makefile
benchees/sgimath/Makefile
benchees/singleton/Makefile
benchees/sorensen/Makefile
benchees/spiral-fft/Makefile
benchees/statlib/Makefile
benchees/sunperf/Makefile
benchees/temperton/Makefile
benchees/teneyck/Makefile
benchees/valkenburg/Makefile
benchees/vbigdsp/Makefile
benchees/vdsp/Makefile

])

cat <<EOF
*******************************************************************************
		    Optional FFT libraries Found:

                                       DXML/CXML (Alpha only): ${have_dxml-no}
                                    HP MLIB (PA-RISC/Itanium): ${have_mlib-no}
                         Sun Performance Library (SPARC only): ${have_sunperf-no}
                                      sgimath (SGI/MIPS only): ${have_sgimath-no}
                                           ESSL (IBM/PowerPC): ${have_essl-no}
                                  Apple VDSP (Macintosh only): ${have_vdsp-no}

                               NAG (proprietary, www.nag.com): ${have_nag-no}
                              IMSL (proprietary, www.vni.com): ${have_imsl-no}
             Numerical Recipes in C (proprietary, www.nr.com): ${have_nrc-no}
       Numerical Recipes in Fortran (proprietary, www.nr.com): ${have_nrf-no}

      Intel MKL (gratis, www.intel.com/software/products/mkl): ${have_mkl-no}
                                   Intel MKL, DFTI interface : ${have_mkl_dfti-no}
                                          Intel IPPS (gratis): ${have_ipps-no}
                                    Intel IPPS em64t (gratis): ${have_ippsem64t-no}
                                   Intel IPPS 64 bit (gratis): ${have_ipps64-no}
                                            AMD ACML (gratis): ${have_acml-no}

                                FFTW 2.x (free, www.fftw.org): ${have_fftw2_all-no}
               FFTW 2.x single precision (free, www.fftw.org): ${have_sfftw2_all-no}
                                FFTW 3.x (free, www.fftw.org): ${have_fftw3_all-no}
               FFTW 3.x single precision (free, www.fftw.org): ${have_fftw3f_all-no}
  GNU Scientific Library (GSL) (free, sources.redhat.com/gsl): ${have_gsl-no}
                        FFMPEG (free, ffmpeg.sourceforge.net): ${have_ffmpeg-no}
*******************************************************************************
EOF
