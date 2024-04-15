.model small
.stack 100h

.data
    prompt_msg db 'Enter a two-digit number: $'
    prime_msg db 'Prime number.$'
    composite_msg db 'Composite number.$'
    palindrome_msg db 'Palindrome number.$'
    not_palindrome_msg db 'Not a palindrome number.$'
    rep_mes db 'It is a repunit.$'
    not_rep db 'It is not a repunit.$'
    perfect_msg db 'Perfect number.$'
    deficient_msg db 'Deficient number.$'
    abundant_msg db 'Abundant number.$'
    zero_msg db 'Zero is not a Perfect,Deficient number or Abundant number.$'

.code
    mov ax, @data
    mov ds, ax

    ; Prompt the user to enter a two-digit number
    
    
    mov ah, 09h
    lea dx, prompt_msg
    int 21h

    ; Input the first digit
    
    
    mov ax, 0    ; clear ax
    mov ah, 01h
    int 21h
    sub al, 30h
    mov ah, 0    ; Clear AH
    mov bx, ax   ; Store the first digit (zero-extended) in BX

    ; Input the second digit
    
    
    mov ax, 0    ; clear ax
    mov ah, 01h
    int 21h
    sub al, 30h
    mov ah, 0    ; Clear AH
    mov cx, ax   ; Store the second digit (zero-extended) in CX

    ; Multiply the first digit by 10
    
    
    mov ax, bx  ; Move the first digit to AX
    mov dx, 10  ; Set DX to 10
    mul dx      ; Multiply AX by DX
    mov bx, ax  ; Store the result in BX

    ; Add the second digit
    
    
    add bx, cx   ; Result stored in BX

    ; Check if the number is 1 or 0
    cmp bx, 1
    jle composite_one  ; If the number is 1, it's composite_one

    ; Check if the number is prime
    
    mov cx, 0         ; Initialize divisor count
    mov si, 1  
    mov dx, 0  

check_next_divisor:
    mov ax, bx
    cmp si, ax
    jg check_divisor_result
    mov dx, 0                ; Clear DX for division
    div si  
    cmp dx, 0                ; Check for remainder
    je divisible  
    inc si
    jmp check_next_divisor  

divisible:
    inc cx                    ; Increment divisor count
    inc si                    ; Move to next divisor
    jmp check_next_divisor

check_divisor_result:
    cmp cx, 2  
    jg composite  
    jmp prime                 ; If the divisor count is 2, it's prime

prime:
    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    
    
    ; Display message for prime number 
    
    mov ah, 09h
    lea dx, prime_msg
    int 21h
    jmp check_palindrome

composite:
    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    ; Display message for composite number
    mov ah, 09h
    lea dx, composite_msg
    int 21h
    jmp check_palindrome

composite_one:
    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h 
    
    ; Display message for composite number 1
    
    mov ah, 09h
    lea dx, composite_msg
    int 21h
    jmp not_palindrome

check_palindrome: 

    ; Make a copy of the original number for comparison
    
    mov si, bx
    
    ; Reverse the digits of the number
    
    mov ax, bx      ; Move the original number to AX for processing
    mov bx, 0      ; Clear BX to initialize the reversed number to 0
    mov cx, 10      ; Set CX to 10 for the divisor

reverse_loop:
    mov dx, 0      ; Clear DX to avoid incorrect additions
    div cx          ; Divide AX by 10, quotient in AX, remainder in DX
    mov cx,0
    mov cx,ax
    mov ax,dx
    mov bx,10
    mul bx
    add ax,cx
    mov bx,ax

reverse_done:
    ; Compare the reversed number with the original number
    
    
    mov ax, si      ; Restore the original number to AX for comparison
    cmp ax, bx      ; Compare the original number (AX) with the reversed number (BX)
    je palindrome   ; If they are equal, the number is a palindrome
    jmp not_palindrome ; If not, the number is not a palindrome

palindrome:
    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    ; Display message for palindrome number
    
    mov ah, 09h
    lea dx, palindrome_msg
    int 21h
    jmp check_repunit

not_palindrome:
    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    ; Display message for not a palindrome number
    mov ah, 09h
    lea dx, not_palindrome_msg
    int 21h
    jmp check_repunit

check_repunit:
    ; Check if the number is a repunit 
    cmp bx, 01     
    je repunit

    cmp bx, 11
    je repunit

    jmp not_repunit

    
    
repunit:
    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    mov ah, 09h
    
    lea dx, rep_mes
    int 21h
    jmp ab_per_def:


not_repunit:

    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    mov ah, 09h
    
    lea dx, not_rep
    int 21h
    jmp ab_per_def:
    


ab_per_def:

    cmp si,00
    je zero
    mov cx, 1          ; Counter for divisors
    mov bx, 0          ; Sum of divisors

calculate_divisors:
    mov ax, si         ; Move the number to AX for division
    mov dx, 0          ; Clear DX for division
    cmp cx,ax
    je  classify_number
    div cx             ; Divide AX by CX, quotient in AX, remainder in DX
    cmp dx, 0          ; Check if the remainder is zero
    je add_to_sum
    inc cx             ; If remainder is zero, CX is a divisor
    jmp calculate_divisors   

add_to_sum:
    add bx, cx         ; Add divisor to the sum
    inc cx             ; Move to next divisor
    jmp calculate_divisors    

classify_number:
    cmp bx, si         ; Compare the sum of divisors with the number itself
    je perfect_number  ; If equal, it's a perfect number
    jl deficient_number ; If less, it's a deficient number
    jmp abundant_number ; If greater, it's an abundant number

perfect_number:

    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    
    mov ah, 09h
    lea dx, perfect_msg
    int 21h
    jmp exit_program

deficient_number:

    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    
    mov ah, 09h
    lea dx, deficient_msg
    int 21h
    jmp exit_program

abundant_number:

    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    
    mov ah, 09h
    lea dx, abundant_msg
    int 21h
    
    jmp exit_program

zero:

    mov ah, 2
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    
    mov ah, 09h
    lea dx, zero_msg
    int 21h
    
    jmp exit_program

exit_program:
    ; Exit the program
    mov ah, 4Ch
    int 21h

end          


