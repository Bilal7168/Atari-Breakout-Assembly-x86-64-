[org 0x0100] ;                           we will see org directive later
                                                jmp start;

message:                                 db "Atari Breakout (Bilal Shahid) 0";
m01:                                          db "ATARI0";
m02:                                          db "BREAKOUT0"
m1:                                            db "1) To play this game, use the LEFT and RIGHT arrow keys 0",
m2:                                            db "2) To release ball from slide, press ENTER 0",
m3:                                            db "3) You have 3 lives. You lose a life if ball falls below bar 0",
m4:                                            db "4) The Lives and Score are in the top corners 0",
m5:                                            db "Press SPACE to start, Good Luck! 0",
ballrelease:                             db 0;               ;this will become '1' if ball is released
scorecounter:                         dw 0;
heartcounter:                          db 3;
scoremsg:                               db "Score: 0",
livemsg:                                   db "Lives: 0",
lifelostmsg:                             db "You lost a life 0";

;------------------------------------------------------------------------------------------------------------------
clrscr:	                                mov ax, 0xb800 					
			mov es, ax 						
			mov di, 0 															
nextchar: 	                                mov word [es:di], 0x0720 		
			add di, 2 						
			cmp di, 4000 					
			jne nextchar 
                                                       ret;
;---------------------------------------------------------------------------------------------------------------------
funcforprintinganumberonscreen:             push bp
				mov bp, sp
				push es
				push ax
				push bx
				push cx
				push dx
				push di

				mov ax, 0xb800
				mov es, ax			; point es to video base

				mov ax, [bp+4]		; load number in ax at [bp+4]
				mov bx, 10			; use base 10 for division
				mov cx, 0			; initialize count of digits

nextdigit:		                                      mov dx, 0			; zero upper half of dividend
				div bx				; divide by 10 AX/BX --> Quotient --> AX, Remainder --> DX ..... 
				add dl, 0x30		; convert digit into ascii value
				push dx				; save ascii value on stack

				inc cx				; increment count of values
				cmp ax, 0			; is the quotient zero
				jnz nextdigit		; if no divide it again


				mov bx, [bp+6]			; point di to top left column
nextpos:		                                     pop dx				; remove a digit from the stack
				mov dh, 0x07		; use normal attribute
				mov [es:bx], dx		; print char on screen
				add bx, 2			; move to next screen location
				loop nextpos		; repeat for all digits on stack

				pop di
				pop dx
				pop cx
				pop bx
				pop ax
				pop es
				pop bp
				ret 2     
;---------------------------------------------------------------------------------------------------------------------
BEEP:     

      IN AL, 61h  ;Save state

      PUSH AX 

  

      MOV BX, 6818; 1193180/175

      MOV AL, 6Bh  ; Select Channel 2, write LSB/BSB mode 3

      OUT 43h, AL

      MOV AX, BX

      OUT 24h, AL  ; Send the LSB

      MOV AL, AH 

      OUT 42h, AL  ; Send the MSB

      IN AL, 61h   ; Get the 8255 Port Contence

      OR AL, 3h     

      OUT 61h, AL  ;End able speaker and use clock channel 2 for input

      MOV CX, 03h ; High order wait value

      MOV DX, 0D04h; Low order wait value

      MOV AX, 86h;Wait service

      INT 15h 

     call delayforbeep;

      POP AX;restore Speaker state

     OUT 61h, AL

      RET

;---------------------------------------------------------------------------------

BEEPFORMISS:     

      IN AL, 61h  ;Save state

      PUSH AX 

  

      MOV BX, 6818; 1193180/175

      MOV AL, 6Bh  ; Select Channel 2, write LSB/BSB mode 3

      OUT 43h, AL

      MOV AX, BX

      OUT 24h, AL  ; Send the LSB

      MOV AL, AH 

      OUT 42h, AL  ; Send the MSB

      IN AL, 61h   ; Get the 8255 Port Contence

      OR AL, 3h     

      OUT 61h, AL  ;End able speaker and use clock channel 2 for input

      MOV CX, 03h ; High order wait value

      MOV DX, 0D04h; Low order wait value

      MOV AX, 86h;Wait service

      INT 15h 

     call delayforbeepmiss;

      POP AX;restore Speaker state

     OUT 61h, AL

      RET
;----------------------------------------------------------------------------
delayforbeep:  mov ecx, 9;
sound1: loop sound1;
sound2: loop sound2;
sound3: loop sound3;
ret;  

;-----------------------------------------------------------------------------------
;----------------------------------------------------------------------------
delayforbeepmiss:  mov ecx, 999999999;
sound19: loop sound19;
sound28: loop sound28;
sound37: loop sound37;
sound4: loop sound4;
sound5: loop sound5;
sound6: loop sound6;
sound7: loop sound7;
sound8: loop sound8;
sound9: loop sound9;
sound10: loop sound10;
sound11: loop sound11;
sound12: loop sound12;
sound13: loop sound13;
sound14: loop sound14;
sound15: loop sound15;
ret;  

;-----------------------------------------------------------------------------------


titleprintforexit:                                  mov ax, 0xb800
                                               mov es, ax;
                                               mov si, 0;
                                               mov di, 210;

                                               mov ah, 0xF4;

looptpfe:                                     mov al, [message+si];
                                               mov [es:di], ax;
                                               add si, 1;
                                               add di, 2;
                                               cmp di, 268;
                                               jne looptpfe;
                                               jmp moveforward;

lm1:                                      db "Your Score: 0",
lm2:                                      db "Lives Remaining: 0";
lm3:                                     db "GAME OVER 0";

moveforward:                     mov di, 1660;    
                                             mov si, lm1;
                                             mov ah, 12;  

looplm1:                           mov al, [si]; 
                                           mov [es:di], ax;
                                            add di, 2;
                                            add si, 1;
                                            mov bl, [si];
                                            cmp bl, '0';
                                            jne looplm1;
                                           mov ax, di;
                                           push ax
                                           mov ax, [scorecounter];
                                           push ax;
                                           call funcforprintinganumberonscreen;
 
                                           mov di, 2140;
                                           mov si, lm2;
                                           mov ah, 12;

looplm2:                           mov al, [si]; 
                                           mov [es:di], ax;
                                            add di, 2;
                                            add si, 1;
                                            mov bl, [si];
                                            cmp bl, '0';
                                            jne looplm2; 
                                            mov bl, [heartcounter];
                                            cmp bl, 1;
                                            je for1;
                                            cmp bl, 2;
                                            je for2;
                                            cmp bl, 3;
                                            je for3;
                                            cmp bl, 0;
                                            je for0;

for1:                                  mov byte [es:di], '1';
                                          jmp noshitsherlock;
for2:                                  mov byte [es:di], '2';
                                          jmp noshitsherlock;
for3:                                  mov byte [es:di], '3';
                                          jmp noshitsherlock;
for0:                                  mov byte [es:di], '0';

noshitsherlock:               mov di, 3108;
                                           mov si, lm3;
                                           mov ah, 0xF4;

looplm3:                           mov al, [si]; 
                                           mov [es:di], ax;
                                            add di, 2;
                                            add si, 1;
                                            mov bl, [si];
                                            cmp bl, '0';
                                            jne looplm3;                   

                                               ret;
;---------------------------------------------------------------------------------------------------------------------
titleprint:                                  mov ax, 0xb800
                                               mov es, ax;
                                               mov si, 0;
                                               mov di, 210;

                                               mov ah, 0xF4;

looptp:                                     mov al, [message+si];
                                               mov [es:di], ax;
                                               add si, 1;
                                               add di, 2;
                                               cmp di, 268;
                                               jne looptp;

                                              mov si, 160;
                                              mov di, 210;
                                              mov al, 2;
                                              mov ah, 12;

loopline1:                           mov [es:si], ax;
                                             add si, 2;
                                             cmp si, 208;
                                             jne loopline1; 
                                             mov si, 270;
                  
loopline2:                           mov [es:si], ax;
                                             add si, 2;
                                             cmp si, 320;
                                            jne loopline2;    
                                            mov di, 20;
                                            mov si, scoremsg;
                                           mov ah, 0xF;

msgprintscore:               mov al, [si];  
                                          mov [es:di], al;
                                           add di, 2;
                                           add si, 1;
                                           mov bl, [si];
                                           cmp bl, '0';
                                           jne msgprintscore;   
                                           mov byte [es:di], '0';
                                           mov di, 130;
                                           mov si, livemsg;
                                           mov ah, 0xF;

heartsprint:                      mov al, [si];
                                           mov [es:di], al; 
                                           add di , 2;
                                           add si, 1;
                                           mov bl, [si];
                                           cmp bl, '0';
                                           jne heartsprint;
                                          mov al, 3;
                                          mov ah, 12;
                                           mov [es:di], ax;
                                           mov [es:di+2], ax;
                                           mov [es:di+4], ax;
                                          
scoreprint:                                               
                                               ret;
                                               

;---------------------------------------------------------------------------------------------------------------------
randomnumbergenerator:          mov  ax, dx
                                                xor  dx, dx
                                                 mov  cx, 10    
                                                  div  cx       ; here dx contains the remainder of the division - from 0 to 9
                                              ret;

;---------------------------------------------------------------------------------------------------------------------
pb:                                         mov di, 802;
                                              jmp flprintblock;
                                             
flprintblock:                             call randomnumbergenerator;
                                             mov ax, 0xb800;
                                             mov es, ax;
                                             mov si, di; 
                                             shl dx, 1;
                                             add di, dx;
                                             jmp loopprinter;

loopprinter:                            mov ah, 3;
                                            mov al, 1;
                                            mov [es:si], ax;
                                            mov [es:si+160], ax;
                                            add si, 2;
                                            cmp si, 956;
                                            je slpbback;
                                            cmp si, di;
                                            jne loopprinter;
                                            add di, 2; 
                                            jmp flprintblock;

slpbback:                              mov di, 1122;
                                            jmp slprintblock;

slprintblock:                           call randomnumbergenerator;
                                            mov ax, 0xb800;
                                            mov es, ax;
                                            mov si, di; 
                                            shl dx, 1;
                                            add di, dx;
                                            jmp loopprinter2;

loopprinter2:                          mov ah, 5;
                                            mov al, 2;
                                            mov [es:si], ax;
                                            mov [es:si+160], ax;
                                            add si, 2;
                                            cmp si, 1276;
                                            je tlpbback;
                                            cmp si, di;
                                            jne loopprinter2;
                                            add di, 2;
                                            jmp slprintblock;

tlpbback:                              mov di, 1442;
                                            jmp tlprintblock;

tlprintblock:                           call randomnumbergenerator;
                                            mov ax, 0xb800;
                                            mov es, ax;
                                            mov si, di; 
                                            shl dx, 1;
                                            add di, dx;
                                            jmp loopprinter3;

loopprinter3:                          mov ah, 6;
                                            mov al, 4;
                                            mov [es:si], ax;
                                            mov [es:si+160], ax;
                                            add si, 2;
                                            cmp si, 1596;
                                            je felpbback;
                                            cmp si, di;
                                            jne loopprinter3;
                                            add di, 2;
                                            jmp tlprintblock;

felpbback:                              mov di, 1762;
                                            jmp felprintblock;

felprintblock:                           call randomnumbergenerator;
                                            mov ax, 0xb800;
                                            mov es, ax;
                                            mov si, di; 
                                            shl dx, 1;
                                            add di, dx;
                                            jmp loopprinter4;

loopprinter4:                          mov ah, 8;
                                            mov al, 5;
                                            mov [es:si], ax;
                                            mov [es:si+160], ax;
                                            add si, 2;
                                            cmp si, 1916;
                                            je exitcallforpb;
                                            cmp si, di;
                                            jne loopprinter4;
                                            add di, 2;
                                            jmp felprintblock;





exitcallforpb:                          
                                              

                                              ret 4;                                                                                                                                    
;----------------------------------------------------------------------------------------------------------------------

slideballprint:                          mov ax, 0xb800
                                              mov es, ax  
                                              mov di, 3680;

                                              mov ah, 1;       ;blue color of bar
                                              mov al, 64;
                                  
loopsbp:                                 mov [es:di], ax;
                                              add di,2;
                                              cmp di, 3700;
                                              jne loopsbp;
                                            
                                             mov di, 3530;    ;the ball placed at the centre of the bar
                                             mov ah, 7;         ;white color of bar
                                             mov al, 48;

                                             mov [es:di], ax;
                                             ret;
;----------------------------------------------------------------------------------------------------------------------
ballendleft:                               cmp di, 3680
                                               je nmtemp;
                                               jmp lsbtl;                         

ballendright:                             cmp di, 3816
                                               je nmtemp;
                                               jmp lsbtr;  

;----------------------------------------------------------------------------------------------------------------------

kbisr:		               push ax
		              push es
	
		             mov ax, 0xb800
		             mov es, ax						; point es to video memory

		            in al, 0x60						; read a char from keyboard port, scancode
	
		           cmp al, 0x4d					; is the key right
                                                je loopslideballtoright;
                                                cmp al, 0x4b                                                                             ; is the key left
                                                je loopslideballtoleft;
                                                cmp al, 01;                                                                                ; is the key escape
                                                je exithandle;                                                                                     
                                               cmp al, 0x1c                                                                              ;is the key enter
                                               je enterhandle;                    
                                                jmp nomatch;

loopslideballtoright:              jmp ballendright;
lsbtr:                                         mov word [es:di], 0x0720
                                                add di, 22;
                                                mov bh, 1;
                                                mov bl, 64;
                                                mov [es:di], bx;
                                                sub di, 20;
                                                mov cl, [ballrelease];
                                               cmp cl, 0;
                                               je pushballright;
                                               jmp nomatch;

nmtemp:                             jmp nomatch;

pushballright:                      mov word[es:si], 0x0720;
                                               add si, 2;
                                               mov byte[es:si], '0'; 
                                               jmp nomatch;

loopslideballtoleft:                      jmp ballendleft;
lsbtl:                                         add di, 20;               ;shift the di to the end of the slideball
                                                mov word [es:di], 0x0720
                                                sub di, 22;
                                                mov bh, 1;
                                                mov bl, 64;
                                                mov [es:di], bx;        ;moves a block to the start of the slideball. Now slideball points to this pos
                                                mov cl, [ballrelease];
                                                cmp cl, 0;
                                                je pushballleft;
                                                jmp nomatch;

pushballleft:                         mov word[es:si]. 0x0720;
                                               sub si, 2;
                                               mov byte[es:si], '0';
                                               jmp nomatch;

exithandle:                               jmp exit;

enterhandle:                       mov cl, 1;
                                              mov [ballrelease], cl;
                                              jmp nomatch;
                                                                   
nomatch:	                                mov al, 0x20
			out 0x20, al					; send EOI to PIC
			
			pop es
			pop ax

			iret
;----------------------------------------------------------------------------------------------------------------------
delay:                                    mov ecx, 999999999;
tm1:                                      loop tm1;
tm2:                                      loop tm2;
tm3:                                      loop tm3;
tm4:                                      loop tm4;
tm5:                                      ;loop tm5;
tm6:                                     ; loop tm6;
tm7:                                      ;loop tm7;
                                             ret;
;----------------------------------------------------------------------------------------------------------------------
cond1bordercheck:               mov ax, 320;
                                            jmp c1bcloop;

c1bcloop:                             cmp si, ax;
                                           je c1bcloopcatertemp;
                                           add ax, 2;
                                           cmp ax, 478;
                                           jle c1bcloop;
                                           jmp cond1bordercheck2;

cond1bordercheck2:             mov ax, 158;
                                          jmp c1bcloop2;

c1bcloop2:                          cmp si, ax;
                                          je c1bcloopcatertemp2;
                                          add ax, 160;
                                          cmp ax, 3678;
                                          jle c1bcloop2;
                                          jmp c1trajectoryblock;

c1trajectoryblock:                mov dx, [es:si-158];
                                         cmp dx, 0x0720;
                                         jne clearblockc1;
                                         jmp c1rb;

c1bcloopcatertemp:           jmp c1bcloopcater;

clearblockc1:                 mov bx, [scorecounter];
                                         add bx, 100;
                                         mov [scorecounter], bx;
                                         mov ax, 34;
                                         push ax;
                                         mov ax, [scorecounter];
                                        push ax;
                                         call funcforprintinganumberonscreen;  
                                         call BEEP;
                                         call functoreturnexit;   
                                         mov ax, 0xb800;
                                          mov es, ax;
                                          sub si, 158;
                                          mov bx, si;
                                          add bx, 2;
                                          mov cx, si;
                                          jmp bxfinderc1;

c1bcloopcatertemp2:           jmp c1bcloopcater2;

bxfinderc1:                         sub bx, 2;
                                         cmp bx, 638;
                                         je mvfbfc1;
                                         cmp bx, 798;
                                        je mvfbfc1;
                                        cmp bx, 1278;
                                         je mvfbfc1;
                                         cmp bx, 1438;
                                        je mvfbfc1;
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                         jne bxfinderc1;

mvfbfc1:                         add bx, 2;
                                        mov cx, bx;          ;cx here stores the original si
                                        mov bx, si;
                                        sub bx, 2;

cxfinderc1:                         add bx, 2;
                                         cmp bx, 1118;
                                         je debugerrorfixc1;
                                         cmp bx, 1278;
                                         je debugerrorfixc1;
                                         cmp bx, 1758;
                                         je debugerrorfixc1;
                                         cmp bx, 1918;
                                         je debugerrorfixc1;
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                          jne cxfinderc1; 
                                         jmp defc1skip;

debugerrorfixc1:           add bx, 2;
                                       
defc1skip:                       mov dx, bx;

;here we now have the cx (the most left side of the block) and the dx (the most right side of the block);

                                        mov bp, sp;
                                        sub sp, 6;
                                        mov [bp-2], cx;
                                        mov [bp-4], dx;
                                        mov [bp-6], si;   ;this is where the ball hits

checkcaseforsameblockc1: 
                                         mov bx, cx;
                                         mov dl, [es:bx+160];   ;dl now stores the lower part 
                                         mov dh, [es:bx];          dh stores the top part;
                                         cmp dh, dl;
                                         je addloopers;                                                              
                                                             
subtractlooper:                   mov dx, [bp-4];
                                         mov bx, cx;
loopclearc1:                      mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                         jne loopclearc1;
                                         
                                         sub cx, 160;
                                         sub dx, 160;
                                         mov bx, cx;

loopclearc1pt2:                   mov word [es:bx], 0x0720;
                                         add bx, 2;  
                                         cmp bx, dx;
                                         jne loopclearc1pt2;
                                         jmp c1bcloopcaterforblock;

addloopers:                        mov dx, [bp-4];
                                         mov bx, cx;
loopclearc1al:                     mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                         jne loopclearc1al;
                                         
                                         add cx, 160;
                                         add dx, 160;
                                         mov bx, cx;

loopclearc1pt2al:                 mov word [es:bx], 0x0720;
                                         add bx, 2;  
                                         cmp bx, dx;
                                         jne loopclearc1pt2al;
                                         jmp c1bcloopcaterforblock;

c1bcloopcaterforblock:         mov cx, [bp-2];
                                         sub si, cx;
                                         mov cx, si;
                                         mov si, [bp-6];
                                         mov dx, [bp-4];
                                         sub dx, si;
                                         cmp dx, cx;
                                         add si, 158;
                                         jl bccaterfordxc1;
                                          jmp c1bcloopcater;

c1bcloopcater:                     mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition2;  

bccaterfordxc1:                    mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition3; 

c1bcloopcater2:                   mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition4; 
;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
cond2bordercheck:       mov ax, 3680;
                                           jmp lifec2check;                       ;in line from 3680 to 3840/3838

lifec2check:                    cmp si, ax;
                                          je l2cdetectslide;
                                          add ax, 2;
                                          cmp ax, 3840;
                                          je cc2tempers;
                                         jne lifec2check;

l2cdetectslide:              mov ax, 0xb800;
                                         mov es, ax;
                                         mov bx, [es:si];
                                         cmp bx, 0x0720;
                                         jne simpledecrementc21;
                                         jmp checkcontinuec2;

cc2tempers:                  jmp cc2tempers2;

;_____________________________________
funcforlowbarclearc2:  mov bx, 3680;
loopflbcc2:                     mov word [es:bx], 0x0720;
                                          add bx, 2;
                                          cmp bx, 3840;
                                          jne loopflbcc2;
                                          ret;
;_____________________________________

simpledecrementc21:      call BEEPFORMISS
                                         mov bl, [heartcounter];
                                         cmp bl, 3;
                                         je simpledecrementc22;
                                         cmp bl, 2;
                                         je simpledecrementc23;
                                         cmp bl, 1;
                                         je simpledecrementc24;

cc2tempers2:               jmp checkcontinuec2;


simpledecrementc22: mov ax, 0xb800;
                                         mov es, ax;
                                         mov word[es:148], 0x0720;
                                         mov bl, [heartcounter];
                                         sub bl, 1;
                                         mov [heartcounter], bl;
                                         call funcforlowbarclearc2;
                                         call slideballprint;
                                         mov di, 3680;
                                         mov si, 3530;
                                         mov bl, 0;
                                         mov [ballrelease], bl;
                                         jmp loopforballcheck;


simpledecrementc23: mov ax, 0xb800;
                                         mov es, ax;
                                        mov word[es:146], 0x0720;
                                         mov bl, [heartcounter];
                                         sub bl, 1;
                                         mov [heartcounter], bl;
                                        call funcforlowbarclearc2;
                                         call slideballprint;
                                         mov di, 3680;
                                         mov si, 3530;
                                         mov bl, 0;
                                         mov [ballrelease], bl;
                                         jmp loopforballcheck;

simpledecrementc24: mov ax, 0xb800;
                                         mov es, ax;
                                         mov word[es:144], 0x0720;
                                         mov bl, [heartcounter];
                                         sub bl, 1;
                                         mov [heartcounter], bl;
                                         call funcforlowbarclearc2;
                                         call slideballprint;
                                         mov di, 3680;
                                         mov si, 3530;
                                         mov bl, 0;
                                         mov [ballrelease], bl;
                                         jmp loopforballcheck;

;----------------------------------------------------------------------------------------------------------heartcounterend

checkcontinuec2:          mov ax, 158;
                                           jmp c2bcloop2;

c2bcloop2:                           cmp si, ax;
                                           je c2bcloopcatertemp2;       ;jmps to condition 3
                                           add ax, 160                      ;project
                                           cmp ax, 3678;
                                           jle c2bcloop2;
                                           jmp c2trajectoryblock;

c2trajectoryblock:                mov dx, [es:si+162];
                                          cmp dx, 0x0720;
                                          jne detectdiffbtwslideandblock2;
                                          jmp c2rb;  

detectdiffbtwslideandblock2:   cmp dl, '@';
                                              je cond2ballhitsj;
                                              jmp clearblockc2;

clearblockc2:                 mov bx, [scorecounter];
                                         add bx, 100;
                                         mov [scorecounter], bx;
                                         mov ax, 34;
                                         push ax;
                                         mov ax, [scorecounter];
                                        push ax;
                                         call funcforprintinganumberonscreen;  
                                         call BEEP;     
                                         call functoreturnexit;   
                                          mov ax, 0xb800;
                                          mov es, ax;
                                          add si, 162;
                                          mov bx, si;
                                          add bx, 2;
                                          mov cx, si;
                                          jmp bxfinderc2;

c2bcloopcatertemp2:           jmp c2bcloopcater2;

bxfinderc2:                         sub bx, 2;
                                         cmp bx, 638;
                                         je mvfbfc2;
                                         cmp bx, 798;
                                        je mvfbfc2;
                                        cmp bx, 1278;
                                         je mvfbfc2;
                                         cmp bx, 1438;
                                        je mvfbfc2;
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                         jne bxfinderc2;

mvfbfc2:                         add bx ,2;
                                        mov cx, bx;                  ;cx here stores the left side of the block ( the start side )
                                        mov bx, si;
                                        sub bx, 2;
                                        jmp cxfinderc2;

cond2ballhitsj:                    jmp cond2ballhit;

cxfinderc2:                         add bx, 2;
                                         cmp bx, 1118;
                                         je debugerrorfix;
                                         cmp bx, 1278;
                                         je debugerrorfix;
                                         cmp bx, 1758;
                                         je debugerrorfix;
                                         cmp bx, 1918;
                                         je debugerrorfix;
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                          jne cxfinderc2;
                                          jmp defskip;

debugerrorfix:              add bx, 2;
defskip:                         mov dx, bx;


;here we now have the cx (the most left side of the block) and the dx (the most right side of the block);

                                        mov bp, sp;
                                        sub sp, 6;
                                        mov [bp-2], cx;
                                        mov [bp-4], dx;
                                        mov [bp-6], si;   ;this is where the ball hits

checkcaseforsameblockc2:  mov bx, cx;
                                         mov dl, [es:bx+160];   ;dl now stores the part above this 
                                         mov dh, [es:bx];          dh stores the top part;
                                         cmp dh, dl;
                                         je addloopersc2;
                                         jmp subtractloopersc2;
                                                             
addloopersc2:                     mov dx, [bp-4];
                                         mov bx, cx;
loopclearc2:                        mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                         jne loopclearc2;
                                         add cx, 160;
                                         add dx, 160;
                                         mov bx, cx;

loopclearc2pt2:                   mov word [es:bx], 0x0720;
                                         add bx, 2;  
                                         cmp bx, dx;
                                         jne loopclearc2pt2;
                                         jmp c2bcloopcaterforblock;

subtractloopersc2:               mov dx, [bp-4];
                                          mov bx, cx;
loopclearc22:                       mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                         jne loopclearc22;
                                         sub cx, 160;
                                         sub dx, 160;
                                         mov bx, cx;

loopclearc2pt22:                   mov word [es:bx], 0x0720;
                                         add bx, 2;  
                                         cmp bx, dx;
                                         jne loopclearc2pt22;

c2bcloopcaterforblock:         mov cx, [bp-2];
                                         sub si, cx;
                                         mov cx, si;
                                         mov si, [bp-6];
                                         mov dx, [bp-4];
                                         sub dx, si;
                                         sub si, 162;
                                         cmp dx, cx;
                                         jl c2bcloopcater;
                                         jmp cbcfsb;


cond2ballhit:                        mov dx, [es:si+162];
                                          add si, 162;               ; finds a block at si+162
                                          cmp dl, '@';
                                          je differencechecks;
                                          jmp c2conditionrb;        ;if it doesnt find a block on the next index

differencechecks:                  mov ax, 0xb800;         ;we have the ax where the ball touches
                                           mov es, ax;
                                           mov bp, sp;
                                           sub sp, 6; 
                                           mov [bp-2], si;        
                                           mov bx, 0;
                                           mov cx, 0;
                                           jmp bxloop;

cbcfsb:                               jmp c2bcloopcaterforslideball;

bxloop:                                sub si, 2;
                                          add bx, 1;
                                          mov dx, [es:si];
                                          cmp dx, 0x0720;
                                          jne bxloop;

                                          mov si, [bp-2];
                                          mov cx, bx;
                                          mov bx, 0;

cxloop:                                add si, 2;
                                          add bx, 1;
                                          mov dx, [es:si];
                                          cmp dx, 0x0720;
                                          jne cxloop;
; bx and cx now both contain the indexes where the slide ends;
                                          mov si, [bp-2];
                       
                                          sub si, 162
                                          cmp bx, cx;
                                          jl c2bcloopcater;
                                          ja c2bcloopcaterforslideball;
                                          je c2bcloopcater3;

c2bcloopcater:                      mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition1;  

c2bcloopcater3:             mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition5;  

c2conditionrb:                      sub si, 162;
                                          jmp c2rb;
                                      

c2bcloopcater2:                   mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition3;

c2bcloopcaterforslideball:      mov ax, 0xb800;
                                          mov es, ax;
                                          mov word[es:si], '0';
                                          jmp condition4;
;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
cond3bordercheck:       mov ax, 3680;
                                           jmp lifec3check;                       ;in line from 3680 to 3840/3838

lifec3check:                    cmp si, ax;
                                          je l3cdetectslide;
                                          add ax, 2;
                                          cmp ax, 3840;
                                          je cc3tempers;
                                         jne lifec3check;

l3cdetectslide:              mov ax, 0xb800;
                                         mov es, ax;
                                         mov bx, [es:si];
                                         cmp bx, 0x0720;
                                         jne simpledecrementc31;
                                         jmp checkcontinuec3;

;_____________________________________
funcforlowbarclearc3:  mov bx, 3680;
loopflbcc3:                     mov word [es:bx], 0x0720;
                                          add bx, 2;
                                          cmp bx, 3840;
                                          jne loopflbcc3;
                                          ret;
;_____________________________________

simpledecrementc31:            call BEEPFORMISS
                                         mov bl, [heartcounter];
                                         cmp bl, 3;
                                         je simpledecrementc32;
                                         cmp bl, 2;
                                         je simpledecrementc33;
                                         cmp bl, 1;
                                         je simpledecrementc34;

simpledecrementc32: mov ax, 0xb800;
                                         mov es, ax;
                                         mov word[es:148], 0x0720;
                                         mov bl, [heartcounter];
                                         sub bl, 1;
                                         mov [heartcounter], bl;
                                         call funcforlowbarclearc3;
                                         call slideballprint;
                                         mov di, 3680;
                                         mov si, 3530;
                                         mov bl, 0;
                                         mov [ballrelease], bl;
                                         jmp loopforballcheck;

cc3tempers:                  jmp checkcontinuec3;

simpledecrementc33: mov ax, 0xb800;
                                         mov es, ax;
                                        mov word[es:146], 0x0720;
                                         mov bl, [heartcounter];
                                         sub bl, 1;
                                         mov [heartcounter], bl;
                                        call funcforlowbarclearc3;
                                         call slideballprint;
                                         mov di, 3680;
                                         mov si, 3530;
                                         mov bl, 0;
                                         mov [ballrelease], bl;
                                         jmp loopforballcheck;

simpledecrementc34: mov ax, 0xb800;
                                         mov es, ax;
                                         mov word[es:144], 0x0720;
                                         mov bl, [heartcounter];
                                         sub bl, 1;
                                         mov [heartcounter], bl;
                                         call funcforlowbarclearc3;
                                         call slideballprint;
                                         mov di, 3680;
                                         mov si, 3530;
                                         mov bl, 0;
                                         mov [ballrelease], bl;
                                         jmp loopforballcheck;

;----------------------------------------------------------------------------------------------------------heartcounterend         

checkcontinuec3:           mov ax, 0;
                                           jmp c3bcloop;

c3bcloop:                             cmp si, ax;
                                           je c3bclcc3;
                                           add ax, 160;
                                           cmp ax, 3680;
                                           jle c3bcloop;
                                           jmp c3trajectoryblock;

c3trajectoryblock:                mov dx, [es:si+158];
                                         cmp dx, 0x0720;
                                          jne detectdiffbtwslideandblock;
                                          jmp c3rb;

c3bcloopcatertemp:           jmp c3bcloopcater;

detectdiffbtwslideandblock:   cmp dl, '@';
                                          je cond3ballhitsj;
                                          jmp clearblockc3;

clearblockc3:                 mov bx, [scorecounter];
                                         add bx, 100;
                                         mov [scorecounter], bx;  
                                         mov ax, 34;
                                         push ax;
                                         mov ax, [scorecounter];
                                        push ax;
                                         call funcforprintinganumberonscreen;
                                         call BEEP;   
                                         call functoreturnexit;                       
                                         mov ax, 0xb800;
                                          mov es, ax;
                                          add si, 158;
                                          mov bx, si;
                                          add bx, 2;
                                          mov cx, si;
                                          jmp bxfinderc3;

c3bclcc3:                         jmp c3bclcc2;

c3bcloopcatertemp2:           jmp c3bcloopcater2;

bxfinderc3:                         sub bx, 2;
                                         cmp bx, 638;
                                         je mvfbfc3;
                                         cmp bx, 798;
                                        je mvfbfc3;
                                        cmp bx, 1278;
                                         je mvfbfc3;
                                         cmp bx, 1438;
                                        je mvfbfc3;
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                         jne bxfinderc3;

mvfbfc3:                         add bx ,2;
                                        mov cx, bx;
                                        mov bx, si;
                                        sub bx, 2;
                                        jmp cxfinderc3;

c3bclcc2:                         jmp c3bcloopcatercondition2

cond3ballhitsj:                    jmp cond3ballhit;

cxfinderc3:                         add bx, 2;
                                         cmp bx, 1118;
                                         je debugerrorfixc3;
                                         cmp bx, 1278;
                                         je debugerrorfixc3;
                                         cmp bx, 1758;
                                         je debugerrorfixc3;
                                         cmp bx, 1918;
                                         je debugerrorfixc3
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                          jne cxfinderc3;
                                         jmp defc3skip;

debugerrorfixc3:          add bx, 2;
defc3skip:                      mov dx, bx;

;here we now have the cx (the most left side of the block) and the dx (the most right side of the block);

                                        mov bp, sp;
                                        sub sp, 6;
                                        mov [bp-2], cx;
                                        mov [bp-4], dx;
                                        mov [bp-6], si;   ;this is where the ball hits

checkcaseforsameblockc3:  mov bx, cx;
                                         mov dl, [es:bx+160];   ;dl now stores the part above this 
                                         mov dh, [es:bx];          dh stores the lower part;
                                         cmp dh, dl;
                                         je addloopersc3;
                                         jmp subtractloopersc3;
                                                             
addloopersc3:                     mov dx, [bp-4];
                                         mov bx, cx;
loopclearc3:                        mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                         jne loopclearc3;
                                         add cx, 160;
                                         add dx, 160;
                                         mov bx, cx;

loopclearc3pt2:                   mov word [es:bx], 0x0720;
                                         add bx, 2;  
                                         cmp bx, dx;
                                         jne loopclearc3pt2;
                                         jmp c3bcloopcaterforblock;

subtractloopersc3:               mov dx, [bp-4];
                                          mov bx, cx;
loopclearc32:                       mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                         jne loopclearc32;
                                         sub cx, 160;
                                         sub dx, 160;
                                         mov bx, cx;

loopclearc3pt22:                   mov word [es:bx], 0x0720;
                                         add bx, 2;  
                                         cmp bx, dx;
                                         jne loopclearc3pt22;

c3bcloopcaterforblock:         mov cx, [bp-2];
                                         sub si, cx;
                                         mov cx, si;
                                         mov si, [bp-6];
                                         mov dx, [bp-4];
                                         sub dx, si;
                                         sub si, 158;
                                         cmp dx, cx;
                                         jl bccfxc3;
                                          jmp c3bcloopcater;

cond3ballhit:                        mov dx, [es:si+158];
                                          add si, 158;               ; finds a block at si+158
                                          cmp dl, '@';
                                          je differencechecksc3;
                                          jmp c3conditionrb;        ;if it doesnt find a block on the next index

differencechecksc3:              mov ax, 0xb800;         ;we have the ax where the ball touches
                                           mov es, ax;
                                           mov bp, sp;
                                           sub sp, 6; 
                                           mov [bp-2], si;        
                                           mov bx, 0;
                                           mov cx, 0;
                                           jmp bxloopc3;

bxloopc3:                            sub si, 2;
                                          add bx, 1;
                                          mov dx, [es:si];
                                          cmp dx, 0x0720;
                                          jne bxloopc3;

                                          mov si, [bp-2];
                                          mov cx, bx;
                                          mov bx, 0;
                                          jmp cxloopc3;

bccfxc3:                             jmp bccaterfordxc3

cxloopc3:                            add si, 2;
                                          add bx, 1;
                                          mov dx, [es:si];
                                          cmp dx, 0x0720;
                                          jne cxloopc3;
; bx and cx now both contain the indexes where the slide ends;

                                          mov si, [bp-2];
                       
                                          sub si, 158
                                          cmp bx, cx;
                                          ja c3bcloopcater;
                                          jl c3bcloopcater2;
                                          je c3bcloopcater3;

;____________________________________________________________ending the last ball check for /down

c3conditionrb:                      sub si, 158;
                                          jmp c3rb;

c3bcloopcater:                     mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition4; 

c3bcloopcater3:              mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition5; 

c3bcloopcatercondition2:    mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition2; 

 
bccaterfordxc3:                    mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition1; 

c3bcloopcater2:                   mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition1;
;----------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------
cond4bordercheck:               mov ax, 320;
                                           jmp c4bcloop;

c4bcloop:                             cmp si, ax;
                                           je c4bcloopcatertemp;
                                           add ax, 2;
                                           cmp ax, 478;
                                           jle c4bcloop;
                                           ja cond4bordercheck2;

cond4bordercheck2:              mov ax, 160;
                                           jmp c4bcloop2;

c4bcloop2:                           cmp si, ax;
                                           je c4bcloopcatertemp2;
                                           add ax, 160;
                                           cmp ax, 3680;
                                           jle c4bcloop2;
                                           jmp c4trajectoryblock;

c4trajectoryblock:                mov dx, [es:si-162];
                                          cmp dx, 0x0720;
                                          jne clearblockc4;
                                          jmp c4rb;

c4bcloopcatertemp:             jmp c4bcloopcater;

clearblockc4:                 mov bx, [scorecounter];
                                         add bx, 100;
                                         mov [scorecounter], bx; 
                                         mov ax, 34;
                                         push ax;
                                         mov ax, [scorecounter];
                                        push ax;
                                         call funcforprintinganumberonscreen;    
                                         call BEEP; 
                                         call functoreturnexit;                     
                                          mov ax, 0xb800;
                                          mov es, ax;
                                          sub si, 162;
                                          mov bx, si;
                                          mov cx, si;
                                          add bx, 2;
                                          jmp bxfinderc4;

c4bcloopcatertemp2:           jmp c4bcloopcater2;

bxfinderc4:                         sub bx, 2;
                                         cmp bx, 638;
                                         je mvfbfc4;
                                         cmp bx, 798;
                                        je mvfbfc4;
                                        cmp bx, 1278;
                                         je mvfbfc4;
                                         cmp bx, 1438;
                                        je mvfbfc4;
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                         jne bxfinderc4;

mvfbfc4:                         add bx, 2;
                                        mov cx, bx;
                                        mov bx, si;
                                        sub bx, 2;

cxfinderc4:                         add bx, 2;
                                         cmp bx, 1118;
                                         je debugerrorfixc4;
                                         cmp bx, 1278;
                                         je debugerrorfixc4;
                                         cmp bx, 1758;
                                         je debugerrorfixc4;
                                         cmp bx, 1918;
                                         je debugerrorfixc4
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                          jne cxfinderc4;
                                          jmp defc4skip;

debugerrorfixc4:          add bx,2;
defc4skip:                     mov dx, bx;

;here we now have the cx (the most left side of the block) and the dx (the most right side of the block);

                                        mov bp, sp;
                                        sub sp, 6;
                                        mov [bp-2], cx;
                                        mov [bp-4], dx;
                                        mov [bp-6], si;   ;this is where the ball hits

checkcaseforsameblockc4:  mov bx, cx;
                                         mov dl, [es:bx+160];   ;dl now stores the lowest part 
                                         mov dh, [es:bx];          dh stores the lower part;
                                         cmp dh, dl;
                                         je addloopersc4;
                                                             
subtractloopersc4:               mov dx, [bp-4];
                                         mov bx, cx;
loopclearc4:                        mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                         jne loopclearc4;
                                         sub cx, 160;
                                         sub dx, 160;
                                         mov bx, cx;

loopclearc4pt2:                   mov word [es:bx], 0x0720;
                                         add bx, 2;  
                                         cmp bx, dx;
                                         jne loopclearc4pt2;
                                         jmp c4bcloopcaterforblock;

addloopersc4:                    mov dx, [bp-4];
                                          mov bx, cx;
loopclearc42:                     mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                         jne loopclearc42;
                                         add cx, 160;
                                         add dx, 160;
                                         mov bx, cx;

loopclearc4pt22:                   mov word [es:bx], 0x0720;
                                         add bx, 2;  
                                         cmp bx, dx;
                                         jne loopclearc4pt22;

c4bcloopcaterforblock:         mov cx, [bp-2];
                                         sub si, cx;
                                         mov cx, si;
                                         mov si, [bp-6];
                                         mov dx, [bp-4];
                                         sub dx, si;
                                         cmp dx, cx;
                                         add si, 162;
                                         jl bccaterfordxc4;
                                         jmp c4bcloopcater;

c4bcloopcater:                     mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition3;  


bccaterfordxc4:                    mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition2; 

c4bcloopcater2:                   mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition1;
;----------------------------------------------------------------------------------------------------------------------
cond5bordercheck:           mov ax, 320;                               ;the 'up' condition
                                         jmp c5bcloop;

c5bcloop:                         cmp si, ax;
                                        je c5loopcatertemp;
                                        add ax, 2;
                                        cmp ax, 478;
                                        jne c5bcloop;
                                        jmp blockcheck;

blockcheck:                     mov ax, 0xb800;
                                        mov es, ax;   
                                        mov dx, [es:si-160];
                                        cmp dx, 0x0720
                                        je c5rbtemp3;
                                        jmp inititatefinders;

c5loopcatertemp:       jmp c5loopcater;

inititatefinders:                mov bx, [scorecounter];
                                         add bx, 100;
                                         mov [scorecounter], bx; 
                                         mov ax, 34;
                                         push ax;
                                         mov ax, [scorecounter];
                                        push ax;          
                                         call funcforprintinganumberonscreen; 
                                         call BEEP;
                                         call functoreturnexit;   
                                           sub si, 160;  
                                          mov bx, si;
                                        mov cx, 0;
                                        mov dx, 0;
                                         jmp bxfinderc5;

c5rbtemp3:                  jmp c5rbtemp2;

bxfinderc5:                         sub bx, 2;
                                         cmp bx, 638;
                                         je mvfbfc5;
                                         cmp bx, 798;
                                        je mvfbfc5;
                                        cmp bx, 1278;
                                         je mvfbfc5;
                                         cmp bx, 1438;
                                        je mvfbfc5;
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                         jne bxfinderc5;

mvfbfc5:                         add bx, 2;
                                        mov cx, bx;           ;the most left side of the block
                                        mov bx, si;
                                        sub bx, 2;

cxfinderc5:                         add bx, 2;
                                         cmp bx, 1118;
                                         je debugerrorfixc5;
                                         cmp bx, 1278;
                                         je debugerrorfixc5;
                                         cmp bx, 1758;
                                         je debugerrorfixc5;
                                         cmp bx, 1918;
                                         je debugerrorfixc5
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                          jne cxfinderc5;
                                         jmp defc5skip;

debugerrorfixc5:          add bx, 2;
defc5skip:                     mov dx, bx;        ;the most right side of the block

;here we now have the cx (the most left side of the block) and the dx (the most right side of the block);

                                        mov bp, sp;
                                        sub sp, 6;
                                        mov [bp-2], cx;
                                        mov [bp-4], dx;
                                        mov [bp-6], si;   ;this is where the ball hits      
                                        jmp clearblockc5;


c5rbtemp2:                  jmp c5rbtemp;
  
clearblockc5:                    mov dx, [bp-4];
                                         mov bx, cx;
loopclearc5:                        mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                         jne loopclearc5;
                                         sub cx, 160;
                                         sub dx, 160;
                                         mov bx, cx;

loopclearc5pt2:                mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                         jne loopclearc5pt2;
                                         add si, 160;
                                         jmp c5loopcater;    

c5loopcater:                        mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition6;                                                                 
;--------------------------------------------------------------------------------------------------------------------
cond6bordercheck:      mov ax, 3680;
                                           jmp lifec6check;                       ;in line from 3680 to 3840/3838

lifec6check:                    cmp si, ax;
                                          je l6cdetectslide;
                                          add ax, 2;
                                          cmp ax, 3840;
                                          je cc6tempers;
                                         jne lifec6check;

l6cdetectslide:              mov ax, 0xb800;
                                         mov es, ax;
                                         mov bx, [es:si];
                                         cmp bx, 0x0720;
                                         jne simpledecrementc61;
                                         jmp checkcontinuec6;

;_____________________________________
funcforlowbarclear:      mov bx, 3680;
loopflbc:                          mov word [es:bx], 0x0720;
                                          add bx, 2;
                                          cmp bx, 3840;
                                          jne loopflbc;
                                          ret;
;_____________________________________

simpledecrementc61:      call BEEPFORMISS
                                        mov bl, [heartcounter];
                                         cmp bl, 3;
                                         je simpledecrementc62;
                                         cmp bl, 2;
                                         je simpledecrementc63;
                                         cmp bl, 1;
                                         je simpledecrementc64;

simpledecrementc62: mov ax, 0xb800;
                                         mov es, ax;
                                         mov word[es:148], 0x0720;
                                         mov bl, [heartcounter];
                                         sub bl, 1;
                                         mov [heartcounter], bl;
                                         call funcforlowbarclear;
                                         call slideballprint;
                                         mov di, 3680;
                                         mov si, 3530;
                                         mov bl, 0;
                                         mov [ballrelease], bl;
                                         jmp lfbctemp2;

cc6tempers:                  jmp checkcontinuec6;

simpledecrementc63: mov ax, 0xb800;
                                         mov es, ax;
                                        mov word[es:146], 0x0720;
                                         mov bl, [heartcounter];
                                         sub bl, 1;
                                         mov [heartcounter], bl;
                                        call funcforlowbarclear;
                                         call slideballprint;
                                         mov di, 3680;
                                         mov si, 3530;
                                         mov bl, 0;
                                         mov [ballrelease], bl;
                                         jmp lfbctemp2;

simpledecrementc64: mov ax, 0xb800;
                                         mov es, ax;
                                         mov word[es:144], 0x0720;
                                         mov bl, [heartcounter];
                                         sub bl, 1;
                                         mov [heartcounter], bl;
                                         call funcforlowbarclear;
                                         call slideballprint;
                                         mov di, 3680;
                                         mov si, 3530;
                                         mov bl, 0;
                                         mov [ballrelease], bl;
                                         jmp lfbctemp2;
;----------------------------------------------------------------------------------------------------------heartcounterend          

checkcontinuec6:       mov ax, 0xb800;
                                        mov es, ax;   
                                        mov dx, [es:si+160];
                                        cmp dx, 0x0720
                                        je c6rbtemp4;
                                        cmp dl, '@';
                                        je dscsc6temp2;
                                        jmp initiatefindersc6;

initiatefindersc6:         mov bx, [scorecounter];
                                       add bx, 100;
                                       mov [scorecounter], bx;   
                                         mov ax, 34;
                                         push ax;
                                         mov ax, [scorecounter];
                                        push ax;
                                         call funcforprintinganumberonscreen; 
                                         call BEEP;
                                         call functoreturnexit;   
                                       add si, 160;   
                                        mov bx, si;
                                        mov cx, 0;
                                        mov dx, 0;
                                       jmp bxfinderc6;

c6rbtemp4:                  jmp c6rbtemp3; 

dscsc6temp2:                 jmp dscsc6temp

bxfinderc6:                         sub bx, 2;
                                         cmp bx, 638;
                                         je mvfbfc6;
                                         cmp bx, 798;
                                        je mvfbfc6;
                                        cmp bx, 1278;
                                         je mvfbfc6;
                                         cmp bx, 1438;
                                        je mvfbfc6;
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                         jne bxfinderc6;

mvfbfc6:                         add bx, 2;
                                        mov cx, bx;           ;the most left side of the block
                                        mov bx, si;
                                        sub bx, 2;

cxfinderc6:                         add bx, 2;
                                         cmp bx, 1118;
                                         je debugerrorfixc6;
                                         cmp bx, 1278;
                                         je debugerrorfixc6;
                                         cmp bx, 1758;
                                         je debugerrorfixc6;
                                         cmp bx, 1918;
                                         je debugerrorfixc6
                                         mov dx, [es:bx];
                                         cmp dx, 0x0720;
                                          jne cxfinderc6;
                                         jmp defc6skip;

c6rbtemp3:                  jmp c6rbtemp2; 

debugerrorfixc6:          add bx, 2;
defc6skip:                      mov dx, bx;        ;the most right side of the block

;here we now have the cx (the most left side of the block) and the dx (the most right side of the block);

                                        mov bp, sp;
                                        sub sp, 6;
                                        mov [bp-2], cx;
                                        mov [bp-4], dx;
                                        mov [bp-6], si;   ;this is where the ball hits     
                                        jmp clearblockc6;

dscsc6temp:                 jmp differenceschecksc6

lfbctemp2:                   jmp lfbctemp;

c6rbtemp2:                  jmp c6rbtemp; 
  
clearblockc6:                    mov dx, [bp-4];
                                         mov bx, cx;
loopclearc6:                        mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                         jne loopclearc6;
                                         sub cx, 160;
                                         sub dx, 160;
                                         mov bx, cx;

loopclearc6pt2:                mov word [es:bx], 0x0720;
                                         add bx,2;
                                         cmp bx, dx;
                                        sub si, 160;
                                         jne loopclearc6pt2;
                                         jmp c6bcloopcater3;  
                    
differenceschecksc6:          mov ax, 0xb800;         ;we have the ax where the ball touches
                                           mov es, ax;
                                           mov bp, sp;
                                           sub sp, 6; 
                                          add si, 160;                ;this now points to the slide;
                                           mov [bp-2], si;        
                                           mov bx, 0;
                                           mov cx, 0;
                                           jmp bxloopc6;

bxloopc6:                            sub si, 2;
                                          add bx, 1;
                                          mov dx, [es:si];
                                          cmp dx, 0x0720;
                                          jne bxloopc6;

                                          mov si, [bp-2];
                                          mov cx, bx;
                                          mov bx, 0;
                                          jmp cxloopc6;

c5rbtemp:                       jmp c5rb;
c6rbtemp:                       jmp c6rb;
      

cxloopc6:                            add si, 2;
                                          add bx, 1;
                                          mov dx, [es:si];
                                          cmp dx, 0x0720;
                                          jne cxloopc6;
; bx and cx now both contain the indexes where the slide ends;

                                          mov si, [bp-2];
                       
                                          sub si, 160
                                          cmp bx, cx;
                                          ja c6bcloopcater2;
                                          jl c6bcloopcater;
                                          je c6bcloopcater3; 

lfbctemp:                           jmp loopforballcheck 

c6bcloopcater:                    mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition1;

c6bcloopcater2:                   mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition4;    

c6bcloopcater3:                  mov ax, 0xb800;
                                           mov es, ax;
                                           mov word[es:si], '0';
                                           jmp condition5;  

;--------------------------------------------------------------------------------------------------------------------                                                                  
checkloopandrun:                  mov ax, 0xb800
                                             mov es, ax;
                                             jmp condition5;

condition1:                            jmp cond1bordercheck;                  ;/ up
c1rb:                                     sub si, 158;
                                            mov byte [es:si], '0';
                                            mov word[es:si+158], 0x0720
                                            call delay;
                                         call functoreturnexit;   
                                            jmp condition1;

condition2:                            jmp cond2bordercheck;                    ;\ down
c2rb:                                    add si, 162;
                                            mov byte [es:si], '0';
                                            mov word[es:si-162], 0x0720
                                            call delay;
                                         call functoreturnexit;   
                                            jmp condition2;

condition3:                            jmp cond3bordercheck;                      ;/ down
c3rb:                                     add si, 158;
                                            mov byte [es:si], '0';
                                            mov word[es:si-158], 0x0720
                                            call delay;
                                         call functoreturnexit;   
                                            jmp condition3;

condition4:                             jmp cond4bordercheck;
c4rb:                                     sub si, 162;                                        ; \up
                                            mov byte [es:si], '0';
                                            mov word[es:si+162], 0x0720
                                            call delay;
                                         call functoreturnexit;   
                                            jmp condition4;

condition5:                             jmp cond5bordercheck;
c5rb:                                     sub si, 160;                                        ; | up
                                            mov byte [es:si], '0';
                                            mov word[es:si+160], 0x0720
                                            call delay;
                                         call functoreturnexit;   
                                            jmp condition5;

condition6:                             jmp cond6bordercheck;
c6rb:                                     add si, 160;                                        ; | down
                                            mov byte [es:si], '0';
                                            mov word[es:si-160], 0x0720
                                            call delay;
                                            call functoreturnexit;   
                                            jmp condition6;
                                                                               
;----------------------------------------------------------------------------------------------------------------------
gameplay:                              mov di, 3680;              ;moving the starting point of the slide till 3860
                                                 mov si, 3530;               ;the starting point of the ball
                                                 
                                                   xor ax, ax
		              mov es, ax

		              cli
		              mov word [es:9*4], kbisr	
		              mov [es:9*4+2], cs
                                                   sti;

loopforballcheck:                  mov cl, [ballrelease];
                                                 cmp cl, 0;
                                                je loopforballcheck;
                                                   
                                            			
gameplayloop:                        jmp checkloopandrun;
glloopreturn:                           jmp gameplayloop;					

;----------------------------------------------------------------------------------------------------------------------
wcloopings:                         mov ax, 0xb800
                                               mov es, ax;
                                               mov si, m01;
                                               mov di, 234;

                                              mov ah, 11;

printwcloop:                        mov al, [si];
                                               mov [es:di], ax;
                                               add si, 1;
                                               add di, 4;
                                               mov bl, [si];
                                               cmp bl, '0';
                                               jne printwcloop;

                                               mov ah, 19;
                                               mov si, m02;
                                               mov di, 388;

printm02:                             mov al, [si];
                                               mov [es:di], ax;
                                               add si, 1;
                                               add di, 4;
                                               mov bl, [si];
                                               cmp bl, '0';
                                               jne printm02;	

                                               mov di, 1462;                                   ;start line from 976
                                                mov si, m1;
                                                mov ah, 0xA;                                    

pwcl1:                                   mov al, [si];
                                               mov [es:di], ax;
                                               add si, 1;
                                               add di, 2;
                                               mov bl, [si];
                                               cmp bl, '0';
                                               jne pwcl1;      

                                               ;subtract 480 from di, and add 10;
                                                mov si, 976;
                                                sub di, 480;
                                                add di, 12;
                                                mov al, 1;
                                                mov ah, 0xE;

lineloop1:                              mov [es:si], ax;
                                                add si, 2;
                                                cmp si, di;
                                                jne lineloop1;                           

                                               mov di, 1782; 
                                                mov si, m2;
                                                mov ah, 0xA;

pwcl2:                                   mov al, [si];
                                               mov [es:di], ax;
                                               add si, 1;
                                               add di, 2;
                                               mov bl, [si];
                                               cmp bl, '0';
                                               jne pwcl2;

                                               mov di, 2102;
                                                mov si, m3;
                                                mov ah, 0xA;

pwcl3:                                   mov al, [si];
                                               mov [es:di], ax;
                                               add si, 1;
                                               add di, 2;
                                               mov bl, [si];
                                               cmp bl, '0';
                                               jne pwcl3;    

                                               mov di, 2422;
                                                mov si, m4;
                                                mov ah, 0xA;

;start from 2732

pwcl4:                                   mov al, [si];
                                               mov [es:di], ax;
                                               add si, 1;
                                               add di, 2;
                                               mov bl, [si];
                                               cmp bl, '0';
                                               jne pwcl4;       

;end at d1+160+10


                                               ;subtract 480 from di, and add 12;
                                                mov si, 2736;
                                                mov di, 2866;
                                                mov al, 1;
                                                mov ah, 0xE;

lineloop2:                              mov [es:si], ax;
                                                add si, 2;
                                                cmp si, di;
                                                jne lineloop2;   
                                                
                                               mov si, 1136;
                                               mov di, 1264;

lineloop3:                             mov [es:si], ax;
                                                mov [es:di], ax;
                                               add si, 160;
                                               add di, 160;
                                               cmp si, 2736;
                                               jne lineloop3;     

                                              mov si, 862;
                                              mov di, 902;
                                              mov ah, 0xC;

lineloop4:                           mov [es:si], ax;
                                             mov [es:di], ax;
                                             sub si, 160;
                                             sub di, 160;
                                             cmp si, 62;
                                             jne lineloop4;                                                   

                                               mov di, 3250;
                                                mov si, m5;
                                                mov ah, 0x89;

pwcl5:                                   mov al, [si];
                                               mov [es:di], ax;
                                               add si, 1;
                                               add di, 2;
                                               mov bl, [si];
                                               cmp bl, '0';
                                               jne pwcl5;  

                                              add di, 4;
                                              sub di, 320;
                                              mov si, 2924;
                                              mov ah, 0xC
                                              mov al, 1;

linelooplast:                        mov [es:si], ax;
                                               mov [es:di], ax;
                                               add si, 160;
                                               add di, 160;
                                               cmp si, 3564
                                              jne linelooplast;

                                             mov di, 3920;
                                             mov al, 1;
                                             mov ah, 0x86;
                                            mov si, 3918;
                                             mov bl, 1;
                                             mov bh, 0x89;
loopingswx:                       mov ax, 0;
                                             mov ah, 0;
                                             int 0x16;
                                            cmp al, 32;
                                            je exitwc;
                                            jmp loopingswx;                                
;----------------------------------------------------------------------------------------------------------------------
welcomescreen:                    		                    		                                               							
loopforwx:                               jmp wcloopings;
                                                
exitwc:                                     jmp nextparse;                                 
;----------------------------------------------------------------------------------------------------------------------
functoreturnexit:                     mov bx, [scorecounter];
                                                 cmp bx, 5400;
                                                 je exitsafe;
                                                 mov bl, [heartcounter];
                                                 cmp bl, 0;
                                                 je exitsafe;
                                                 jmp returnsafe;

exitsafe:                                call  clrscr;
                                               call titleprintforexit;
                                                jmp exit; 
returnsafe:                             ret;
;----------------------------------------------------------------------------------------------------------------------


start:                                         call clrscr;
                                                  jmp welcomescreen;

nextparse:                               call clrscr;
                                                  mov ax, 640;          
                                                 push ax;   ;pushing the rows and columns
                                                 mov ax, 3;
                                                 push ax;     pushes the colors;

                                                 call pb;                             ;[bp+0]
                                                 call slideballprint;
                                                 call titleprint;
                                                 call gameplay;                                                                 
                
exit:                                         mov ax, 0x4c00;
                                                int 0x21