(TOP)

  @8191
  D=A
  @R0
  D=D+A
  M=D

(SCREEN_LOOP)
// D=*R0
  @R0
  D=M
// JMP to END if D == 0
  @SCREEN_LOOP_END
  D;JLT

//  @KBD
//  D=M
//  @WHITE
//  D;JEQ

  @SCREEN
  D=A
  @R0
  D=D+M

  A=D
  M=1

//(WHITE)
//  @SCREEN
//  D=A
//  @R0
//  D=D+M

//  A=D
//  M=0

// *R0=(*R0-1)
  @R0
  D=M-1
  M=D

  @SCREEN_LOOP
  0;JMP

(SCREEN_LOOP_END)
  @TOP
  0;JMP