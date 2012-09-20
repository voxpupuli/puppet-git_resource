Puppet::Type.newtype(:git) do
  @doc = "Manages git repository."

  ensurable do
    desc "git repository state. Valid values are present, absent."

    defaultto(:present)

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

  newproperty(:source) do
    desc "The git respository source."
  end

  newproperty(:revision) do
    desc "The git respository revision."
  end

  newproperty(:branch) do
    desc "The git respository branch."
  end

  validate do
    if self[:branch] && self[:revision]
      fail("git supports checkout of a branch(tag) or revision, not both")
    end

    unless self[:branch]
      # default to master branch if user did not specify source or branch
      self[:branch] ||= 'master'
    end
  end

  autorequire(:file) do
    self[:source] if self[:source] and Pathname.new(self[:source]).absolute?
  end

  autorequire(:package) do
    'git'
  end
end
