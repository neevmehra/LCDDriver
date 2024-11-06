// BusyWait.s
// Student names: Neev Mehra & Silly Oscar Portillo
// Last modification date: 10/21/2024

// Note: these functions do not actually output to SPI or Port A. 
// They are called by the grader to see if the functions would work

// As part of Lab 6, students need to implement these two functions

      .global   SPIOutCommand
      .global   SPIOutData
      .text
      .align 2

// ***********SPIOutCommand*****************
// This is a helper function that sends an 8-bit command to the LCD.



// Inputs: R0 = 32-bit command (number)
//         R1 = 32-bit SPI1->STAT, SPI status register address
//         R2 = 32-bit SPI1->TXDATA, SPI tx data register address
//         R3 = 32-bit GPIOA->DOUTCLR31_0, PA13 is D/C
// Outputs: none
// Assumes: SPI and GPIO have already been initialized and enabled
// Note: must be AAPCS compliant
// Note: using the clear register to clear will make it friendly
SPIOutCommand:
// --UUU-- Code to write a command to the LCD
//1) Read the SPI status register (R1 has address of SPI1->STAT) and check bit 4,
//2) If bit 4 is high, loop back to step 1 (wait for BUSY bit to be low)
//3) Clear D/C (GPIO PA13) to zero, be friendly (R3 has address of GPIOA->DOUTCLR31_0)
//    Hint: simply write 0x2000 to GPIOA->DOUTCLR31_0
//4) Write the command to the SPI data register (R2 has address of SPI1->TXDATA)
//5) Read the SPI status register (R1 has address of SPI1->STAT) and check bit 4,
//6) If bit 4 is high, loop back to step 5 (wait for BUSY bit to be low)
   PUSH {R4, R5, LR}

	//R1 has address of SPI1->STAT
	BIT4HIGH:
	LDR R5, [R1] //1) Read the SPI status register (R1 has address of SPI1->STAT) and check bit 4,
	MOVS R4, #16
	ANDS R5, R4
	BNE BIT4HIGH //2) If bit 4 is high, loop back to step 1 (wait for BUSY bit to be low)

	LDR R5, =0x2000
	STR R5, [R3] //3) Clear D/C (GPIO PA13) to zero, be friendly (R3 has address of GPIOA->DOUTCLR31_0)

	STR R0, [R2] //4) Write the command to the SPI data register (R2 has address of SPI1->TXDATA)

	BIT4HIGH2:
	LDR R5, [R1] //5) Read the SPI status register (R1 has address of SPI1->STAT) and check bit 4
	MOVS R4, #16
	ANDS R5, R4
	BNE BIT4HIGH2 //6) If bit 4 is high, loop back to step 5 (wait for BUSY bit to be low)

    POP {R4, R5, PC}    //   return



// ***********SPIOutData*****************
// This is a helper function that sends an 8-bit data to the LCD.
// Inputs: R0 = 32-bit data (number)
//         R1 = 32-bit SPI1->STAT, SPI status register address
//         R2 = 32-bit SPI1->TXDATA, SPI data register address
//         R3 = 32-bit GPIOA->DOUTSET31_0, PA13 is D/C
// Outputs: none
// Assumes: SPI and GPIO have already been initialized and enabled
// Note: must be AAPCS compliant
// Note: using the set register to clear will make it friendly
SPIOutData:
// --UUU-- Code to write data to the LCD
//1) Read the SPI status register (R1 has address of SPI1->STAT) and check bit 1,
//2) If bit 1 is low, loop back to step 1 (wait for TNF bit to be high)
//3) Set D/C (GPIO PA13) to one, be friendly (R3 has address of GPIOA->DOUTSET31_0)
//    Hint: simply write 0x2000 to GPIOA->DOUTSET31_0
//4) Write the data to the SPI data register (R2 has address of SPI1->TXDATA)
   PUSH {R4, R5, LR}

   BIT1LOW:

	LDR R4, [R1]
	MOVS R5, #2
	ANDS R4, R5
	BEQ BIT1LOW

	LDR R4, =0x2000
	STR R4, [R3]

	STR R0, [R2]

    POP {R4, R5, PC}    //   return
//****************************************************

    .end
