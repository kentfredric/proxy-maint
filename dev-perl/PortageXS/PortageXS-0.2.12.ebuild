# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PortageXS/PortageXS-0.02.10-r3.ebuild,v 1.1 2013/01/03 08:46:32 armin76 Exp $
EAPI=5
MODULE_AUTHOR="KENTNL"
MODULE_VERSION="0.2.12"

inherit perl-module eutils prefix
DESCRIPTION="Portage abstraction layer for perl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="minimal test"
SRC_TEST="do parallel"

RDEPEND="
	dev-lang/perl
	virtual/perl-Term-ANSIColor
	dev-perl/Shell-EnvImporter
	!minimal? ( dev-perl/IO-Socket-SSL
		virtual/perl-Sys-Syslog )
"
DEPEND="${RDEPEND}
	>=virtual/perl-Module-Build-0.400.500
	test? (
		>=virtual/perl-Test-Simple-0.98
		virtual/perl-File-Temp
	)
"

src_prepare() {
	epatch "${FILESDIR}"/${PV}/prefix.patch
	eprefixify \
		lib/PortageXS/Core.pm \
		lib/PortageXS.pm \
		usr/bin/portagexs_client \
		usr/sbin/portagexsd \
		t/01_Core.t

	if use minimal ; then
		rm -r "${S}"/usr
		rm -r "${S}"/etc/init.d
		rm -r "${S}"/etc/pxs/certs
		rm "${S}"/etc/pxs/portagexsd.conf
		rm -r "${S}"/lib/PortageXS/examples
	fi
	perl-module_src_prepare;
}

pkg_preinst() {
	if use !minimal ; then
		cp -r "${S}"/usr "${D}${EPREFIX}"
	fi
	cp -r "${S}"/etc "${D}${EPREFIX}"
}

pkg_postinst() {
	if [ -d "${EPREFIX}"/etc/portagexs ]; then
		elog "${EPREFIX}/etc/portagexs has been moved to ${EPREFIX}/etc/pxs for convenience.  It is safe"
		elog "to delete old ${EPREFIX}/etc/portagexs directories."
	fi
}
