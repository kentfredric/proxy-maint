# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

MY_BUILD="10678"

DESCRIPTION="Freeware advanced editor for dynamic and Web languages"
HOMEPAGE="http://www.activestate.com/products/komodo_edit"
SRC_URI="x86?   ( http://downloads.activestate.com/Komodo/releases/${PV}/Komodo-Edit-${PV}-${MY_BUILD}-linux-x86.tar.gz    )
	 amd64? ( http://downloads.activestate.com/Komodo/releases/${PV}/Komodo-Edit-${PV}-${MY_BUILD}-linux-x86_64.tar.gz )"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="templates"

DEPEND="virtual/jpeg
	virtual/libc"
RDEPEND="${DEPEND}"

RESTRICT="mirror"

KOMODO_EDIT_INSTALLDIR="opt/${P}"
QA_PREBUILT="${KOMODO_EDIT_INSTALLDIR}/*"

use amd64 && MY_ARCH='x86_64' || MY_ARCH=${ARCH}
S="${WORKDIR}/Komodo-Edit-${PV}-${MY_BUILD}-linux-${MY_ARCH}"

DOCS=(install.html license.txt relnotes.html)

src_install() {
	dodir "${KOMODO_EDIT_INSTALLDIR}"

	"${S}/install.sh" \
		--install-dir "${D}${KOMODO_EDIT_INSTALLDIR}" \
		--dest-dir ${KOMODO_EDIT_INSTALLDIR} \
		--suppress-shortcut || die "original installer script failed"

	dosym "/${KOMODO_EDIT_INSTALLDIR}/bin/komodo" "/usr/bin/${P}" &&
	dosym "./${P}" "/usr/bin/komodo-edit"

	# Most default templates are empty, or near-empty, and can clutter
	# the new file dialog, so we permit not to install them.
	use templates || (
		rm -R "${D}/${KOMODO_EDIT_INSTALLDIR}/"lib/mozilla/extensions/*/templates/* &&
		rm -R "${D}/${KOMODO_EDIT_INSTALLDIR}/"lib/support/default-templates/* ||
			die "failed removing default templates"
	)

	dosym "${KOMODO_EDIT_INSTALLDIR}/share/icons/komodo48.png" \
		"/usr/share/pixmaps/${PN}.png"

	make_desktop_entry \
		"${PN}" \
		"Komodo Edit" \
		"/usr/share/pixmaps/${PN}.png" \
		"Development;IDE;TextEditor" ||
			die "make_desktop_entry failed"
}
