pkg_name="venafi-httpd-demo"
pkg_origin="indellient"
pkg_version="0.1.0"
pkg_maintainer="support@indellient.com"
pkg_svc_user="root"
pkg_deps=(core/httpd)
pkg_binds=(
  [helper]="ssl-fqdn ssl-cert ssl-key ssl-chain"
)

do_after() {
  cp -r ../public/* ${pkg_prefix}/
}

do_build() {
  return 0
}

do_install() {
  return 0
}
