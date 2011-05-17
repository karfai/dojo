// *R2=0
  @R2
  M=0

(LOOP)
// D=*R0
  @R0
  D=M
// JMP to END if D == 0
  @END
  D;JEQ

// D=*R2
  @R2
  D=M

// D+=*R1
  @R1
  D=D+M

// *R2=D
  @R2
  M=D

// *R0=(*R0-1)
  @R0
  D=M-1
  M=D

// JMP to LOOP
  @LOOP
  0;JMP
(END)