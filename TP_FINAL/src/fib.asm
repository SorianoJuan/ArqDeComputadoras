# Fibonacci Casero papa
# Mira como estan esos comentarios

  ORI   $t0, $0, 13 # podes comentar aca si te pinta tambien
  ORI   $t2, $0, 1
  OR    $t4, $0, $0
  OR    $t3, $0, $0
  ADDU  $t1, $t2, $t4
  OR    $t4, $0, $t2
  OR    $t2, $0, $t1
  SLL   $t5, $t3, 2
  SW    $t1, 0($t5)
  ADDI  $t3, $t3, 1
  BNE   $t0, $t3, LOOP #lo comento porke me pinta
  HLT
LOOP:
  ORI   $t5, $0, 16 # que onda
  JR    $t5
