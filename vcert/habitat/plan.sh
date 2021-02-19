pkg_name=vcert
pkg_origin=indellient
pkg_version="4.9.6"
pkg_license=("Apache-2.0")
pkg_source="https://github.com/Venafi/vcert/releases/download/v4.9.6/vcert-v4.9.6+895_linux86"
pkg_filename="vcert"
pkg_shasum="6be4059df6faadd2da21aebc01ce1f8942b5107cc909cc05bf2c430044983152"
pkg_deps=(core/glibc core/gcc-libs)
pkg_bin_dirs=(bin)
pkg_description="Venafi helper tool for managing SSL certs"

do_unpack() {
  return 0
}

do_build() {
  return 0
}

do_install() {
  install -D ${HAB_CACHE_SRC_PATH}/vcert ${pkg_prefix}/bin/vcert
}
