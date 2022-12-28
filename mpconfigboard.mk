# MCU settings
MCU_SERIES = h7
CMSIS_MCU = STM32H750xx
MICROPY_FLOAT_IMPL = double
AF_FILE = boards/stm32h743_af.csv
LD_FILES = boards/WEACT_H750/stm32h750.ld

TEXT0_ADDR = 0x90000000
TEXT0_SECTIONS = .isr_vector .text .data
