@echo off
REM Tell TASM where to find the correct table to use
REM We are using the standard 6502 table
set TASMTABS=..\..\TASM\tasm32\
REM Move up to the TASM 'install' directory 
REM call TASM with build args and source file name
REM '-c' contigious file, 'g3' binary output, '-65' 6502 table
@echo on
..\..\TASM\tasm32\tasm.exe -c -g3 -65 hello.6502.asm
@echo off
REM Delete any existing .prg files and rename the .obj file
REM TASM built to .prg
del *.prg
ren *.obj *.prg
REM can autoload in VICE, "pathtovice" is your path to VICE
REM pathtovice\x64sc hello.prg
