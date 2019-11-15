/*
 * fbutils.h
 *
 * Headers for utility routines for framebuffer interaction
 *
 * Copyright 2002 Russell King and Doug Lowder
 *
 * This file is placed under the GPL.  Please see the
 * file COPYING for details.
 *
 */

#ifndef _FBUTILS_H
#define _FBUTILS_H

#ifdef __FreeBSD__
#include <sys/stdint.h>
typedef uint32_t __u32;
#else
#include <asm/types.h>
#endif

#ifdef  __cplusplus
extern "C" {
#endif

/* This constant, being ORed with the color index tells the library
 * to draw in exclusive-or mode (that is, drawing the same second time
 * in the same place will remove the element leaving the background intact).
 */
#define XORMODE	0x80000000

//extern __u32 xres, yres;

int get_resolution(__u32 *xres, __u32 *yres);

#ifdef  __cplusplus
}
#endif  /* end of __cplusplus */

#endif /* _FBUTILS_H */
