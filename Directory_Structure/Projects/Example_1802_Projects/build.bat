@echo off
REM Tell TASM where to find the correct table to use
REM We are using the 1802 table
set TASMTABS=..\..\TASM\tasmTab\
REM Move up to the TASM 'install' directory 
REM call TASM with build args and source file name
@echo on
..\..\TASM\tasm32\tasm.exe -g0 -1802 QBlink.1802.asm
@echo off
del *.hex
ren *.obj *.hex
