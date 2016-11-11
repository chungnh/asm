.model small
.stack 100h
.data
    msg1 db 10, 13, 'nhap so thu 1: $'
    msg2 db 10, 13, 'nhap so thu 2 : $'
    msg3 db 10, 13, 'ket qua: $'
    msg4 db 'tran roi $'
    x dw ?
    y dw ?
.code
main proc
    mov ax, @data
    mov ds, ax

    ;yc nhap so thu 1
    lea dx, msg1
    mov ah, 9
    int 21h
    ;nhap so thu 1
    call input
    mov x, ax
    ;yc nhap so thu 2
    lea dx, msg2
    mov ah, 9
    int 21h
    ;nhap so thu 2
    call input
    mov y, ax
    ;tb tong
    lea dx, msg3
    mov ah, 9
    int 21h
    mov ax, x
    mov bx, y
    call sum
    call show

    loop main

input proc
    xor bx, bx
    xor cx, cx

    mov ah, 1
    int 21h
    cmp al, '-'
    je am
    jmp duong
am:
    mov cx, 1
    jmp q
duong:
    mov cx, 0
    jmp continue
    q:
    int 21h

continue:    
    cmp al, 30h
    jae cmp39h
cmp39h:
    cmp al, 39h
    jbe ok
    
    wrong:
    MOV AH, 2
    MOV DX, 8
    INT 21H
    MOV DX, 0
    INT 21H
    MOV DX, 8
    INT 21H 
    MOV AH, 1
    jmp e
    wrong_end:
    ok:
    and ax, 000fh
    push ax
    mov ax, 10
    mul bx ;ket qua luu o ax, ax =  bx*10
    jc tran
    mov bx, ax
    pop ax
    add bx, ax ;bx = bx*10+ax
    jc tran; 65536
    mov ah, 1    
    e:
    int 21h
    cmp al, 0dh; =13
    jne continue
    mov ax, bx
    cmp cx, 0
    je return
    neg ax
return:
    ret
input endp

sum proc
    add ax, bx
    jo tran
    ret
sum endp

show proc
    cmp ax, 0
    jge convert
    push ax
    mov dl, '-'
    mov ah, 2
    int 21h
    pop ax
    neg ax

convert:
    xor cx, cx
    mov bx, 10
chia:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne chia
    mov ah, 2
hien:
    pop dx
    or dl, 30h
    int 21h
    loop hien
    ret
show endp

tran proc
    lea dx, msg4
    mov ah, 9
    int 21h
    call main    
tran endp
end main