
init_ram.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00001197          	auipc	gp,0x1
   4:	95c18193          	addi	gp,gp,-1700 # 95c <_gbl_ptr>
   8:	76000113          	li	sp,1888
   c:	16400293          	li	t0,356
  10:	16400313          	li	t1,356

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
  48:	0d0000ef          	jal	ra,118 <main>

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
  b8:	070000ef          	jal	ra,128 <int_handler>
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

00000118 <main>:
 118:	ff010113          	addi	sp,sp,-16
 11c:	00812623          	sw	s0,12(sp)
 120:	01010413          	addi	s0,sp,16
 124:	0000006f          	j	124 <main+0xc>

00000128 <int_handler>:
 128:	fe010113          	addi	sp,sp,-32
 12c:	00812e23          	sw	s0,28(sp)
 130:	02010413          	addi	s0,sp,32
 134:	fea42623          	sw	a0,-20(s0)
 138:	16002703          	lw	a4,352(zero) # 160 <sw>
 13c:	15c02783          	lw	a5,348(zero) # 15c <leds>
 140:	00072703          	lw	a4,0(a4)
 144:	00e7a023          	sw	a4,0(a5)
 148:	00000793          	li	a5,0
 14c:	00078513          	mv	a0,a5
 150:	01c12403          	lw	s0,28(sp)
 154:	02010113          	addi	sp,sp,32
 158:	00008067          	ret

Disassembly of section .sdata:

0000015c <leds>:
 15c:	0000                	unimp
 15e:	8000                	0x8000

00000160 <sw>:
 160:	2000                	fld	fs0,0(s0)
 162:	8000                	0x8000

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	fmsub.d	ft6,ft6,ft4,ft7,rmm
   4:	2820                	fld	fs0,80(s0)
   6:	29554e47          	fmsub.s	ft8,fa0,fs5,ft5,rmm
   a:	3120                	fld	fs0,96(a0)
   c:	2e30                	fld	fa2,88(a2)
   e:	2e31                	jal	32a <_bss_end+0x1c6>
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
