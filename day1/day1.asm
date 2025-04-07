section .data
    filename db "sample_data.txt", 0  ; Null-terminated filename string
    buffer_size equ 1024             ; Size of the buffer to read data into

section .bss
    buffer resb buffer_size          ; Reserve buffer space

section .text
    global _start

_start:
    ; === Open the file ===
    mov eax, 5          ; SYS_OPEN system call number (32-bit)
    mov ebx, filename   ; Pointer to the filename string
    mov ecx, 0          ; Flags: O_RDONLY (read-only)
    mov edx, 0          ; Mode (not needed for O_RDONLY)
    int 0x80            ; Invoke kernel (32-bit interrupt)
    mov esi, eax        ; Store the file descriptor returned by SYS_OPEN in ESI (using ESI as it's often preserved across calls)

    ; Check for errors during file opening
    cmp esi, 0
    jl _exit_error      ; If file descriptor < 0, jump to error exit

read_loop:
    ; === Read from the file ===
    mov eax, 3          ; SYS_READ system call number (32-bit)
    mov ebx, esi        ; File descriptor from ESI
    mov ecx, buffer     ; Pointer to the buffer
    mov edx, buffer_size ; Number of bytes to read
    int 0x80            ; Invoke kernel
    mov edi, eax        ; Store the number of bytes read in EDI

    ; Check for read errors or end of file
    cmp edi, 0
    jle _close_file     ; If bytes read <= 0, jump to close file (EOF or error)

    ; === Write to standard output ===
    mov eax, 4          ; SYS_WRITE system call number (32-bit)
    mov ebx, 1          ; File descriptor for STDOUT
    mov ecx, buffer     ; Pointer to the buffer containing data to write
    mov edx, edi        ; Number of bytes to write (bytes actually read)
    int 0x80            ; Invoke kernel

    ; Check for write errors
    cmp eax, 0
    jl _exit_error      ; If bytes written < 0, jump to error exit

    jmp read_loop       ; Jump back to read more data

_close_file:
    ; === Close the file ===
    mov eax, 6          ; SYS_CLOSE system call number (32-bit)
    mov ebx, esi        ; File descriptor to close
    int 0x80            ; Invoke kernel

    ; Check for close errors (optional, often ignored)
    ; cmp eax, 0
    ; jl _exit_error

    ; === Exit the program gracefully ===
    mov eax, 1          ; SYS_EXIT system call number (32-bit)
    xor ebx, ebx        ; Exit code 0 (success)
    int 0x80            ; Invoke kernel

_exit_error:
    ; === Exit with an error code ===
    mov eax, 1          ; SYS_EXIT system call number (32-bit)
    mov ebx, 1          ; Exit code 1 (failure)
    int 0x80            ; Invoke kernel
