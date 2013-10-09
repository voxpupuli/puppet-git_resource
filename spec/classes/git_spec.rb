require 'spec_helper'

describe 'git' do
  context 'default' do
    let(:facts){{
      :architecture      => 'x86_64',
      :osfamily          => 'redhat',
      :lsbmajdistrelease => 6,
    }}

    it do
      should include_class 'epel'

      should contain_package 'perl-Error'
      should contain_exec('remove_git')
      should contain_exec('install_git').
        with_command('yum install -y http://pkgs.repoforge.org/git/git-1.7.11.1-1.el6.rfx.x86_64.rpm http://pkgs.repoforge.org/git/perl-Git-1.7.11.1-1.el6.rfx.x86_64.rpm')
    end
  end

  context 'alternate repo' do
    let(:facts){{
      :architecture      => 'i386',
      :osfamily          => 'redhat',
      :lsbmajdistrelease => 5,
    }}

    let(:params){{
      :source => 'http://repo.vmop.local'
    }}

    it do
      should include_class 'epel'

      should contain_package 'perl-Error'
      should contain_exec('remove_git')
      should contain_exec('install_git').
        with_command('yum install -y http://repo.vmop.local/git/git-1.7.11.1-1.el5.rfx.i386.rpm http://repo.vmop.local/git/perl-Git-1.7.11.1-1.el5.rfx.i386.rpm')
    end
  end

  context 'missing facts' do
    let(:facts){{
      :architecture      => 'i386',
      :osfamily          => 'redhat',
    }}

    it do
      expect{ should contain_package('perl-Error') }.
        to raise_error(Puppet::Error, /Only RedHat family supported/)
    end
  end
end
