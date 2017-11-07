#  6502 Assembly ca65 Boilerplate

This is a boilerplate that should be used as a starting point for the creation of classic NES games in 6502 assembly.

## Set Up

You will need the `ca65` assembler in order to assemble the `.s` file

You can install `ca65` with hombrew using:

    brew install cc65

## Assembling

Once this has been installed you can `cd` into this repository and run:

    ca65 boilerplate.s

This will generate a `.o` file, you will then need to run the following:

    ld65 boilerplate.o -o boilerplate.nes -C nesfile.ini
    
This will create your `.nes` file which will be playable in a NES emulator!
