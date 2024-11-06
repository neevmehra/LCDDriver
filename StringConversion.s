// StringConversion.s
// Student names: change this to your names or look very silly
// Last modification date: change this to the last modification date or look very silly
// Runs on any Cortex M0
// ECE319K lab 6 number to string conversion
//
// You write udivby10 and Dec2String
     .data
     .align 2
// no globals allowed for Lab 6
    .global OutChar    // virtual output device
    .global OutDec     // your Lab 6 function
    .global Test_udivby10

    .equ i4, 0
    .equ i3, 4
    .equ i2, 8
    .equ i1, 12
    .equ i0, 16

    .text
    .align 2

// **test of udivby10**
// since udivby10 is not AAPCS compliant, we must test it in assembly
Test_udivby10:
    PUSH {LR}

    MOVS R0,#123
    MOVS R1, #10
    BL   udivby10
// put a breakpoint here
// R0 should equal 12 (0x0C)
// R1 should equal 3

    LDR R0,=12345
    MOVS R1, #10
    BL   udivby10
// put a breakpoint here
// R0 should equal 1234 (0x4D2)
// R1 should equal 5

    MOVS R0,#0
    BL   udivby10
// put a breakpoint here
// R0 should equal 0
// R1 should equal 0
    POP {PC}

//****************************************************
// divisor=10
// Inputs: R0 is 16-bit dividend
// quotient*10 + remainder = dividend
// Output: R0 is 16-bit quotient=dividend/10
//         R1 is 16-bit remainder=dividend%10 (modulus)
// not AAPCS compliant because it returns two values
udivby10:
// write this
// Inputs: R0 is 32-bit dividend
//         R1 is 16-bit divisor
// quotient*divisor + remainder = dividend
// Output: R0 is 16-bit quotient, assuming it fits
//         R1 is 16-bit remainder (modulus)

udiv32_16:
    PUSH {R4,LR}
    LDR  R4,=0x00010000 // bit mask
    MOVS R3,#0  // quotient
    MOVS R2,#16 // loop counter
    LSLS R1,#15 // move divisor under dividend
udiv32_16_loop:
    LSRS R4,R4,#1 // bit mask 15 to 0
    CMP  R0,R1    // need to subtract?
    BLO  udiv32_16_next
    SUBS R0,R0,R1 // subtract divisor
    ORRS R3,R3,R4 // set bit
udiv32_16_next:
    LSRS R1,R1,#1
    SUBS R2,R2,#1
    BNE  udiv32_16_loop
    MOVS R1,R0   // remainder
    MOVS R0,R3   // quotient
    POP  {R4,PC}

//-----------------------OutDecNew-----------------------
// Convert a 16-bit number into unsigned decimal format
// Call the function OutChar to output each character
// You will call OutChar 1 to 5 times
// OutChar does not do actual output, OutChar does virtual output used by the grader
// Input: R0 (call by value) 16-bit unsigned number
// Output: none
// Invariables: This function must not permanently modify registers R4 to R11
OutDec:
   //MOVS R1, #0

   PUSH {R4-R7, LR}
// write this
.equ firstdigit,0
.equ secondbyte, 4

    SUB SP, SP, #20 // allocate 5 words to memory since we are calling OutChar 1 to 5 times.

PUSHINGSTACKNew:
    MOV R7, SP

    // top
    MOVS R1, #10
    BL     udivby10
    ADDS R1, #48
    STR R1, [R7, #i4]
    CMP R0, #0
    BEQ popi0

    // top +4
    MOVS R1, #10
    BL     udivby10
    ADDS R1, #48
    STR R1, [R7, #i3]
    CMP R0, #0
    BEQ popi1

    // top +8
    MOVS R1, #10
    BL     udivby10
    ADDS R1, #48
    STR R1, [R7, #i2]
    CMP R0, #0
    BEQ popi2

    // top +12
    MOVS R1, #10
    BL     udivby10
    ADDS R1, #48
    STR R1, [R7, #i1]
    CMP R0, #0
    BEQ popi3

    // top +16
    MOVS R1, #10
    BL     udivby10
    ADDS R1, #48
    STR R1, [R7, #i0]
    CMP R0, #0
    BEQ popi4


POPPINGSTACKNew:

popi4:
    // top +16
    LDR R0, [R7, #i0]
    BL OutChar

popi3:
    // top +12
    LDR R0, [R7, #i1]
    BL OutChar

popi2:
    // top +8
    LDR R0, [R7, #i2]
    BL OutChar

popi1:
    // top +4
    LDR R0, [R7, #i3]
    BL OutChar

popi0:
    // top
    LDR R0, [R7, #i4]
    BL OutChar


    DONENew:

    ADD SP, SP, #20

   POP  {R4-R7, PC}
