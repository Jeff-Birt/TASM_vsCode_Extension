@echo off
REM Tell TASM where to find the correct table to use
REM We are using the standard 8085 table
set TASMTABS=..\..\TASM\tasm32\
REM Move up to the TASM 'install' directory 
REM call TASM with build args and source file name
@echo on
..\..\TASM\tasm32\tasm.exe -g0 -85 TEST.8085.asm
@echo off
del *.hex
ren *.obj *.hex
