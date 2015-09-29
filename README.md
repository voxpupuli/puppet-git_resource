# Puppet git resource

[![Build Status](https://travis-ci.org/puppet-community/puppet-git_resource.png?branch=master)](https://travis-ci.org/puppet-community/puppet-git_resource)

[puppetlabs-vcsrepo](https://github.com/puppetlabs/puppetlabs-vcsrepo) supports git, however I don't use other vcsrepo types, and bare repos. This is a simpler example implementing a git specific module, while adding automatic dependency against git class which vcsrepo type can not assume.

## Warning

* This project have been migrated to [puppet-community](https://github.com/puppet-community/puppet-git_resource), please adjust your repo git source.

## Compatibility

* RedHat
* Debian

## Usage

### git resource

git resource will automatically depend on the git class, and the parent file directory.

```puppet
git { '/opt/repo/vcsrepo':
  ensure => present,
  commit => '4d2942edc26e7cd144a3178a1a7f6470ea401345',
  origin => 'git@github.com:puppetlabs/puppetlabs-vcsrepo.git',
  # automatic dependencies:
  # require => [ File['/opt/repo'], Class['git'] ],
}

git { 'vcsrepo':
  path   => '/opt/repo/vcsrepo2',
  ensure => present,
  branch => 'master',
  latest => true,
  origin => 'git@github.com:puppetlabs/puppetlabs-vcsrepo.git',
}

git { 'vcsrepo1':
  path   => '/tmp/vcsrepo1',
  ensure => present,
  tag    => '1.1.0',
  origin => 'https://github.com/puppetlabs/puppetlabs-vcsrepo.git',
}
```

## Contributing

puppet lint, rspec puppet, and acceptance testing in vagrant (or equivalence) should be completed:

1. bundle install
2. bundle exec rake lint
3. bundle exec rake spec
4. bundle exec rake vagrant
