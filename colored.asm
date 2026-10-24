.model small
.stack 100h

.data

banner db 13,10,'====================================',13,10
       db '      CUSTOM DOS COMMAND LINE',13,10
       db '====================================',13,10,'$'

prompt db 13,10,'DOS> $'

; ---------------- COMMANDS ----------------
helloCmd   db 'HELLO','$'
helpCmd    db 'HELP','$'
exitCmd    db 'EXIT','$'
clearCmd   db 'CLEAR','$'
clsCmd     db 'CLS','$'
dateCmd    db 'DATE','$'
timeCmd    db 'TIME','$'
verCmd     db 'VERSION','$'
aboutCmd   db 'ABOUT','$'
echoCmd    db 'ECHO','$'
dirCmd     db 'DIR','$'
pingCmd    db 'PING','$'
upperCmd   db 'UPPER','$'
lowerCmd   db 'LOWER','$'
repeatCmd  db 'REPEAT','$'
lenCmd     db 'LENGTH','$'
treeCmd    db 'TREE','$'
rebootCmd  db 'REBOOT','$'
sysCmd     db 'SYSINFO','$'
exit2Cmd   db 'SHUTDOWN','$'

; ---------------- MESSAGES ----------------

msgHello db 13,10,'Welcome User!$'

msgHelp db 13,10,'Available Commands:',13,10
        db 'HELLO    - Greeting',13,10
        db 'HELP     - Commands list',13,10
        db 'CLEAR/CLS- Clear screen and set themes',13,10
        db 'DATE     - Show live system date',13,10
        db 'TIME     - Show live system time',13,10
        db 'VERSION  - Version info',13,10
        db 'ABOUT    - Project info',13,10
        db 'ECHO [tx]- Print text back',13,10
        db 'DIR      - Mock directory storage listing',13,10
        db 'PING     - Animated real-time delay loop',13,10
        db 'UPPER [tx]- Convert text to UPPERCASE',13,10
        db 'LOWER [tx]- Convert text to lowercase',13,10
        db 'REPEAT[tx]- Loop render your text argument twice',13,10
        db 'LENGTH[tx]- Compute accurate character count',13,10
        db 'TREE     - Directory tree structure',13,10
        db 'REBOOT   - Hardware BIOS CPU reset execution',13,10
        db 'SYSINFO  - Academic & System specs',13,10
        db 'SHUTDOWN - Exit system',13,10
        db 'EXIT     - Quit',13,10,'$'

msgInvalid db 13,10,'Invalid Command! (Type HELP for list)$'
msgVersion db 13,10,'DOS CLI Version 6.0 Color-Edition$'

msgAbout db 13,10
         db '------------------------------------',13,10
         db 'COAL PROJECT: CUSTOM DOS COMMAND LINE',13,10
         db '------------------------------------',13,10
         db 'This project is written in 8086 Assembly',13,10
         db 'using DOS interrupts (INT 21h). It simulates',13,10
         db 'a command-line shell with 20 commands.',13,10
         db 'It demonstrates command parsing, string handling',13,10
         db 'and system interrupt usage.',13,10
         db '------------------------------------',13,10,'$'

msgDir db 13,10,' Volume in drive C has no label.'
       db 13,10,' Directory of C:\COAL\PROJECT'
       db 13,10,13,10
       db ' .              <DIR>     05-27-2026   5:30p',13,10
       db ' ..             <DIR>     05-27-2026   5:30p',13,10
       db ' MAIN     ASM      14,245 05-27-2026   5:28p',13,10
       db ' MAIN     OBJ       4,112 05-27-2026   5:29p',13,10
       db ' MAIN     EXE      11,520 05-27-2026   5:30p',13,10
       db ' README   TXT       1,024 05-27-2026   1:15p',13,10
       db '         4 File(s)         30,901 bytes',13,10
       db '         2 Dir(s)      64,124,928 bytes free',13,10,'$'

msgPing1     db 13,10,'Pinging 127.0.0.1 with 32 bytes of data:',13,10,'$'
msgPingReply db 'Reply from 127.0.0.1: bytes=32 time=4ms TTL=128',13,10,'$'
msgTree      db 13,10,'ROOT',13,10,' |-- SYSTEM',13,10,' |-- USER',13,10,'$'

msgSys db 13,10,'===================================='
       db 13,10,'         SYSTEM INFORMATION         '
       db 13,10,'===================================='
       db 13,10,'OS MODE    : 16-Bit DOS Real Mode'
       db 13,10,'CPU ARCH   : Intel 8086 Emulation'
       db 13,10,'BASE RAM   : 640 KB'
       db 13,10,'------------------------------------'
       db 13,10,'PROJECT    : COAL Final Project'
       db 13,10,'ACADEMICS  : 4th Semester'
       db 13,10,'INSTRUCTORS: Sir Ghazanfar Ali'
       db 13,10,'             Maam Rimsha Tanveer'
       db 13,10,'====================================',13,10,'$'

msgReboot   db 13,10,'Triggering hardware interrupt reset vector...$'
msgShutdown db 13,10,'System shutting down...$'

msgDatePrefix db 13,10,'Current Date: ','$'
msgTimePrefix db 13,10,'Current Time: ','$'
msgLenPrefix  db 13,10,'Argument Length: ','$'

input db 50            
      db ?
      db 52 dup(0) 

cmdFlag db 0
argPtr  dw 0           

.code

main PROC
mov ax,@data
mov ds,ax
mov es,ax 

; Clear screen to Blue Background with Light Cyan Text first
call ClearScreenColor

mov dx,OFFSET banner
mov ah,09h
int 21h

mainLoop:
    ; Print the "DOS>" prompt in flashing/bright Yellow
    mov dx, OFFSET prompt
    mov bl, 0Eh          ; 0 = Black Background, Eh = Bright Yellow Text
    call PrintColorString

    ; Read user input
    mov dx,OFFSET input
    mov ah,0Ah
    int 21h

    ; Terminate string properly for DOS printing tools
    mov bl,input+1
    xor bh,bh
    mov byte ptr [input+2+bx],13
    mov byte ptr [input+3+bx],'$'   

    ; uppercase conversion ONLY for the command keyword
    mov si,OFFSET input+2

convKeyword:
    mov al,[si]
    cmp al,13
    je dispatch
    cmp al,' '
    je dispatch

    cmp al,'a'
    jb skipK
    cmp al,'z'
    ja skipK
    sub byte ptr [si],32

skipK:
    inc si
    jmp convKeyword

; ---------------- COMMAND MATCH ----------------

dispatch:
mov cmdFlag,0

mov si,OFFSET input+2
mov di,OFFSET helloCmd
call compare
cmp al,1
jne c2
mov cmdFlag,1
jmp execute
c2:

mov si,OFFSET input+2
mov di,OFFSET helpCmd
call compare
cmp al,1
jne c3
mov cmdFlag,2
jmp execute
c3:

mov si,OFFSET input+2
mov di,OFFSET clearCmd
call compare
cmp al,1
jne c4
mov cmdFlag,3
jmp execute
c4:

mov si,OFFSET input+2
mov di,OFFSET clsCmd
call compare
cmp al,1
jne c5
mov cmdFlag,4
jmp execute
c5:

mov si,OFFSET input+2
mov di,OFFSET dateCmd
call compare
cmp al,1
jne c6
mov cmdFlag,5
jmp execute
c6:

mov si,OFFSET input+2
mov di,OFFSET timeCmd
call compare
cmp al,1
jne c7
mov cmdFlag,6
jmp execute
c7:

mov si,OFFSET input+2
mov di,OFFSET verCmd
call compare
cmp al,1
jne c8
mov cmdFlag,7
jmp execute
c8:

mov si,OFFSET input+2
mov di,OFFSET aboutCmd
call compare
cmp al,1
jne c9
mov cmdFlag,8
jmp execute
c9:

mov si,OFFSET input+2
mov di,OFFSET echoCmd
call compare
cmp al,1
jne c10
mov cmdFlag,9
jmp execute
c10:

mov si,OFFSET input+2
mov di,OFFSET dirCmd
call compare
cmp al,1
jne c11
mov cmdFlag,10
jmp execute
c11:

mov si,OFFSET input+2
mov di,OFFSET pingCmd
call compare
cmp al,1
jne c12
mov cmdFlag,11
jmp execute
c12:

mov si,OFFSET input+2
mov di,OFFSET upperCmd
call compare
cmp al,1
jne c13
mov cmdFlag,12
jmp execute
c13:

mov si,OFFSET input+2
mov di,OFFSET lowerCmd
call compare
cmp al,1
jne c14
mov cmdFlag,13
jmp execute
c14:

mov si,OFFSET input+2
mov di,OFFSET repeatCmd
call compare
cmp al,1
jne c15
mov cmdFlag,14
jmp execute
c15:

mov si,OFFSET input+2
mov di,OFFSET lenCmd
call compare
cmp al,1
jne c16
mov cmdFlag,15
jmp execute
c16:

mov si,OFFSET input+2
mov di,OFFSET treeCmd
call compare
cmp al,1
jne c17
mov cmdFlag,16
jmp execute
c17:

mov si,OFFSET input+2
mov di,OFFSET rebootCmd
call compare
cmp al,1
jne c18
mov cmdFlag,17
jmp execute
c18:

mov si,OFFSET input+2
mov di,OFFSET sysCmd
call compare
cmp al,1
jne c19
mov cmdFlag,18
jmp execute
c19:

mov si,OFFSET input+2
mov di,OFFSET exit2Cmd
call compare
cmp al,1
jne c20
mov cmdFlag,19
jmp execute
c20:

mov si,OFFSET input+2
mov di,OFFSET exitCmd
call compare
cmp al,1
jne invalidCmd
mov cmdFlag,20
jmp execute

invalidCmd:
    ; Print errors in Red text
    mov dx,OFFSET msgInvalid
    mov bl, 0Ch          ; 0 = Black Background, Ch = Light Red text
    call PrintColorString
    jmp mainLoop

; ---------------- EXECUTION DECODER ----------------

execute:
cmp cmdFlag,1
jne e2
jmp doHello
e2:
cmp cmdFlag,2
jne e3
jmp doHelp
e3:
cmp cmdFlag,3
jne e4
jmp doClear
e4:
cmp cmdFlag,4
jne e5
jmp doCls
e5:
cmp cmdFlag,5
jne e6
jmp doDate
e6:
cmp cmdFlag,6
jne e7
jmp doTime
e7:
cmp cmdFlag,7
jne e8
jmp doVersion
e8:
cmp cmdFlag,8
jne e9
jmp doAbout
e9:
cmp cmdFlag,9
jne e10
jmp doEcho
e10:
cmp cmdFlag,10
jne e11
jmp doDir
e11:
cmp cmdFlag,11
jne e12
jmp doPing
e12:
cmp cmdFlag,12
jne e13
jmp doUpper
e13:
cmp cmdFlag,13
jne e14
jmp doLower
e14:
cmp cmdFlag,14
jne e15
jmp doRepeat
e15:
cmp cmdFlag,15
jne e16
jmp doLen
e16:
cmp cmdFlag,16
jne e17
jmp doTree
e17:
cmp cmdFlag,17
jne e18
jmp doReboot
e18:
cmp cmdFlag,18
jne e19
jmp doSys
e19:
cmp cmdFlag,19
jne e20
jmp doShutdown
e20:
jmp doExit

; ---------------- FUNCTIONS ----------------

doHello:
    mov dx,OFFSET msgHello
    mov bl, 0Ah          ; Light Green
    call PrintColorString
    jmp mainLoop

doHelp:
    mov dx,OFFSET msgHelp
    mov bl, 0Bh          ; Light Cyan
    call PrintColorString
    jmp mainLoop

doClear:
doCls:
    call ClearScreenColor
    mov dx,OFFSET banner
    mov ah,09h
    int 21h
    jmp mainLoop

doDate:
    mov dx, OFFSET msgDatePrefix
    mov bl, 0Fh          ; Bright White
    call PrintColorString

    mov ah, 2Ah
    int 21h
    push cx 
    push dx 

    pop dx
    push dx         
    mov al, dl      
    xor ah, ah
    call PrintTwoDigits

    mov ah, 02h
    mov dl, '/'
    int 21h

    pop dx          
    mov al, dh      
    xor ah, ah
    call PrintTwoDigits

    mov ah, 02h
    mov dl, '/'
    int 21h

    pop ax          
    call PrintYear
    jmp mainLoop

doTime:
    mov dx, OFFSET msgTimePrefix
    mov bl, 0Fh          ; Bright White
    call PrintColorString

    mov ah, 2Ch
    int 21h
    push dx 
    push cx 

    pop cx
    push cx         
    mov al, ch      
    xor ah, ah
    call PrintTwoDigits

    mov ah, 02h
    mov dl, ':'
    int 21h

    pop cx          
    mov al, cl      
    xor ah, ah
    call PrintTwoDigits

    mov ah, 02h
    mov dl, ':'
    int 21h

    pop dx          
    mov al, dh      
    xor ah, ah
    call PrintTwoDigits
    jmp mainLoop

doVersion:
    mov dx,OFFSET msgVersion
    mov bl, 0Eh          ; Yellow
    call PrintColorString
    jmp mainLoop

doAbout:
    mov dx,OFFSET msgAbout
    mov bl, 0Fh          ; White
    call PrintColorString
    jmp mainLoop

doEcho:
    call PrintNewLine
    mov si, argPtr
    mov al, [si]
    cmp al, 13          
    je echoDone
    
    mov dx, si
    mov bl, 0Fh          ; White output text
    call PrintColorString
echoDone:
    jmp mainLoop

doDir:
    mov dx,OFFSET msgDir
    mov bl, 07h          ; Standard Light Gray
    call PrintColorString
    jmp mainLoop

doPing:
    mov dx, OFFSET msgPing1
    mov bl, 0Fh
    call PrintColorString
    
    mov cx, 3           
pingLoop:
    push cx
    call DelayLoop      
    mov dx, OFFSET msgPingReply
    mov bl, 0Ah          ; Reply looks successful in Green!
    call PrintColorString
    pop cx
    loop pingLoop
    jmp mainLoop

doUpper:
    call PrintNewLine
    mov si, argPtr
upperLoop:
    mov al, [si]
    cmp al, 13
    je printUpper
    cmp al, 'a'
    jb nextUpper
    cmp al, 'z'
    ja nextUpper
    sub byte ptr [si], 32
nextUpper:
    inc si
    jmp upperLoop
printUpper:
    mov dx, argPtr
    mov bl, 0Fh
    call PrintColorString
    jmp mainLoop

doLower:
    call PrintNewLine
    mov si, argPtr
lowerLoop:
    mov al, [si]
    cmp al, 13
    je printLower
    cmp al, 'A'
    jb nextLower
    cmp al, 'Z'
    ja nextLower
    add byte ptr [si], 32
nextLower:
    inc si
    jmp lowerLoop
printLower:
    mov dx, argPtr
    mov bl, 0Fh
    call PrintColorString
    jmp mainLoop

doRepeat:
    call PrintNewLine
    mov si, argPtr
    cmp byte ptr [si], 13
    je repeatDone
    
    mov dx, si
    mov bl, 0Fh
    call PrintColorString
    
    call PrintNewLine
    mov dx, argPtr
    mov bl, 0Fh
    call PrintColorString
repeatDone:
    jmp mainLoop

doLen:
    mov dx, OFFSET msgLenPrefix
    mov bl, 0Fh
    call PrintColorString
    
    mov si, argPtr
    xor cx, cx          
countLoop:
    mov al, [si]
    cmp al, 13          
    je printLen
    inc cx              
    inc si
    jmp countLoop
printLen:
    mov ax, cx
    call PrintYear      
    jmp mainLoop

doTree:
    mov dx,OFFSET msgTree
    mov bl, 03h          ; Cyan branch look
    call PrintColorString
    jmp mainLoop

doReboot:
    mov dx, OFFSET msgReboot
    mov bl, 0Ch          ; Warning Red
    call PrintColorString
    call DelayLoop
    mov ax, 0FFFFh
    push ax
    mov ax, 0
    push ax
    retf                

doSys:
    mov dx,OFFSET msgSys
    mov bl, 0Bh          ; Clean Academic cyan
    call PrintColorString
    jmp mainLoop

doShutdown:
    mov dx,OFFSET msgShutdown
    mov bl, 0Ch
    call PrintColorString
    jmp mainLoop

doExit:
    mov ah,4Ch
    int 21h

main ENDP

; ---------------- UTILITY ROUTINES ----------------

; Custom routine to write text strings matching custom color hex codes
PrintColorString PROC
    mov si, dx
char_loop:
    mov al, [si]
    cmp al, '$'
    je string_done
    
    ; If it's control carriage adjustments, do basic interrupt processing
    cmp al, 13
    je literal_print
    cmp al, 10
    je literal_print

    ; Write Character and Attribute
    mov ah, 09h
    mov bh, 0            ; Display Page 0
    mov cx, 1            ; Write character exactly 1 time
    int 10h
    
literal_print:
    ; Progress terminal cursor forward safely
    mov ah, 02h
    mov dl, al
    int 21h
    
    inc si
    jmp char_loop
string_done:
    ret
PrintColorString ENDP

; Standard Background Clear: Colors screen completely to Retro Blue (1h) with Cyan text (Bh)
ClearScreenColor PROC
    mov ah, 06h          ; Scroll up function
    mov al, 0            ; Clear full window
    mov bh, 1Bh          ; 1 = Blue Background, B = Light Cyan Text
    mov ch, 0            ; Top Row
    mov cl, 0            ; Left Column
    mov dh, 24           ; Bottom Row
    mov dl, 79           ; Right Column
    int 10h
    
    ; Reset cursor pointer safely to coordinates 0,0
    mov ah, 02h
    mov bh, 0
    mov dh, 0
    mov dl, 0
    int 10h
    ret
ClearScreenColor ENDP

PrintTwoDigits PROC
    mov bl, 10
    div bl          
    mov cx, ax      
    
    mov ah, 02h
    mov dl, cl
    add dl, '0'     
    int 21h
    
    mov ah, 02h
    mov dl, ch
    add dl, '0'     
    int 21h
    ret
PrintTwoDigits ENDP

PrintYear PROC
    mov cx, 0       
    mov bx, 10      

divide_loop:
    xor dx, dx      
    div bx          
    push dx         
    inc cx          
    cmp ax, 0
    jne divide_loop

print_loop:
    pop dx          
    add dl, '0'     
    mov ah, 02h
    int 21h         
    loop print_loop
    ret
PrintYear ENDP

PrintNewLine PROC
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    ret
PrintNewLine ENDP

DelayLoop PROC
    mov cx, 000Fh
outerLoop:
    push cx
    mov cx, 0FFFFh
innerLoop:
    nop                 
    loop innerLoop
    pop cx
    loop outerLoop
    ret
DelayLoop ENDP

; ---------------- COMPILER REGISTER STACK PARSER ----------------

compare PROC
again:
    mov bl, [di]    
    mov bh, [si]    

    cmp bl, '$'     
    je check_input_end

    cmp bh, 13      
    je fail
    cmp bh, ' '     
    je check_input_end

    cmp bh, bl      
    jne fail

    inc si
    inc di
    jmp again

check_input_end:
    cmp bh, ' '     
    je skip_spaces
    cmp bh, 13      
    je match_ok
    jmp fail

skip_spaces:
    inc si
    mov bh, [si]
    cmp bh, ' '     
    je skip_spaces
    mov argPtr, si   
    jmp success

match_ok:
    mov argPtr, si   

success:
    mov al, 1
    ret

fail:
    mov al, 0
    ret
compare ENDP

END main