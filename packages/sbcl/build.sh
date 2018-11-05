TERMUX_PKG_HOMEPAGE=http://www.sbcl.org/
TERMUX_PKG_DESCRIPTION="Steel Bank Common Lisp"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_SHA256=8dcba54853d99e2f5f9dbbd207604471afab528d1eb5c10d24ddea65bae64717
TERMUX_PKG_SRCURL=http://prdownloads.sourceforge.net/sbcl/sbcl-${TERMUX_PKG_VERSION}-source.tar.bz2

termux_step_pre_configure () {
	local SBCL_HOST_TARFILE=$TERMUX_PKG_CACHEDIR/sbcl-host-${TERMUX_PKG_VERSION}.tar.bz2
	if [ $TERMUX_ARCH = "aarch64" ]; then
		_ARCH="arm64"
	elif [ $TERMUX_ARCH = "i686" ]; then
		_ARCH="x86"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		_ARCH="x86-64"
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi
	if [ ! -f $SBCL_HOST_TARFILE ]; then
		curl -o $SBCL_HOST_TARFILE -L http://downloads.sourceforge.net/project/sbcl/sbcl/${TERMUX_PKG_VERSION}/sbcl-${TERMUX_PKG_VERSION}-${_ARCH}-linux-binary.tar.bz2
		cd $TERMUX_PKG_TMPDIR
		tar xf $SBCL_HOST_TARFILE
		cd sbcl-${TERMUX_PKG_VERSION}-${_ARCH}-linux
		INSTALL_ROOT=$TERMUX_PKG_CACHEDIR/sbcl-host sh install.sh
	fi
	export PATH=$PATH:$TERMUX_PKG_CACHEDIR/sbcl-host/bin
	export SBCL_HOME=$TERMUX_PKG_CACHEDIR/sbcl-host/lib/sbcl
}

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR
	sh make.sh --prefix=$TERMUX_PREFIX \
	   --arch=${_ARCH}\
	   --without-sb-thread
}
