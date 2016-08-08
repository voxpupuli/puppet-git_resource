Puppet::Type.type(:git).provide(:git) do
  @doc = 'Manages git repos.'

  confine feature: :posix

  commands git: 'git'

  # Execute commands in git source code directory
  def run_cwd(dir = resource[:path])
    result = nil
    Dir.chdir(dir) do
      result = yield.chomp
    end
    result
  end

  def commit
    run_cwd { git('rev-parse', 'HEAD') }
  end

  def commit=(_value)
    run_cwd do
      git('fetch', '--all')
      git('checkout', '-f', resource[:commit])
    end
  end

  def tag
    commit = run_cwd { git('rev-parse', 'HEAD') }
    tag = run_cwd { git('name-rev', '--name-only', '--tags', commit) }
    tag.split('^')[0]
  end

  def tag=(_value)
    run_cwd do
      git('fetch', '--all')
      git('checkout', '-f', resource[:tag])
    end
  end

  def branch
    run_cwd { git('rev-parse', '--abbrev-ref', 'HEAD') }
  end

  def branch=(_value)
    run_cwd { git('checkout', resource[:branch]) }
  end

  def origin
    run_cwd { git('config', '--get', 'remote.origin.url') }
  end

  def origin=(_value)
    run_cwd { git('config', 'remote.origin.url', resource[:origin]) }
  end

  def latest
    if resource[:commit] || resource[:tag]
      true
    else
      run_cwd { git('fetch', '--all') }
      head = run_cwd { git('rev-parse', 'HEAD') }
      remote = run_cwd { git('rev-parse', "origin/#{resource[:branch]}") }
      resource[:head] = head
      resource[:remote] = remote
      head == remote
    end
  end

  def latest=(_value)
    remote = run_cwd { git('rev-parse', "origin/#{resource[:branch]}") }
    Puppet.debug(remote)
    run_cwd { git('reset', '--hard', remote) }
  end

  def create
    if @remove_existing_dir && resource[:replace]
      notice("Removing existing directory #{resource[:path]} and replacing with git repo.")
      destroy
    end
    git('clone', resource[:origin], resource[:path])
    unless resource[:branch] == 'master'
      run_cwd { git('checkout', [resource[:branch], resource[:commit], resource[:tag]].find { |t| t }) }
    end
  end

  def destroy
    FileUtils.rmtree(resource[:path], secure: true)
  end

  def exists?
    result = false
    begin
      if File.directory?(resource[:path])
        result = (run_cwd { git('rev-parse', '--git-dir') } == '.git')
      end
    rescue StandardError => e
      @remove_existing_dir = true
      Puppet.debug(e.message)
    end
    result
  end
end
