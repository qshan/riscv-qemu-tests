.include "test.s"

START

  # Basic tests

  TEST_LD_OP 2, lwu, 0x00ff00ff, 0,  tdat
  TEST_LD_OP 3, lwu, 0xff00ff00, 4,  tdat
  TEST_LD_OP 4, lwu, 0x0ff00ff0, 8,  tdat
  TEST_LD_OP 5, lwu, 0xf00ff00f, 12, tdat

  # Test with negative offset

  TEST_LD_OP 6, lwu, 0x00ff00ff, -12, tdat4
  TEST_LD_OP 7, lwu, 0xff00ff00, -8,  tdat4
  TEST_LD_OP 8, lwu, 0x0ff00ff0, -4,  tdat4
  TEST_LD_OP 9, lwu, 0xf00ff00f, 0,   tdat4

  # Test with a negative base

    la  x1, tdat
    addi x1, x1, -32
    lwu x3, 32(x1)
  TEST_CASE 10, x3, 0x00ff00ff

  # Test with unaligned base

    la  x1, tdat
    addi x1, x1, -3
    lwu x3, 7(x1)
  TEST_CASE 11, x3, 0xff00ff00

  # Bypassing tests

  TEST_LD_DEST_BYPASS 12, 0, lwu, 0x0ff00ff0, 4, tdat2
  TEST_LD_DEST_BYPASS 13, 1, lwu, 0xf00ff00f, 4, tdat3
  TEST_LD_DEST_BYPASS 14, 2, lwu, 0xff00ff00, 4, tdat1

  TEST_LD_SRC1_BYPASS 15, 0, lwu, 0x0ff00ff0, 4, tdat2
  TEST_LD_SRC1_BYPASS 16, 1, lwu, 0xf00ff00f, 4, tdat3
  TEST_LD_SRC1_BYPASS 17, 2, lwu, 0xff00ff00, 4, tdat1

  # Test write-after-write hazard

    la  x3, tdat
    lwu x2, 0(x3)
    li  x2, 2
  TEST_CASE 18, x2, 2

    la  x3, tdat
    lwu x2, 0(x3)
    nop
    li  x2, 2
  TEST_CASE 19, x2, 2

EXIT

.data

tdat:
tdat1:  .word 0x00ff00ff
tdat2:  .word 0xff00ff00
tdat3:  .word 0x0ff00ff0
tdat4:  .word 0xf00ff00f
