@ECHO OFF
del "c:\documents and settings\student.auth-fcfdbfa769\desktop\labb1\labb1.map"
del "c:\documents and settings\student.auth-fcfdbfa769\desktop\labb1\labels.tmp"
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\documents and settings\student.auth-fcfdbfa769\desktop\labb1\labels.tmp" -fI  -o "c:\documents and settings\student.auth-fcfdbfa769\desktop\labb1\labb1.hex" -d "c:\documents and settings\student.auth-fcfdbfa769\desktop\labb1\labb1.obj" -e "c:\documents and settings\student.auth-fcfdbfa769\desktop\labb1\labb1.eep" -m "c:\documents and settings\student.auth-fcfdbfa769\desktop\labb1\labb1.map" -W+ie   "C:\Documents and Settings\student.AUTH-FCFDBFA769\Desktop\labB1\labB1.asm"
