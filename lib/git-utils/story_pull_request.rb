require 'git-utils/command'
require 'git-utils/finished_command'

class StoryPullRequest < FinishedCommand

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git story-pull-request [options]"
      opts.on("-o", "--override", "override unfinished story warning") do |opt|
        self.options.override = opt
      end
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns a command appropriate for executing at the command line
  # I.e., 'open https://www.pivotaltracker.com/story/show/62831853'
  def cmd
    "git pull-request"
  end

  def uri
    "#{origin_uri}/pull/new/#{story_branch}"
  end

  private

    # Returns the raw remote location for the repository.
    # E.g., http://github.com/mhartl/git-utils or
    # git@github.com:mhartl/git-utils
    def remote_location
      `git config --get remote.origin.url`.strip.chomp('.git')
    end

    # Returns the remote URI for the repository.
    # Both https://... and git@... remote formats are supported.
    def origin_uri
      remote_location.sub(/^git@(.+?):(.+)$/, 'https://\1/\2')
    end
end