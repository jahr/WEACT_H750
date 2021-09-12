/*
    GNU linker script for STM32H750
*/

/* Specify the memory areas */
MEMORY
{
    FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 128K
    FLASH_EXT (rx)  : ORIGIN = 0x90000000, LENGTH = 8192K   /* external QSPI */
    DTCM (xrw)      : ORIGIN = 0x20000000, LENGTH = 128K    /* Used for storage cache */
    RAM (xrw)       : ORIGIN = 0x24000000, LENGTH = 512K    /* AXI SRAM */    
    RAM_D2 (xrw)    : ORIGIN = 0x30000000, LENGTH = 288K
}

/* produce a link error if there is not this amount of RAM for these sections */
_minimum_stack_size = 2K;
_minimum_heap_size = 16K;

/* Define the stack.  The stack is full descending so begins just above last byte
   of RAM.  Note that EABI requires the stack to be 8-byte aligned for a call. */
_estack = ORIGIN(RAM) + LENGTH(RAM) - _estack_reserve;
_sstack = _estack - 16K; /* tunable */

/* RAM extents for the garbage collector */
_ram_start = ORIGIN(RAM);
_ram_end = ORIGIN(RAM) + LENGTH(RAM);
_heap_start = _ebss; /* heap starts just after statically allocated memory */
_heap_end = _sstack;

ENTRY(Reset_Handler)

/* define output sections */
SECTIONS
{
    /* Define the code that goes in QSPI flash */
    .text_ext :
    {
        . = ALIGN(4);
        /**drivers/*(.text* .rodata*)*/ /* necessary */
        *extmod/*(.text* .rodata*)
        *frozen_mpy/*(.text* .rodata*)
        *lib/libm_dbl/*(.text* .rodata*)
        *lib/oofatfs/*(.text* .rodata*)
        /**lib/stm32lib/CMSIS/*(.text* .rodata*)*/ /* necessary */
        *lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_a*(.text* .rodata*)
        /**lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_c*(.text* .rodata*)*/ /* stm32h7xx_hal_cortex is necessary */
        *lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_d*(.text* .rodata*)
        *lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_f*(.text* .rodata*)
        *lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_g*(.text* .rodata*)
        *lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_i*(.text* .rodata*)
        *lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_m*(.text* .rodata*)
        /**lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_p*(.text* .rodata*)*/ /* necessary */
        /**lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_r*(.text* .rodata*)*/ /* necessary */
        *lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_s*(.text* .rodata*)
        *lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_t*(.text* .rodata*)
        *lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_u*(.text* .rodata*)
        *lib/stm32lib/STM32H7xx_HAL_Driver/Src/stm32h7xx_ll_*(.text* .rodata*)
        *py/*(.text* .rodata*)
        *shared/*(.text* .rodata*)
        *usbdev/*(.text* .rodata*)
        . = ALIGN(4);
    } >FLASH_EXT

    /* The startup code goes first into FLASH */
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector)) /* Startup code */
        . = ALIGN(4);
    } >FLASH

    /* The program code and other data goes into FLASH */
    .text :
    {
        . = ALIGN(4);
        *(.text*)          /* .text* sections (code) */
        *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
    /*  *(.glue_7)   */    /* glue arm to thumb code */
    /*  *(.glue_7t)  */    /* glue thumb to arm code */
        . = ALIGN(4);
        _etext = .;        /* define a global symbol at end of code */
    } >FLASH

    /* For C++ exception handling */
/*
    .ARM :
    {
        __exidx_start = .;
        *(.ARM.exidx*)
        __exidx_end = .;
    } >FLASH
*/

    /* Used by the start-up code to initialise data */
    _sidata = LOADADDR(.data);

    /* Initialised data section, start-up code will copy it from flash to RAM */
    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } >RAM AT> FLASH

    INCLUDE common_bss_heap_stack.ld
}
