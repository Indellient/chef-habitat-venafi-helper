pkg_name=venafi-helper
pkg_origin=indellient
pkg_version="0.4.1"
pkg_license=("Apache-2.0")

pkg_deps=(
  core/curl
  core/python2
  core/glibc
  core/openssl
  core/cacerts
  core/jq-static
  indellient/vcert
)

pkg_bin_dirs=(bin)
pkg_svc_user="root"
pkg_svc_group="root"
pkg_description="Venafi helper tool for managing SSL certs"

pkg_exports=(
  [ssl-fqdn]=ssl.fqdn
  [ssl-cert]=ssl.cert
  [ssl-key]=ssl.key
  [ssl-chain]=ssl.chain
)

do_build() {
  return 0
}

do_install() {
  return 0
}
