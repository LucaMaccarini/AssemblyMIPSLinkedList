# LinkedList in Assembly MIPS

<img src="MIPS linked list.png" alt="Project image" width="300"/>

## Description
I have implemented the linked list data structure in assemby MIPS and I have made a brief report in Italian that you can find in the repository and it is called "specifica.docx".

Being all sources written in assemby MIPS they are well commented to ensure an excellent reading of the source code.

## How to run the code
- install latest the java JVM
- clone the repository
- execute with java the file Mars4_5.jar
- inside the mars program is important to:
  - file > open and select the file sorgenti/main.asm
  - settings > check "assembre all files in directory"
- now you can assemble and run the code

## Important note
The code uses the Bitmap Display tool, which should be set to a height and width of 128. To prevent Mars from freezing, it’s crucial to connect the Bitmap Display to the MIPS memory before running the program.

While the program is running, avoid interacting with or closing the tool; doing so during a syscall (since the main program is in a constant syscall waiting for input for the menu) can cause the entire simulator to freeze. You can only click the reset button on the tool during the execution. 

Make sure to stop the program before closing the tool!

## Color table
the code ask you to insert some color here for you a little color table:
Red: 16711680
Green: 65280
Blue: 255
