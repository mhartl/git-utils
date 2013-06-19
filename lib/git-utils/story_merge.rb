require 'git-utils/command'
require 'git-utils/finished_command'

class StoryMerge < FinishedCommand

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git story-merge [branch] [options]"
      opts.on("-o", "--override", "override unfinished story warning") do |opt|
        self.options.override = opt
      end
      opts.on("-f", "--finish", "mark story as finished") do |opt|
        self.options.finish = opt
        self.options.override = opt
      end
      opts.on("-d", "--deliver", "mark story as delivered") do |opt|
        self.options.deliver = opt
        self.options.override = opt
      end
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns a command appropriate for executing at the command line
  # For example:
  #   git checkout master
  #   git merge --no-ff <story branch>
  def cmd
    lines = ["git checkout #{target_branch}"]
    c = ["git merge --no-ff --log"]
    c << %(-m "#{message}")
    c << argument_string(unknown_options) unless unknown_options.empty?
    c << story_branch
    lines << c.join(' ')
    lines.join("\n")
  end

  private

    # Returns the name of the branch to be merged into.
    # If there is anything left in the known options after parsing,
    # that's the merge branch. Otherwise, it's master.
    def target_branch
      self.known_options.first || 'master'
    end
end