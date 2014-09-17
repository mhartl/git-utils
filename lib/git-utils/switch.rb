require 'git-utils/command'

class Switch < Command

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git switch <pattern>"
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns the branch to switch to.
  # When multiple branches match, switch to the first one.
  def other_branch
    @other_branch ||= `git branch | grep #{pattern}`.split.first
  end

  # Returns a command appropriate for executing at the command line.
  def cmd
    "git checkout #{other_branch}"
  end

  private

    # Returns the pattern of the branch to switch to.
    def pattern
      self.known_options.first
    end
end