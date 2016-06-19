@TEXT	LENGTH<100
@PATTERN LENGTH <32
@TEXT OR PATTERN DONT HAVE SPACES

	.text
	.global main

main:
	@***********************
	sub sp,sp,#4
	str lr,[sp,#0]
	@***********************

	ldr     r0,=formattext
	bl      printf	
	
	@*************************
	
	@ALLOCATING stack FOR  TEXT
	sub sp,sp,#100		
	
	@************************
	
	@GET TEXT	
	ldr     r0,=formatsf
	mov     r1,sp
	bl      scanf
	
	@STORE TEXT SP
	mov	r4,sp
	
	@GET TEXT LENGTH
	bl      stringLen
	
	@STORE TEXT LENGTH
	mov     r5,r0
 
	@ALLOCATING FOR PATTERN

	sub sp,sp,#32		
	
	ldr     r0,=formatpattern
	bl      printf	
		
	@GET PATTERN
	
	ldr     r0,=formatsf
	mov     r1,sp
	bl      scanf

	@STORE PATTERN SP
	mov	r6,sp
	
	@GET PATTERN LENGTH
	bl      stringLen
	
	@STORE PATTERN LENGTH
	mov     r7,r0

	

	@CALL BITAPSEARCH
	bl	bitapsearch
	
	
	
	@REALISING STACK
	add     sp,sp,#132	

	@**********************
	ldr lr,[sp,#0]
	add sp,sp,#4
	mov pc,lr
	@*********************
 

@*************Functions**********
stringLen:

	@STORE SP IN R7
	mov     r7,sp
	
	@STORE LR IN STACK
	sub 	sp,sp,#4
	str     lr,[sp,#0]
	
	@STORE VALUES IN REGISTORS
	sub     sp,sp,#12

	str     r4,[sp,#0]
	str     r5,[sp,#4]
	str     r6,[sp,#8] 

	
	
	@MOVING R7 INTO R6

	mov     r6,r7

	@INITIALIZING COUNTING
	mov     r5,#0
	
loop:	 
	ldrb	r4, [r6]
	cmp     r4,#0

	beq     exit	

	add	r5,r5,#1
	add 	r6,r6,#1
	b       loop	
	

exit:
	@RETURN RESULT
	mov	r0,r5
	
	@RESTORE REGISTORS
	ldr     r4,[sp,#0]
	ldr     r5,[sp,#4]
	ldr     r6,[sp,#8] 

	@RELEASE STACK

	add 	sp,sp,#12

	@RETURN FROM stringLen
	ldr 	lr,[sp]
	add     sp,sp,#4
	mov 	pc,lr 

@********************************

bitapsearch:
	@r4=TEXT SP
	@r5=TEXT LENGTH
	@r6=PATTERN SP
	@r7=PATTERN LENGTH

	

	@STORE LR IN STACK
	sub 	sp,sp,#4
	str     lr,[sp,#0]
	
	

	@CHECK PATTERN LENGTH
	
	cmp  	r7,#0
	
	@PATTERN LENGTH=0
	beq	bitapsearch_Exit		
	
	
	@RUN UNTILL TEXT OVER

	@INDEX FOR LOOP_FOR1===r2 {i}	
	mov	r2,#0
	
	
	@BIT_ARRYA
	mov 	r8,#1

loop_for1:
	
	
	@INDEX FOR LOOP_FOR2===r3 {K}	
	mov	r3,r7
	
	
loop_for2:

	@R[k] = R[k-1] & (text[i] == pattern[k-1])
	
	@(k-1)
	sub	r3,r3,#1

	@BIT_MASK	
	mov	r9,#1
	
	@GET BIT VALUE IN BIT_ARRYA PO:K-1
	lsl	r9,r3
	and	r9,r8,r9
	lsr	r9,r3
	
	@EVALUVATE (text[i] == pattern[k-1])
	bl	stringmatch
	
	@R[k-1] & (text[i] == pattern[k-1])		
	and	r10,r9,r0
	
	@REINITIATES K
	add	r3,r3,#1
	
	@STORE RESULT IN BIT_ARRAY
	lsl	r10,r3
	orr	r8,r8,r10
	

	@RUN LOOP_FOR2///////////////////////
	cmp	r3,#1
	sub	r3,r3,#1
	bne	loop_for2

	@CHECK FOR MATCH
	
	@BIT_MASK
	mov	r9,#1
	
	@GET BIT VALUE IN BIT_ARRYA PO:K
	lsl	r9,r7
	and	r9,r8,r9
	lsr	r9,r7
	cmp	r9,#1	
	
	beq	bitapsearch_Exit_ok	
	
	@RUN LOOP_FOR1//////////////////////
	add	r2,r2,#1
	cmp	r2,r5
	bne	loop_for1
	
	
	
bitapsearch_Exit:
	
	
	@RETURN FROM  bitapsearch
	ldr 	lr,[sp]
	add     sp,sp,#4
	mov 	pc,lr 

bitapsearch_Exit_ok:
	@GET THE POAITION OF TEXT
	sub	r2,r2,r7
	add	r2,r2,#1

	ldr	r0,=formatfinal
	mov	r1,r6
	mov	r3,r4
	bl	printf

	@RETURN FROM  bitapsearch
	ldr 	lr,[sp]
	add     sp,sp,#4
	mov 	pc,lr
 
@*********stringmatch********
stringmatch:
	@STORE LR IN STACK
	sub 	sp,sp,#4
	str     lr,[sp,#0]
	
	@STORE r7 AND r8
	sub  	sp,sp,#8
	str	r7,[sp,#0]
	str	r8,[sp,#4]	
	
	@INDEX FOR TEXT==r8
	@INDEX FOR PATTERN===r9
	@r4=TEXT SP
	@r6=PATTERN SP
	
loop_stringmatch:

	@LOAD BYTE FROM TEXT AND PATTERN
	ldrb	r7,[r4,r2]			
	ldrb	r8,[r6,r3]	
		
	@COMPARING PATTERN[INDEX_PATTERN]==TEXT[INDEX_TEXT]	
	cmp	r7,r8
	bne	loop_stringmatch_return_0
	
loop_stringmatch_return_1:
					
	@RELEASING STACK OF r4 AND r5
	ldr	r7,[sp,#0]
	ldr	r8,[sp,#4]
	add 	sp,sp,#8
	
	@SET 1
	mov	r0,#1

	@RETURN FROM  stringmatch
	ldr 	lr,[sp]
	add     sp,sp,#4
	mov 	pc,lr 

loop_stringmatch_return_0:

	@RELEASING STACK OF r4 AND r5
	ldr	r7,[sp,#0]
	ldr	r8,[sp,#4]
	add 	sp,sp,#8

	@SET 0
	mov	r0,#0

	@RETURN FROM  stringmatch
	ldr 	lr,[sp]
	add     sp,sp,#4
	mov 	pc,lr 
@***************************************
@*******data**********************

	.data

formattext: .asciz "Enter Text:"
formatpattern: .asciz "Enter the pattern:"
formatnumprint: .asciz "%d\n"		
formatsf: .asciz "%s"
formatfinal: .asciz "%s is at position %d in the text %s\n"
		
