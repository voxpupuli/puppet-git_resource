git { '/var/tmp/demo':
  ensure => present,
  origin => 'https://github.com/puppetlabs/puppetlabs-vcsrepo.git',
  latest => true,
}

git { '/var/tmp/demo2':
  ensure => present,
  origin => '/var/tmp/demo',
  latest => true,
}

git { '/var/tmp/demo3':
  ensure => present,
  origin => 'https://github.com/puppetlabs/puppetlabs-vcsrepo.git',
  commit => '493dc2172bd01dcb4f47e4233292cd3dcdea08b9',
}
