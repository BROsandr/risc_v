
result.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00001197          	auipc	gp,0x1
   4:	adc18193          	addi	gp,gp,-1316 # adc <_gbl_ptr>
   8:	76000113          	li	sp,1888
   c:	2dc00293          	li	t0,732
  10:	2dc00313          	li	t1,732

00000014 <_bss_init_loop>:
  14:	00628863          	beq	t0,t1,24 <_irq_config>
  18:	0002a023          	sw	zero,0(t0)
  1c:	00428293          	addi	t0,t0,4
  20:	ff5ff06f          	j	14 <_bss_init_loop>

00000024 <_irq_config>:
  24:	05000293          	li	t0,80
  28:	fff00313          	li	t1,-1
  2c:	00000397          	auipc	t2,0x0
  30:	7d438393          	addi	t2,t2,2004 # 800 <_interrupt_stack_ptr>
  34:	30529073          	csrw	mtvec,t0
  38:	30431073          	csrw	mie,t1
  3c:	34039073          	csrw	mscratch,t2

00000040 <_main_call>:
  40:	00000513          	li	a0,0
  44:	00000593          	li	a1,0
  48:	1fc000ef          	jal	ra,244 <main>

0000004c <_endless_loop>:
  4c:	0000006f          	j	4c <_endless_loop>

00000050 <_int_handler>:
  50:	34011173          	csrrw	sp,mscratch,sp
  54:	fb010113          	addi	sp,sp,-80
  58:	00112223          	sw	ra,4(sp)
  5c:	76000093          	li	ra,1888
  60:	fe1146e3          	blt	sp,ra,4c <_endless_loop>
  64:	00512623          	sw	t0,12(sp)
  68:	00612823          	sw	t1,16(sp)
  6c:	00712a23          	sw	t2,20(sp)
  70:	00a12c23          	sw	a0,24(sp)
  74:	00b12e23          	sw	a1,28(sp)
  78:	02c12023          	sw	a2,32(sp)
  7c:	02d12223          	sw	a3,36(sp)
  80:	02e12423          	sw	a4,40(sp)
  84:	02f12623          	sw	a5,44(sp)
  88:	03012823          	sw	a6,48(sp)
  8c:	03112a23          	sw	a7,52(sp)
  90:	03c12c23          	sw	t3,56(sp)
  94:	03d12e23          	sw	t4,60(sp)
  98:	05e12023          	sw	t5,64(sp)
  9c:	05f12223          	sw	t6,68(sp)
  a0:	340022f3          	csrr	t0,mscratch
  a4:	34102373          	csrr	t1,mepc
  a8:	34202573          	csrr	a0,mcause
  ac:	00512423          	sw	t0,8(sp)
  b0:	04612423          	sw	t1,72(sp)
  b4:	04a12623          	sw	a0,76(sp)
  b8:	1d8000ef          	jal	ra,290 <int_handler>
  bc:	00010513          	mv	a0,sp
  c0:	04852303          	lw	t1,72(a0)
  c4:	05010113          	addi	sp,sp,80
  c8:	34011073          	csrw	mscratch,sp
  cc:	34131073          	csrw	mepc,t1
  d0:	00452083          	lw	ra,4(a0)
  d4:	00852103          	lw	sp,8(a0)
  d8:	00c52283          	lw	t0,12(a0)
  dc:	01052303          	lw	t1,16(a0)
  e0:	01452383          	lw	t2,20(a0)
  e4:	01c52583          	lw	a1,28(a0)
  e8:	02052603          	lw	a2,32(a0)
  ec:	02452683          	lw	a3,36(a0)
  f0:	02852703          	lw	a4,40(a0)
  f4:	02c52783          	lw	a5,44(a0)
  f8:	03052803          	lw	a6,48(a0)
  fc:	03452883          	lw	a7,52(a0)
 100:	03852e03          	lw	t3,56(a0)
 104:	03c52e83          	lw	t4,60(a0)
 108:	04052f03          	lw	t5,64(a0)
 10c:	04452f83          	lw	t6,68(a0)
 110:	02852503          	lw	a0,40(a0)
 114:	30200073          	mret

00000118 <swap>:
 118:	fd010113          	addi	sp,sp,-48
 11c:	02812623          	sw	s0,44(sp)
 120:	03010413          	addi	s0,sp,48
 124:	fca42e23          	sw	a0,-36(s0)
 128:	fcb42c23          	sw	a1,-40(s0)
 12c:	fdc42783          	lw	a5,-36(s0)
 130:	0007a783          	lw	a5,0(a5)
 134:	fef42623          	sw	a5,-20(s0)
 138:	fd842783          	lw	a5,-40(s0)
 13c:	0007a703          	lw	a4,0(a5)
 140:	fdc42783          	lw	a5,-36(s0)
 144:	00e7a023          	sw	a4,0(a5)
 148:	fd842783          	lw	a5,-40(s0)
 14c:	fec42703          	lw	a4,-20(s0)
 150:	00e7a023          	sw	a4,0(a5)
 154:	00000013          	nop
 158:	02c12403          	lw	s0,44(sp)
 15c:	03010113          	addi	sp,sp,48
 160:	00008067          	ret

00000164 <bubble_sort>:
 164:	fd010113          	addi	sp,sp,-48
 168:	02112623          	sw	ra,44(sp)
 16c:	02812423          	sw	s0,40(sp)
 170:	03010413          	addi	s0,sp,48
 174:	fca42e23          	sw	a0,-36(s0)
 178:	fcb42c23          	sw	a1,-40(s0)
 17c:	fe042623          	sw	zero,-20(s0)
 180:	09c0006f          	j	21c <bubble_sort+0xb8>
 184:	fe042423          	sw	zero,-24(s0)
 188:	0700006f          	j	1f8 <bubble_sort+0x94>
 18c:	fe842783          	lw	a5,-24(s0)
 190:	00279793          	slli	a5,a5,0x2
 194:	fdc42703          	lw	a4,-36(s0)
 198:	00f707b3          	add	a5,a4,a5
 19c:	0007a703          	lw	a4,0(a5)
 1a0:	fe842783          	lw	a5,-24(s0)
 1a4:	00178793          	addi	a5,a5,1
 1a8:	00279793          	slli	a5,a5,0x2
 1ac:	fdc42683          	lw	a3,-36(s0)
 1b0:	00f687b3          	add	a5,a3,a5
 1b4:	0007a783          	lw	a5,0(a5)
 1b8:	02e7da63          	bge	a5,a4,1ec <bubble_sort+0x88>
 1bc:	fe842783          	lw	a5,-24(s0)
 1c0:	00279793          	slli	a5,a5,0x2
 1c4:	fdc42703          	lw	a4,-36(s0)
 1c8:	00f706b3          	add	a3,a4,a5
 1cc:	fe842783          	lw	a5,-24(s0)
 1d0:	00178793          	addi	a5,a5,1
 1d4:	00279793          	slli	a5,a5,0x2
 1d8:	fdc42703          	lw	a4,-36(s0)
 1dc:	00f707b3          	add	a5,a4,a5
 1e0:	00078593          	mv	a1,a5
 1e4:	00068513          	mv	a0,a3
 1e8:	f31ff0ef          	jal	ra,118 <swap>
 1ec:	fe842783          	lw	a5,-24(s0)
 1f0:	00178793          	addi	a5,a5,1
 1f4:	fef42423          	sw	a5,-24(s0)
 1f8:	fec42783          	lw	a5,-20(s0)
 1fc:	fd842703          	lw	a4,-40(s0)
 200:	40f707b3          	sub	a5,a4,a5
 204:	fff78713          	addi	a4,a5,-1
 208:	fe842783          	lw	a5,-24(s0)
 20c:	f8e7e0e3          	bltu	a5,a4,18c <bubble_sort+0x28>
 210:	fec42783          	lw	a5,-20(s0)
 214:	00178793          	addi	a5,a5,1
 218:	fef42623          	sw	a5,-20(s0)
 21c:	fd842783          	lw	a5,-40(s0)
 220:	fff78713          	addi	a4,a5,-1
 224:	fec42783          	lw	a5,-20(s0)
 228:	f4e7eee3          	bltu	a5,a4,184 <bubble_sort+0x20>
 22c:	00000013          	nop
 230:	00000013          	nop
 234:	02c12083          	lw	ra,44(sp)
 238:	02812403          	lw	s0,40(sp)
 23c:	03010113          	addi	sp,sp,48
 240:	00008067          	ret

00000244 <main>:
 244:	ff010113          	addi	sp,sp,-16
 248:	00112623          	sw	ra,12(sp)
 24c:	00812423          	sw	s0,8(sp)
 250:	01010413          	addi	s0,sp,16
 254:	00a00593          	li	a1,10
 258:	2b400513          	li	a0,692
 25c:	f09ff0ef          	jal	ra,164 <bubble_sort>
 260:	2b400793          	li	a5,692
 264:	02400713          	li	a4,36
 268:	00078e93          	mv	t4,a5
 26c:	000eaf03          	lw	t5,0(t4)
 270:	00ee8eb3          	add	t4,t4,a4
 274:	000eaf83          	lw	t6,0(t4)
 278:	00000793          	li	a5,0
 27c:	00078513          	mv	a0,a5
 280:	00c12083          	lw	ra,12(sp)
 284:	00812403          	lw	s0,8(sp)
 288:	01010113          	addi	sp,sp,16
 28c:	00008067          	ret

00000290 <int_handler>:
 290:	fe010113          	addi	sp,sp,-32
 294:	00812e23          	sw	s0,28(sp)
 298:	02010413          	addi	s0,sp,32
 29c:	fea42623          	sw	a0,-20(s0)
 2a0:	00000793          	li	a5,0
 2a4:	00078513          	mv	a0,a5
 2a8:	01c12403          	lw	s0,28(sp)
 2ac:	02010113          	addi	sp,sp,32
 2b0:	00008067          	ret

Disassembly of section .data:

000002b4 <array_to_sort>:
 2b4:	00000003          	lb	zero,0(zero) # 0 <_start>
 2b8:	0005                	c.nop	1
 2ba:	0000                	unimp
 2bc:	0010                	0x10
 2be:	0000                	unimp
 2c0:	0001                	nop
 2c2:	0000                	unimp
 2c4:	0004                	0x4
 2c6:	0000                	unimp
 2c8:	0008                	0x8
 2ca:	0000                	unimp
 2cc:	0006                	c.slli	zero,0x1
 2ce:	0000                	unimp
 2d0:	0009                	c.nop	2
 2d2:	0000                	unimp
 2d4:	fffd                	bnez	a5,2d2 <array_to_sort+0x1e>
 2d6:	ffff                	0xffff
 2d8:	0000                	unimp
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	fmsub.d	ft6,ft6,ft4,ft7,rmm
   4:	2820                	fld	fs0,80(s0)
   6:	29554e47          	fmsub.s	ft8,fa0,fs5,ft5,rmm
   a:	3120                	fld	fs0,96(a0)
   c:	2e30                	fld	fa2,88(a2)
   e:	2e31                	jal	32a <_bss_end+0x4e>
  10:	0030                	addi	a2,sp,8

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	1b41                	addi	s6,s6,-16
   2:	0000                	unimp
   4:	7200                	flw	fs0,32(a2)
   6:	7369                	lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <_bss_init_loop>
   c:	0011                	c.nop	4
   e:	0000                	unimp
  10:	1004                	addi	s1,sp,32
  12:	7205                	lui	tp,0xfffe1
  14:	3376                	fld	ft6,376(sp)
  16:	6932                	flw	fs2,12(sp)
  18:	7032                	flw	ft0,44(sp)
  1a:	0030                	addi	a2,sp,8
