(TOP)
  @8191
  D=A
  @I
  M=D

(SCREEN_LOOP)
  @SCREEN
  D=A

  @I
  D=D+M

  @PIXEL
  M=D

  @KBD
  D=M
  @BLACK
  D;JGT

  @PIXEL
  A=M
  M=0
  
  @DRAWN
  0;JMP

(BLACK)
  @0
  D=!A

  @PIXEL
  A=M
  M=D

(DRAWN)
  @I
  D=M-1
  M=D

  @SCREEN_LOOP
  D;JGE

(SCREEN_LOOP_END)
  @TOP
  0;JMP