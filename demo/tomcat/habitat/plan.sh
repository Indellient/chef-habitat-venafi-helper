pkg_name="venafi-tomcat-demo"
pkg_origin="aumkarpraja"
pkg_version="0.1.0"
pkg_maintainer="support@indellient.com"
pkg_svc_user="root"
pkg_deps=(core/tomcat8 core/tomcat-native core/corretto8)
pkg_binds=(
  [helper]="ssl-fqdn ssl-cert ssl-key ssl-chain"
)

do_prepare() {
  export JAVA_HOME=$(hab pkg path core/corretto8)
}

do_after() {
  cp -r ../public/* ${pkg_prefix}/
}

do_build() {
  return 0
}

do_install() {
  return 0
}
