/*=============================================================================
Copyright (C) 2016 Kristina Brooks
All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

FILE DESCRIPTION
ARM entry point.

This is where all cores start. For RPi1, only one core starts so we can jump
straight to the main bootloader. For later models,

=============================================================================*/

.text
.globl _start
_start:
	/* vectors */
	b L_all_cores_start
	nop
	nop
	nop
	nop
	nop
	nop
	nop

	/* comm chan */
	nop
	nop
	nop
	nop

L_all_cores_start:

L_core0:
	mov sp, #0x2000000
	b _firmware_rendezvous

L_deadloop:
	b L_deadloop
