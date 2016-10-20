@ECHO OFF
del "c:\documents and settings\student.auth-fcfdbfa769\desktop\laba3\laba3.map"
del "c:\documents and settings\student.auth-fcfdbfa769\desktop\laba3\labels.tmp"
"C:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "c:\documents and settings\student.auth-fcfdbfa769\desktop\laba3\labels.tmp" -fI  -o "c:\documents and settings\student.auth-fcfdbfa769\desktop\laba3\laba3.hex" -d "c:\documents and settings\student.auth-fcfdbfa769\desktop\laba3\laba3.obj" -e "c:\documents and settings\student.auth-fcfdbfa769\desktop\laba3\laba3.eep" -m "c:\documents and settings\student.auth-fcfdbfa769\desktop\laba3\laba3.map" -W+ie   "C:\Documents and Settings\student.AUTH-FCFDBFA769\Desktop\labA3\labA3.asm"
