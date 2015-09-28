require 'pathname'

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

  newproperty(:tag) do
    desc "The git respository tag."
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
      fail("git supports checkout of a only one of: tag, commit, or branch.")
    elsif self[:branch] && self[:tag]
      fail("git supports checkout of a only one of: tag, commit, or branch.")
    elsif self[:tag] && self[:commit]
      fail("git supports checkout of a only one of: tag, commit, or branch.")
    end

    unless self[:commit] or self[:tag]
      # default to master branch if user did not specify commit or branch
      self[:branch] ||= 'master'
    end
  end

  autorequire(:file) do
    req = []
    path = Pathname.new(self[:path])
    if !path.root?
      # Start at our parent, to avoid autorequiring ourself
      parents = path.parent.enum_for(:ascend)
      if found = parents.find { |p| catalog.resource(:file, p.to_s) }
        req << found.to_s
      end
    end

    req
  end

end
