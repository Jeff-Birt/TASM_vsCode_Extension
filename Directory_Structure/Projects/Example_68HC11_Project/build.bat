@echo off
REM Tell TASM where to find the correct table to use
REM We are using the standard Motorola 68xx table with 68HC11 extensions
set TASMTABS=..\..\TASM\tasm32\
REM Move up to the TASM 'install' directory 
REM call TASM with build args and source file name
REM '-g2' Motorola hex (.s19) output, '-68' 6800 table, '-x7' 68HC11 extensions
@echo on
..\..\TASM\tasm32\tasm.exe -g2 -68 -x7 keypad6.68XX.asm
@echo off
REM delete any existing .s19 files, rename TASM obj output to .s19
del *.s19
ren *.obj *.s19
