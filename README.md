# puppet git module

Why? Yes, there is a [puppetlabs-vcsrepo](https://github.com/puppetlabs/puppetlabs-vcsrepo), however I don't use other vcsrepo type, and it's simpler just to implement a working type/provider specifically for git. Implementing a git specific module automatic dependency against git package which vcsrepo type can not assume.

## git class

The git class installs the git package:

class { 'git': }

## git resource

git resource will automatically depend on the git package, and the parent file directory.

git { '/opt/repo/vcsrepo':
  ensure   => present,
  revision => 'sdfas',
  source   => 'git@github.com:puppetlabs/puppetlabs-vcsrepo.git',
  # automatic dependencies:
  # require => [File['/opt/repo'], Package['git']],
}

git { 'vcsrepo':
  path   => '/opt/repo/vcsrepo'
  ensure => present,
  branch => 'master',
  source => 'git@github.com:puppetlabs/puppetlabs-vcsrepo.git',
}
