pkg_name=vcert
pkg_origin=indellient
pkg_version="4.1.0"
pkg_license=("Apache-2.0")
pkg_source="https://github.com/Venafi/${pkg_name}/releases/download/v${pkg_version}/vcert86_linux"
pkg_filename="vcert"
pkg_shasum="f16ce62802bde9d9ecc23a42911575b193d09fb6fadf84a6a7991a11a8a2b257"
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
