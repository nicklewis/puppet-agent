platform "fedora-f21-x86_64" do |plat|
  plat.servicedir "/usr/lib/systemd/system"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"

  plat.provision_with "yum install -y autoconf automake createrepo rsync gcc make rpmdevtools rpm-libs yum-utils rpm-sign"
  plat.yum_repo "http://pl-build-tools.delivery.puppetlabs.net/yum/fedora/21/x86_64/pl-build-tools-release-21-11.noarch.rpm"
  plat.install_build_dependencies_with "yum install -y"
  plat.vcloud_name "fedora-21-x86_64"
end
