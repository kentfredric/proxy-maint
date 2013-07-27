# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PortageXS/PortageXS-0.02.10-r3.ebuild,v 1.1 2013/01/03 08:46:32 armin76 Exp $
EAPI=5
MODULE_AUTHOR=YVES
MODULE_VERSION=0.02

inherit perl-module eutils prefix
DESCRIPTION="Tied hash with specific methods overriden by callbacks"

SLOT="0"
# LICENSE = Perl_5
KEYWORDS="~amd64 ~x86"
IUSE="test"
SRC_TEST="do parallel"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
	)
"
