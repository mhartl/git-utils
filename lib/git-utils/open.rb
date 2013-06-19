require 'git-utils/command'

class Open < Command

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git open"
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns the URL for the remote origin.
  def origin_url
    @origin_url ||= `git config --get remote.origin.url`.strip
  end

  # Returns the name of the repository service.
  # It's currently GitHub, Bitbucket, or Stash.
  def service
    if origin_url =~ /github/i
      'github'
    elsif origin_url =~ /bitbucket/i
      'bitbucket'
    elsif origin_url =~ /stash/i
      'stash'
    else
      ""
    end
  end

  # Returns the protocol of the origin URL.
  def protocol
    if origin_url =~ /https?:\/\//
      'http'
    else
      'ssh'
    end
  end

  # Returns the URL for the repository page.
  def page_url
    if service == 'stash' && protocol == 'ssh'
      pattern = /(.*)@([^:]*):?([^\/]*)\/([^\/]*)\/(.*)\.git/
      replacement = 'https://\2/projects/\4/repos/\5/browse?at=' +
                    current_branch
    elsif service == 'stash' && protocol == 'http'
      pattern = /(.*)@([^:\/]*)(:?[^\/]*)\/(.*)scm\/([^\/]*)\/(.*)\.git/
      replacement = 'https://\2\3/\4projects/\5/repos/\6/browse?at=' +
                    current_branch
    elsif protocol == 'ssh'
      pattern = /(.*)@(.*):(.*)\.git/
      replacement = 'https://\2/\3/'
    elsif protocol == 'http'
      pattern = /https?\:\/\/(([^@]*)@)?(.*)\.git/
      replacement = 'https://\3/'
    end
    origin_url.sub(pattern, replacement)
  end

  # Returns a command appropriate for executing at the command line
  def cmd
    c = ["git open #{page_url}"]
    c << argument_string(unknown_options) unless unknown_options.empty?
    c.join("\n")
  end

  private

    # Returns the name of the branch to be merged into.
    # If there is anything left in the known options after parsing,
    # that's the merge branch. Otherwise, it's master.
    def target_branch
      self.known_options.first || 'master'
    end
end