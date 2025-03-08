
#
# The BSD 3-Clause License. http://www.opensource.org/licenses/BSD-3-Clause
#
# This file is part of MinGW-W64(mingw-builds: https://github.com/niXman/mingw-builds) project.
# Copyright (c) 2011-2023 by niXman (i dotty nixman doggy gmail dotty com)
# Copyright (c) 2012-2015 by Alexpux (alexpux doggy gmail dotty com)
# All rights reserved.
#
# Project: MinGW-Builds ( https://github.com/niXman/mingw-builds )
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

PKG_VERSION=1.5.7
PKG_NAME=$BUILD_ARCHITECTURE-zstd-${PKG_VERSION}-$LINK_TYPE_SUFFIX
PKG_DIR_NAME=zstd-${PKG_VERSION}
PKG_TYPE=.tar.gz
PKG_SHA256=eb33e51f49a15e023950cd7825ca74a4a2b43db8354825ac24fc1b7ee09e6fa3
PKG_URLS=(
	"https://github.com/facebook/zstd/releases/download/v${PKG_VERSION}/zstd-${PKG_VERSION}${PKG_TYPE}|sha256:${PKG_SHA256}"
)

PKG_PRIORITY=prereq
PKG_LNDIR=yes

#

PKG_PATCHES=(
	zstd/zstd-1.4.0-fileio-mingw.patch
)

#

# We have nothing to run here, but need something to make PKG_LNDIR work.
PKG_CONFIGURE_PROG=true
PKG_CONFIGURE_FLAGS=( dummy )

#

PKG_MAKE_FLAGS=(
	-j$JOBS
	# Is there a better way to specify the host compiler?
	CC=gcc
	lib-release
)

#

PKG_EXECUTE_AFTER_INSTALL=(
	"mkdir -p $PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX/{bin,include,lib}"
	"cp -fv $CURR_BUILD_DIR/$PKG_NAME/lib/*.h $PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX/include/"
	$( [[ $LINK_TYPE_SUFFIX == shared ]] \
		&& echo "install_zstd_lib_shared" \
		|| echo "install_zstd_lib_static"
	)
)

function install_zstd_lib_shared {
	cp -fv $CURR_BUILD_DIR/$PKG_NAME/lib/dll/libzstd.dll $PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX/bin/
	cp -fv $CURR_BUILD_DIR/$PKG_NAME/lib/dll/libzstd.dll.a $PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX/lib/
}

function install_zstd_lib_static {
	cp -fv $CURR_BUILD_DIR/$PKG_NAME/lib/libzstd.a $PREREQ_DIR/$HOST-$LINK_TYPE_SUFFIX/lib/
}

# **************************************************************************
