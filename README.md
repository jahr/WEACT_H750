# WEACT_H750


WEACT_H750 board definition for Micropython. Now it supports mboot.

Build steps:
- Go to the `ports/stm32` directory
- Go to the `mboot` subdir
- Run `make BOARD=WEACT_H750`
- Connect the board to the PC using ST-Link
- Flash the `firmware.hex` or `firmware.bin` from the subdir `build-WEACT_H750` using a favorite flashig app (e.g. STM32CubeProgrammer)
- Disconnect the ST-Link device
- Go back to the `ports/stm32` directory
- Run `make BOARD=WEACT_H750`
- Connect the board to the PC using USB
- Press and hold the user button, press the resset button and release the user button
- Flash the `firmware.dfu` from the subdir `build-WEACT_H750` using any DFU flashing application, e.g. `dfu-util -D firmware.dfu`
- Reset the board

The configuration is far from complete, it serves as a guide for creating custom Micropython board definitions.
