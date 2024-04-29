[org 0x100]
jmp start 

player_name_msg: db 'Player Name:         ' 
player_name_len: dw 29

player_score: db 'Player Score: 0               '
player_score_len: dw 29

total_moves_msg: db 'Total Moves: 15                '
total_moves_msg_len: dw 29

player_moves_msg: db ' Remaining moves: 15          '
player_moves_len: dw 29

pattern1: db '-'
pattern2: db '|'
pattern3: db ' '


; making the grid at the start and initializing the grid with 12x12 (144) entries of 0 (empty)

grid: dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

box1_selected: dw 0
box2_selected: dw 0

t1: dw 0

t2: dw 0

t3: dw 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; co ordinates of the first and second mouse click

x1: dw 0
y1: dw 0
x2: dw 0
y2: dw 0

isSelected: dw 0 ; checking if the box is isSelected or not

flagax: dw 0 ; checking if a certain action has taken place or not

total_moves_allowed: dw 15 ; total moves allowed
total_score_beginning: dw 0 ; total total_score_beginning at the beginning

name_input_msg: db 'Please enter your name: '
name_input_len: dw 24

size_input_msg: db 'Please enter board size: '
size_input_len: dw 25

var1: times 100 db '$';  creating a a continous memory allocation with each element as $

length: dw 0

rx: dw 0
ry: dw 0

red_flag: dw 0
board_size: dw 6

x_limit1: dw 0 ;; 49 cells OR 98 bytes for 12x12
jump_next_line_i: dw 0 ; adding 62 for 12x12 initializing board function

jump_next_line_1: dw 0; adding 222 for fillilng spaces (12x12)

jump_next_line_2: dw 0 ; adding 224 for print_board function (12x12)

y_limit1: dw 0

print_limit1: dw 0 ; comparing 3860

total_characters: dw 0 ; bytes (for a board of 12 x 12, it would be equal to 144 x 2 = 288)

board_size_word: dw 0

array_length: dw 0 ; (0 --> 143 for 12x12)

avoid_last_line: dw 0

avoid_2nd_last_line: dw 0

down_character_check: dw 0

intro_msg: db 'CHARACTER MATCH GAME' ; string to be printed at the introduction of the GAME

intro_msg_len: dw 20
x_intro_msg: dw 30
y_intro_msg: dw 12

bomb_flag: dw 0 ; flag to check if bomb present

bomb_blast: dw 0 ; flag to check if bomb bomb_blast

blast_chracter: dw 0 ; flag to check if bomb has blasted the character

long_space: db '                              ' ; long space

long_space_length: dw 30

game_over_msg: db 'GAME OVER' ; message for the game end screen
game_over_msg_len: dw 9 ; len of game_over_msg


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;; Subroutines;;;;;;;;;;;;;;;;;;;;;;;;

board_values_loader:

push dx
push bx
push ax

mov dx, [board_size]
shl dx, 2
add dx, 1
mov word[x_limit1], dx

shl dx, 1
mov bx, 160
sub bx, dx

mov word[jump_next_line_i], bx
add bx, 160

mov word[jump_next_line_1], bx
add bx, 2

mov word[jump_next_line_2], bx

mov bx, [board_size]
shl bx, 1
mov word[down_character_check], bx

mov ax, [total_characters]
sub ax, bx
mov word[avoid_last_line], ax
sub ax, bx
mov word[avoid_2nd_last_line], ax

mov ax, 0
mov al, 160
mul bx
add ax, 20
mov word[print_limit1], ax

mov bx, [board_size]
mov ax, 0
mov al, bl
mul bx
sub ax, 1
mov word[array_length], ax
add ax, 1
shl ax, 1
mov word[total_characters], ax ; total character in bytes i.e. characters x 2

pop ax
pop bx
pop dx
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hurdles_check:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push si
push di

mov si, 0 ; counter / iterator
mov dx, 0 ; count of the total checks
mov bx, 0
mov cx, 0 ; horizontal index

checker:
mov bx, grid
add bx, si
add cx, 1

cmp word[bx], 0xB058
jnz no_checker

_right:
cmp cx, [board_size]
jae no_right
cmp word[bx+2], 0x1120
jnz _left
mov word[bx], 0x1120
jmp no_checker

no_right:
mov cx, 0

_left:
cmp cx, 1
jz _up
cmp word[bx-2], 0x1120
jnz _up
mov word[bx], 0x1120
jmp no_checker

_up:
mov ax, [board_size]
shl ax, 1
mov bp, ax
cmp si, ax
jb _down
cmp word[grid+si-24], 0x1120
jnz _down
mov word[bx], 0x1120
jmp no_checker

_down:
cmp si, [avoid_last_line]
jae no_checker
cmp word[grid+si+bp], 0x1120
jnz no_checker
mov word[bx], 0x1120

no_checker:
cmp cx, [board_size]
jb yes_right
mov cx, 0

yes_right:
add si, 2
inc dx
cmp dx, [array_length] ; checking if the amount of total checks are completed
jb checker ; if all checks are not done than repeat

pop di
pop si
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

remove_red_highlight:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push si
push di

mov ax, 0xb800
mov es, ax ; pointing es to video base
mov di, 160 ; starting index for printing
mov cx, 0 ; initializing the counter for 49 characters

next_char:
add di, 2
inc cx
cmp cx, [x_limit1]
je next_liner

; adding 3 blank spaces

mov ah, 0x11
mov al, 0x7C ; load next char of the string
mov [es:di], ax ; show this char on the screen
add di, 2 ; move to next screen location
inc cx
mov al, 0x7C
mov [es:di], ax
add di, 2
inc cx
mov ax, 0x7C
mov [es:di], ax
add di, 2
inc cx
jmp next_char

; jumping to the next line afte leaving the right side black
next_liner:
mov cx, 0
add di, [jump_next_line_1]
cmp di, [print_limit1] ; end it at line # 24
jl next_char

pop di
pop si
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;input of the user name
user_name: 
push bp
mov bp, sp
push es
push ax
push bx
push cx
push si 
push di

mov ax, 0xb800
mov es, ax
mov di, 980 ; starting index for screen printing
mov cx, 0 ; counter
mov si, name_input_msg

mov ah, 0x03
next_char_username:
mov al, [si]
mov [es:di], ax
add di, 2
inc si
inc cx
cmp cx, [name_input_len]

jne next_char_username

mov dh, 6
mov dl, 34
mov bh, 0
mov ah, 2
int 10h

mov di, 0
mov si, var1

program:
mov ah, 1
int 21h
cmp al, 13 ; ASCII  value for 'enter' key
je s1
mov[si], al
inc si
inc di
mov word[length], di
jmp program

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; input the board size

s1:
call clrscr

mov ax, 0xb800
mov es, ax
mov di, 980
mov cx, 0
mov si, size_input_msg

mov ah, 0x03
next_char_board_size:
mov al, [si]
mov [es:di], ax
add di, 2
inc si
inc cx
cmp cx, [size_input_len]
jne next_char_board_size

mov ah, 0x10
mov al, 03
mov bl, 01
int 0x10

mov dx, 0
mov bl, 10

mov ah, 0 ; service 0 - get keystroke
int 0x16 ; BIOS keyboard service
cmp al, 0x13
je exit_board_size
sub al, 0x30 ; converting to ASCII
mov ah, 0
add dx, ax

mov ah, 0
int 0x16
cmp al, 0x13
je exit_board_size

push ax ; saving the second keystroke
mov ax, dx
mul bl
mov dx, ax
pop ax ; returning the second keystroke

sub al, 0x30
mov ah, 0
add dx, ax

exit_board_size:
cmp dx, 1
jbe default_size

cmp dx, 12
ja default_size

jmp set_size

default_size:
mov dx, 12

set_size:
mov word[board_size], dx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pop di
pop si
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Removing all occurences of character that was swapped with bomb

blast_removal:
push cx
push dx
push ax
push bx

mov bx, 0
mov dx, [blast_chracter]

n1:
cmp [grid+bx], dx
jnz no_remove

mov word[grid+bx], 0x1120 ; moving the 'space' in the variable
push ax
mov ax, [total_score_beginning]
add ax, 1
mov word[total_score_beginning], ax ; updating the total_score_beginning
pop ax

no_remove:
add bx, 2
cmp bx, [total_characters] ; 144 alphabets
jne n1

pop bx
pop ax
pop dx
pop cx
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Generating a random number using the system time initializing

random_number:
push cx
push dx
push ax
push bx
push di

mov bx, 0
mov di, [board_size_word]

fill_1:
rdtsc ; getting a random number in ax dx
xor dx, dx ; making dx = 0
xor dx, dx ; making dx = 0
mov dx, 0
mov dx, 0
mov cx, 8
div cx ; dividing by 8 to get numbers from 0-8
add dl, 1
jmp convert_1

converted_1:
cmp [grid+bx-24], dx
jz fill_1
cmp [grid+bx-2], dx
jz fill_1
cmp [grid+bx+24], dx
jz fill_1
 mov [grid+bx], dx ; moving the random number in the variable created
 add bx, 2
cmp bx, [total_characters] ; 288 alphabets with colors
jne fill_1

;;;;;;;;;;;;;;;;;;;

mov bx, 0

obstacle_loop:
rdtsc ; getting a random number in ax dx
xor dx, dx
xor dx, dx
mov dx, 0
mov dx, 0
mov cx, [array_length]
div cx
add dl, 1
mov si, dx
shl si, 1

cmp word[grid+si-24], 0xB058
jz obstacle_loop
cmp word[grid+si-2], 0xB058
jz obstacle_loop
cmp word[grid+si+24], 0xB058
jz obstacle_loop
cmp word[grid+si+2], 0xB058
jz obstacle_loop
cmp word[grid+si], 0xB058
jz obstacle_loop

mov word[grid+si], 0xB058

add bx, 1
cmp bx, [board_size]
jb obstacle_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pop di
pop bx
pop ax
pop dx
pop cx
ret

convert_1:

l_A1:
cmp dl, 1
jne l_B1
mov dx, 0x1241
jmp converted_1

l_B1:
cmp dl, 2
jne l_C1
mov dx, 0x1342
jmp converted_1

l_C1:
cmp dl, 3
jne l_D1
mov dx, 0x1443
jmp converted_1

l_D1:
cmp dl, 4
jne l_E1
mov dx, 0x1544
jmp converted_1

l_E1:
cmp dl, 5
jne l_F1
mov dx, 0x1645
jmp converted_1

l_F1:
cmp dl, 6
jne l_G1
mov dx, 0x1746
jmp converted_1

l_G1:
cmp dl, 7
jne l_H1
mov dx, 0x1847
jmp converted_1

l_H1:
cmp dl, 8
mov dx, 0x1948
jmp converted_1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

delay:
push cx
mov cx, 10 ; change the value to increase the delay time

delay_loop_1:
push cx
mov cx, 0xFFFF
delay_loop_2:
loop delay_loop_2
pop cx
loop delay_loop_1
pop cx
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

long_delay:
push cx
mov cx, 500 ; change the value to increase delay time

long_delay_loop_1:
push cx
mov cx, 0xFFFF
long_delay_loop_2:
loop long_delay_loop_2
pop cx
loop long_delay_loop_1
pop cx
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Would be taking 'x' position, 'y' position, string attribute, address of the string and its length as parameters

; subroutine to clear the screen

clrscr:
push es
push ax
push cx
push di
mov ax, 0xb800
mov es, ax
xor di, di
mov ax, 0x0720
mov cx, 2000
cld
rep stosw
pop di
pop cx
pop ax
pop es
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Would be taking 'x' position, 'y' position, string attribute, address of the string and its length as parameters for 'fill_spaces'

fill_spaces:
push cx
push dx
push ax
push bx
mov bx, 0

jmp fill_start

fill:
add bx, 2
cmp bx, [total_characters]
je back

fill_start:
rdtsc ; getting a random number in ax dx
xor dx, dx
xor dx, dx
mov dx, 0
mov dx, 0
mov cx, 8
div cx
add dl,1 

cmp word[grid+bx], 0x1120
jnz fill

jmp convert

converted:
cmp [grid+bx-24], dx
jz fill_start
cmp [grid+bx-2], dx
jz fill_start
cmp [grid+bx+24], dx
jz fill_start
cmp [grid+bx+2], dx
jz fill_start

mov [grid+bx], dx
jmp fill

back:
pop bx
pop ax
pop dx
pop cx
ret

convert:
l_A:
cmp dl, 1
jne l_B
mov dx, 0x1241
jmp converted

l_B:
cmp dl, 2
jne l_C
mov dx, 0x1342
jmp converted

l_C:
cmp dl, 3
jne l_D
mov dx, 0x1443
jmp converted

l_D:
cmp dl, 4
jne l_E
mov dx, 0x1544
jmp converted

l_E:
cmp dl, 5
jne l_F
mov dx, 0x1645
jmp converted

l_F:
cmp dl, 6
jne l_G
mov dx, 0x1746
jmp converted

l_G:
cmp dl, 7
jne l_H
mov dx, 0x1847
jmp converted

l_H:
cmp dl, 8
mov dx, 0x1948
jmp converted

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Printing the Board
print_board:
mov di, 164
mov bx, 0
mov cx, 0

next_char_5:
mov ax, [grid+bx]
mov [es:di], ax ; show this char on the screen
add bx, 2
add di, 8 ; move to the next screen location
inc cx
cmp cx, [board_size]
je next_line_3
jmp next_char_5

next_line_3: ; skipping 1 line and leaving the right side black
mov cx, 0
add di, [jump_next_line_2]
cmp di, [print_limit1] ; end it at 24 line
jl next_char_5

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; initializing the game board

initialize:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push si
push di
mov ax, 0xb800
mov es, ax
mov di, 0
mov cx, 0 ; initializing the coutner for 49 characters

next_char_1: ; printing the '|    |' pattern for the whole line
mov ah, [bp+10] ; loading the attribute in ah
mov al, [bp+6] ; load next char of string
mov [es:di], ax
add di, 2
inc cx
cmp cx, [x_limit1]
je next_line_1

; having 3 blank spaces

mov ah, 0x11
mov al, [bp+6]
mov [es:di], ax
add di, 2
inc cx
mov al, [bp+6]
mov [es:di], ax
add di, 2
inc cx
jmp next_char_1

next_line_1: ; jumping to next line after leaving the right side black
mov cx, 0
add di, [jump_next_line_i]
cmp di, [print_limit1] ; end it at line 24
jl next_char_1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov di, 0
next_char_2: ; printing '-------' pattern for the whole line
mov ah, [bp+10]
mov al, [bp+8]
mov [es:di], ax
add di, 2
inc cx
cmp cx, [x_limit1]
je next_line_2
jmp next_char_2

next_line_2: ; skipping line 1 and leaving the right side black
mov cx, 0
add di, [jump_next_line_1]
cmp di, [print_limit1] ; end it at the line 24
jl next_char_2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov al, 80
mul byte [bp+12] ; mul with 'y' position
add ax, [bp+14] ; add 'x' position
shl ax, 1 ; turn into byte offset
mov di, ax
mov si, [bp+22]
mov cx, [bp+20]

next_char_3: ; printing the 'player name' on the right side of the screen

mov ah, [bp+24] ; loading attribute in ah red background and black foreground
mov al, [si]
mov [es:di], ax
inc si
add di, 2
dec cx
jnz next_char_3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov al, 80
mul byte [bp+12]
add ax, [bp+14]
shl ax, 1
add di, 160 ; pointing to the line below player name i.e. the line for player total_score_beginning

mov si, [bp+18] ; load address of starting index of player total_score_beginning string
mov cx, [bp+16] ; initializing counter for player total_score_beginning of len 7

next_char_4: ; printing 'player total_score_beginning' on right side
mov ah, [bp+24]
mov al, [si]
mov [es:di], ax
inc si
add di, 2
dec cx
jnz next_char_4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov al, 80
mul byte [bp+12]
add ax, [bp+14]
shl ax, 1
mov di, ax
mov di, 320 ; pointing to the line where we print the player turns i.e. below player name
mov si, total_moves_allowed
mov cx, [total_moves_msg_len] ; initializing counter for players turns

next_char_turns: ;printing the 'turns string' on right side
mov ah, [bp+24]
mov al, [si]
mov [es:di], ax
inc si
add di, 2
dec cx
jnz next_char_turns

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov al, 80
mul byte [bp+12]
add ax, [bp+14]
shl ax, 1
mov di, ax
add di, 480 ; line where the players turns would be printed

mov si, [bp+32]
mov cx, [bp+30] ; initializing the counter for player turns

next_char_6: ;printing the 'turn string' on right side
mov ah, [bp+24]
mov al, [si]
mov [es:di], ax
inc si
add di, 2
dec cx
jnz next_char_6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; printing the input player name
mov ax, 0xb800
mov es, ax
mov di, 288
mov cx, 0

mov si, var1
mov ah, 0x40

next_charun:
mov al, [si]
mov [es:di], ax
add di, 2
inc si
inc cx
cmp cx, [length]
jne next_charun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

call random_number ; fill whole grid with random alphabets from A to H

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

call print_board ; printing the board

pop di
pop si
pop cx
pop bx
pop ax
pop es
pop bp
ret 22

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

removal:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push si
push di

mov cx, 0
mov ax, 0
mov si, 0
mov bx, 0
mov di, 0
mov dx, 0

push bp
mov bp, [down_character_check] ; index of last line to check if avoiding of the last line is needed

a: ; start of the check

push ax
mov ax, [total_score_beginning]
mov word[bomb_flag], ax ; saving the total_score_beginning in bomb_flag
pop ax

mov word[flagax], 0 ; if flag becomes 1, then space will be moved into ax
mov ax, [grid+si] ; loading the first character in ax
mov bx, [grid+di] ; 2nd index after the first index
inc cx

cmp ax, 0x1120 ; checking if there is space and ignoring all the checks

je no_space

cmp cx, [board_size] ; checking if ax is greater than on n-1 index then no check for adjacent right position

jae nlr ; jumping to no left right label if

cmp ax, bx ; comparing first index 'ax' with second index 'bx'

je lr ; check left and right adjacent conditions if both adjacent elements are same

jmp blr ; jump to back from left right

nlr: ; no left right shift because index is n-1
mov cx, 0 ; resetting the value of n to 0

blr: ; back from left right shift label

cmp si, [avoid_last_line] ; checking if the index is of the last line

jae noud ; if yes then no up down shift

cmp ax, [grid+si+bp] ; checking adjacent down index if same or not

je udf ; if yes then jump to up down flag

noud: ; no up down shift label if index is of last line

bud: ; back from up down flag label
mov bx, [flagax] ; loading the value of flagax in bx

cmp bx, 1 ; checking if flagax is 1 or not
je spaceax ; jumping to label that will clear out index that we are pointing to and storing space in it

jmp no_space ; if not adjacent index was cleared then ax will not be cleared and space will not be stored in our main index of interest

spaceax:
mov word[grid+si], 0x1120 ; clearing out the index that we are pointing to and storing space in it

push ax
mov ax, [total_score_beginning]
add ax, 1
mov word[total_score_beginning], ax ; updating the total_score_beginning
pop ax

no_space: ; will move to this label if no element was cleared and no spaces were stored in them

push ax
push bx
mov ax, [bomb_flag]
mov bx, [total_score_beginning]
sub bx, ax
cmp bx, 3
jae create_bomb
jmp no_bomb

create_bomb:
mov word[grid+si], 0x102A ; clearing pace and storing space in ax

no_bomb:
pop bx
pop ax
add si, 2
add di, 2
inc dx
cmp dx, [array_length]; checking if all the checks are done
jb a ; if not then repeat
jmp exit ; if yes then exit

udf: ; up down flag label if adjacent down index is same
jmp ud

lr: ; left right flag label if adjacent right index is same
push dx
mov dx, [board_size]
sub dx, 1
cmp cx, dx
jae avoid_3_consecutive_1
cmp bx, [grid+di+2]
jne avoid_3_consecutive_1
mov word[grid+di+2], 0x1120 ; storing space in the adjacent right index
mov word[flagax], 1 ; setting flagax to 1
push ax
mov ax, [total_score_beginning]
add ax, 1
mov word[total_score_beginning], ax
pop ax

avoid_3_consecutive_1: 
pop dx
mov word[grid+di], 0x1120
mov word[flagax], 1
push ax
mov ax, [total_score_beginning]
add ax, 1
mov word[total_score_beginning], ax
pop ax
jmp blr

ud: ; up down flag label if adjacent down index is same

push dx
push bx
push bp
mov dx, [grid+si+bp]
mov bx, bp
shl bx, 1
mov bp, bx
cmp dx, [grid+si+bp]
jne avoid_3_consecutive_2
mov word[grid+si+bp], 0x1120
mov word[flagax], 1
push ax
mov ax, [total_score_beginning]
add ax, 1
mov word[total_score_beginning], ax
pop ax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

avoid_3_consecutive_2:
pop bp
pop bx
pop dx

mov word[grid+si+bp], 0x1120
mov word[flagax], 1
push ax
mov ax, [total_score_beginning]
add ax, 1
mov word[total_score_beginning], ax
pop ax
jmp bud

exit:
pop bp
pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; swapping algorithm

swapping:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push si
push di

left_right:
mov cx, [y1]
mov dx, [y2]

; immediate left and immediate right

cmp cx, dx ; checking if same row or not

jnz up_down

mov cx, [x1]
mov dx, [x2]
sub cx, dx
cmp cx, 1
jz replace
cmp cx, -1
jz replace

up_down:
mov cx, [x1]
mov dx, [x2]

; immediate up and immediate down

cmp cx, dx ; checking if same column or not
jnz skip1
mov cx, [y1]
mov dx, [y2]
sub cx, dx
cmp cx, 1
jz replace
cmp cx, -1
jz replace
jmp skip1

replace:
mov si, [box1_selected]
shl si, 1
mov di, [box2_selected]
shl di, 1
mov ax, [grid+si]
mov bx, [grid+di]
mov cx, 0 ; temp variable for swapping

mov cx, ax ; storing box1_selected in temporary variable
mov ax, bx
mov bx, cx

mov word[grid+si], ax
mov word[grid+di], bx
jmp ignore_skip

skip1:
jmp skip

ignore_skip:

cmp ax, 0x102A
je bc1

cmp bx, 0x102A
je bc2
jmp skip

bc1:
mov word[bomb_blast], 1 ; setting bomb_blast to 1
mov word[blast_chracter], bx ; storing the character that was swapped with bomb
mov word[grid+si], 0x1120
push ax
mov ax, [total_score_beginning]
add ax, 1
mov word[total_score_beginning], ax
pop ax
jmp skip

bc2:
mov word[bomb_blast], 1
mov word[blast_chracter], ax
mov word[grid+di], 0x1120
push ax
mov ax, [total_score_beginning]
add ax, 1
mov word[total_score_beginning], ax
pop ax

skip:
pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; input mouse click

click:
push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push si
push di

jmp wait_for_mouse_click

correct:
mov word[x2],  cx
mov word[y2], dx

push bx
mov bx, [board_size]
sub bx, 1

mov ax, 0
mov al, bl
mul dl
add cx, dx
add ax, cx

pop bx

mov si, [isSelected]
cmp si, 0
jnz b ; 1st click is storing the part of jump
mov word[t2], ax ; 1st click storing
jmp c

b:
mov word[t3], ax ; 2nd click storing

c:

mov si, [isSelected] ; movees the status of isSelected to si
cmp si, 0
jnz l2_f

mov ax, [t2] ; box number to ax
mov word[box1_selected], ax
mov word[isSelected], 1

mov cx, [x2]
mov dx, [y2]
mov word[x1], cx
mov word[y1], dx

mov word[red_flag], 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; turning the first clikc red

push cx
push dx

mov ax, 0xb800
mov es, ax
mov cx, [rx]
shr cx, 3
mov dx, [ry]
shr dx, 3

mov ax, 0
mov al, 80
mul dx
add ax, cx
shl ax, 1
mov di, ax

jmp _skip

l2_f:
jmp l2

_skip:
cmp word[es:di], 0x102D
je lower

lower_b:
cmp word[es:di], 0x107C
je right_2

cmp word[es:di], 0x117C
je left_right_space

simple:
mov word[es:di-2], 0x4430
mov word[es:di+2], 0x4430
jmp no_change

lower:
add di, 160
jmp lower_b

right_2:
add di, 4
mov word[es:di-2], 0x4430
mov word[es:di+2], 0x4430
jmp no_change

left_right_space:
add di, 2
cmp word[es:di], 0x107C
jne left_space

right_space:
sub di, 4
mov word[es:di-2], 0x4430
mov word[es:di+2], 0x4430
jmp no_change

left_space:
mov word[es:di-2], 0x4430
mov word[es:di+2], 0x4430

no_change:
pop cx
pop dx
jmp wait_for_mouse_click

l2:
cmp si, 1
jnz compare

mov ax, [t3]
mov word[box2_selected], ax
mov word[isSelected], 2
mov ax, [t2]
mov word[box1_selected], ax

compare:
mov cx, [box1_selected]
mov dx, [box2_selected]
cmp cx, dx ; check if the player clicks twice on the same block

jz incorrect_1

mov si, cx
mov di, dx

shl si, 1
shl di, 1

cmp word[grid+si], 0xB058 ; check if the player clicks on hurdles
jz incorrect_1

cmp word[grid+di], 0xB058
jz incorrect_1

call swapping

call print_board

push ax
mov ax, [bomb_blast]
cmp ax, 1
je blast

call removal
call removal
call removal
call removal
call removal
call removal

jmp no_blast

blast:
call blast_removal

no_blast:
pop ax

call delay

call print_board

call hurdles_check ; check if the hurdles will bbe removed or not

call fill_spaces

call delay

call print_board
mov word[bomb_blast], 0
jmp avoid

incorrect_1:
call print_board
jmp incorrect


avoid:
mov ax, 0xb800
mov es, ax
mov ax, [total_score_beginning]
mov bx, 10 ; using base 10 for the division
mov cx, 0 ; initialize the count of digits

next_digit_4: 
mov dx, 0 ; zero upper half of the dvidend
div bx; divide by 10
add dl, 0x30 ; converting the digit in ASCII
push dx ; save the ASCII value on the stack
inc cx ; increment the count of values
cmp ax, 0 ; check if the quotient is zero?
jnz next_digit_4 ; if no, then divide it again
mov di, 436 ; point di to the top left column

next_pos_4:
pop dx ; remove a digit from the stack
mov dh, 0x40
mov [es:di], dx ; print chracter on the screen
add di, 2 ; move to the next screen location
loop next_pos_4 ; repeat for all the digits on the stakc

mov ax, [total_moves_allowed]
dec ax
mov word[total_moves_allowed], ax
cmp ax, 10
jb single

mov ax, 0xb800
mov es, ax
mov bx, [total_moves_allowed]
mov bx, 10
mov cx, 0

next_digit_3:
mov dx, 0 ; zero upper hald of the dividend
div bx ; div by 10
add dl ,0x30
push dx
inc cx
cmp ax, 0 ; is the quotient zero?
jnz next_digit_3 ; if no, then divie again
mov di, 776 ; point di to top left column

next_pos_3:
pop dx ; removes a digit from the stack
mov dh, 0x40
mov [es:di], dx
add di, 2
loop next_pos_3 ; repeating for all digits in the stack
jmp skip_single

single:
mov ah, 0x40
mov al, 0x30
mov [es:776], ax
mov word[es:778], 0x4020

mov ax, [total_moves_allowed]
cmp ax, 0 ; check if the remaining moves are equal to 0 which 
