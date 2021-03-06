component "ruby-stomp" do |pkg, settings, platform|
  pkg.version "1.3.3"
  pkg.md5sum "50a2c1b66982b426d67a83f56f4bc0e2"
  pkg.url "http://buildsources.delivery.puppetlabs.net/stomp-1.3.3.gem"

  pkg.replaces 'pe-ruby-stomp'

  pkg.build_requires "ruby"

  pkg.environment "GEM_HOME" => settings[:gem_home]

  if platform.architecture == "sparc"
    # Because we are cross-compiling on sparc, we can't use the rubygems we just built.
    # Instead we use the host gem installation and override GEM_HOME. Yay?
    gem = "/opt/csw/bin/gem19"
  else
    gem = File.join(settings[:bindir], 'gem')
  end

  pkg.install do
    [ "#{gem} install --no-rdoc --no-ri --local stomp-1.3.3.gem" ]
  end
end
