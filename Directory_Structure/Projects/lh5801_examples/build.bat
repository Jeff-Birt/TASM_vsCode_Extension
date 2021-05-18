@echo off
REM Tell TASM where to find the correct table to use
REM We are using the lh5801 table
set TASMTABS=..\..\TASM\tasmTab\
REM Move up to the TASM 'install' directory 
REM call TASM with build args and source file name
@echo on
REM ..\..\TASM\tasm323\Tasm323.exe -g3 -x7 -5801 add2num.lh5801.asm
REM ..\..\TASM\tasm323\Tasm323.exe -g3 -x7 -5801 screenInvert.lh5801.asm
..\..\TASM\tasm323\Tasm323.exe -g3 -x7 -5801 blockInvert2.lh5801.asm
REM ..\..\TASM\tasm323\Tasm323.exe -g3 -x7 -5801 incA.lh5801.asm
@echo off
del *.bin
ren *.obj *.bin
