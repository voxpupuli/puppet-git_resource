require 'pathname'
require 'ruby-debug'

Puppet::Type.newtype(:git) do
  @doc = "Manages git repository."

  ensurable do
    desc "git repo state, :present, :absent, :latest"

    attr_accessor :latest

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end
  end

  newparam(:path, :namevar=>true) do
    desc "The git respository file path, must be absolute."

    validate do |value|
      raise Puppet::Error, "Puppet::Type::Git: file path must be absolute path." unless value == File.expand_path(value)
    end
  end

  newproperty(:origin) do
    desc "The git respository source."
  end

  newproperty(:branch) do
    desc "The git respository branch."
  end

  newproperty(:commit) do
    desc "The git respository commit."
  end

  newproperty(:latest) do
    desc "Update the repo to match remote branch."

    def change_to_s(val, newval)
      "Changing commit from: #{resource[:head]} to: #{resource[:remote]}"
    end
  end

  newparam(:head) do
    desc "The git respository commit."
  end

  newparam(:remote) do
    desc "The git respository commit."
  end

  newparam(:replace) do
    desc "Replace the current directory if it's not a git repo."
    defaultto(:true)
  end

  validate do
    fail("git repo origin is a required attribute.") unless self[:origin]

    if self[:branch] && self[:commit]
      fail("git supports checkout of a branch(tag) or commit, not both")
    end

    unless self[:commit]
      # default to master branch if user did not specify commit or branch
      self[:branch] ||= 'master'
    end
  end

  autorequire(:file) do
    parent = Pathname.new(self[:path]) if self[:path]
  end

  autorequire(:package) do
    'git'
  end
end
