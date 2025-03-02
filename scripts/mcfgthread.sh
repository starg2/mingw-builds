
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
# Copyright (c) 2011-2021 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012-2015 by Alexpux (alexpux doggy gmail dotty com)
# All rights reserved.
#
# Project: MinGW-W64 ( http://sourceforge.net/projects/mingw-w64/ )
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# - Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in
#     the documentation and/or other materials provided with the distribution.
# - Neither the name of the 'MinGW-W64' nor the names of its contributors may
#     be used to endorse or promote products derived from this software
#     without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# **************************************************************************

PKG_VERSION=2.0.ga
PKG_NAME=$PKG_ARCHITECTURE-mcfgthread-${PKG_VERSION}
PKG_DIR_NAME=mcfgthread-${PKG_VERSION}
PKG_TYPE=git
PKG_URLS=(
	"https://github.com/lhmouse/mcfgthread.git|branch:releases/v$(echo $PKG_VERSION | cut -d . -f -2)|repo:$PKG_TYPE|module:$PKG_DIR_NAME"
)

PKG_PRIORITY=prereq

#

PKG_EXECUTE_AFTER_UNCOMPRESS=(
	"git reset --hard b8dcc99680f64b1a4743e47e4c2f892407d69544" # Reset to this commit hash for reproducible builds
)

#

PKG_PATCHES=()

#

ABI_MAJOR=$(echo $PKG_VERSION | cut -d . -f 1)

PKG_EXECUTE_AFTER_CONFIGURE=(
	"sed 's/@abi_major@/$ABI_MAJOR/g; s/@abi_minor@/$(echo $PKG_VERSION | cut -d . -f 2)/g; s/@abi_string@/$PKG_VERSION/g' $SRCS_DIR/$PKG_DIR_NAME/mcfgthread/version.h.in > version.h"
)

#

PKG_MAKE_FLAGS=(
	-f "$PATCHES_DIR/mcfgthread/Makefile"
	-j$JOBS
	all
	CC=gcc
	AR=ar
	RC=windres
	CFLAGS="\"$COMMON_CFLAGS\""
	CXXFLAGS="\"$COMMON_CXXFLAGS\""
	CPPFLAGS="\"$COMMON_CPPFLAGS\""
	LDFLAGS="\"$COMMON_LDFLAGS\""
	ABI_MAJOR=$ABI_MAJOR
	SOURCE_DIR="$SRCS_DIR/$PKG_DIR_NAME/mcfgthread"
)

#

PKG_INSTALL_FLAGS=(
	-f "$PATCHES_DIR/mcfgthread/Makefile"
	-j$JOBS
	$( [[ $STRIP_ON_INSTALL == yes ]] && echo install-strip || echo install )
	DESTDIR="$PREREQ_DIR/$PKG_ARCHITECTURE-mcfgthread"
	ABI_MAJOR=$ABI_MAJOR
	SOURCE_DIR="$SRCS_DIR/$PKG_DIR_NAME/mcfgthread"
)

# **************************************************************************
