# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

POSTGRES_COMPAT=( {9..16} )

RESTRICT="test" # connects to :5432 by default, not good

inherit postgres-multi

MY_PV=$(ver_rs 1- '_')
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/postgresql-16.1"

DESCRIPTION="PostgreSQL test parser"
HOMEPAGE="https://www.postgresql.org/"
SRC_URI="https://ftp.postgresql.org/pub/source/v16.1/postgresql-16.1.tar.bz2"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

src_configure() {
	cd src/test/modules/test_parser || die "Failed to cd into plugin directory"
}

src_prepare() {
	local BUILD_DIR="${S}"
	postgres-multi_src_prepare
}

src_compile() {
	pg_src_compile() {
		cd "${BUILD_DIR}"
		emake -C src/test/modules/test_parser USE_PGXS=1 PG_CONFIG="${ESYSROOT}/usr/$(get_libdir)/postgresql-${MULTIBUILD_ID}/bin/pg_config"
	}
	postgres-multi_foreach pg_src_compile
}

src_install() {
	pg_src_install() {
		cd "${BUILD_DIR}"
		emake -C src/test/modules/test_parser USE_PGXS=1 PG_CONFIG="${ESYSROOT}/usr/$(get_libdir)/postgresql-${MULTIBUILD_ID}/bin/pg_config" DESTDIR="${D}" install
	}
	postgres-multi_foreach pg_src_install
}

