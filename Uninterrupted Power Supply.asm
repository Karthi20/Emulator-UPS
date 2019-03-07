include 'emu8086.inc'
org 100h
.data
fan dw ?
light dw ?
motor dw ?
power dw 0
lightc dw 50
fanc dw 50
motorc dw 50
f2 dw ?
l2 dw ?
m2 dw ?
t2 dw ?
rem dw ?
qua dw ?  
q db ?
.code
define_pthis
define_print_num
define_print_num_uns
define_scan_num
define_clear_screen
mov ax,@data
mov ds,ax


call pthis
db 10,13,"Uninterrupted Power Supply System",0
main:
call pthis
db 10,13,"The total capacity of the invertor is fixed to be 500W",0

call PTHIS
db 10,13,"Enter the Number of Fan : ",0
call SCAN_NUM
mov fan,cx
mov ax,fanc
mul cx
mov f2,ax
call PTHIS
db 10,13,"Enter the Number of Light : ",0

call SCAN_NUM
mov light,cx
mov ax,lightc
mul cx
mov l2,ax
call pthis
db 10,13,"Enter the Number of Motor : ",0

call SCAN_NUM
mov motor,cx
mov ax,motorc
mul cx
mov m2,ax

mov ax,f2
mov bx,l2
add ax,bx
mov bx,m2
add ax,bx
mov t2,ax

cmp t2,500
jge wrg


currenton:
cmp power,500
jge full
;call CLEAR_SCREEN
call PTHIS
db 10,13,"UPS is charging",0
add power,50
mov ax,power
call print_num
mov AH,01h
int 16h
jne currentofff
jmp currenton


full:
call PTHIS 
db 10,13,"UPS charge is full",0


currentofff:
call SCAN_NUM

currentoff: 
cmp power,0
je dead

call PTHIS
db 10,13,"UPS is on",0 
xor dx,dx
mov ah,2
mov dl,07h
int 21h
 

;f,l,m
mov ax,power
mov bx,t2
xor dx,dx
div bx
mov qua,ax
cmp ax,1
jl nott
mov dh,00
mov rem,dx
call pthis
db 10,13,"Duration that the given inputs can run is : ",0
mov ax,qua
call print_num
call pthis
db ".",0  
mov ax,dx
call print_num
call pthis
db "hrs",0
;mov AH,01h
;int 16h
;jne currentonn:
;jmp currentoff 

dead:
call PTHIS 
db 10,13,"UPS charge dead",0
jmp exit

exit:
hlt

nott:
call pthis
db 10,13,"Given inputs are greater than the available power in UPS",0
jmp main

;currentonn:
;call scan_num
;jmp currenton   


wrg:
call pthis
db 10,13,"The quantity of fans,lights and motors you have entered exceeded the limit(500 W)",0
jmp main