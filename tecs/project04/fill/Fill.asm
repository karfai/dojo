(TOP)
  @8191
  D=A
  @I
  M=D

(SCREEN_LOOP)
  @KBD
  D=M
  @BLACK
  D;JGT

  @SCREEN
  D=A

  @I
  D=D+M
  A=D
  M=0
  
  @DRAWN
  0;JMP

(BLACK)
  @SCREEN
  D=A

  @I
  D=D+M

  @WHERE
  M=D

  @0
  D=!A

  @WHERE
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