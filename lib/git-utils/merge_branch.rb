require 'git-utils/command'

class MergeBranch < Command

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git story-merge [branch] [options]"
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns a command appropriate for executing at the command line
  # For example:
  #   git checkout master
  #   git merge --no-ff --log <branch>
  def cmd
    lines = ["git checkout #{target_branch}"]
    c = ["git merge --no-ff --log"]
    c << argument_string(unknown_options) unless unknown_options.empty?
    c << current_branch
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