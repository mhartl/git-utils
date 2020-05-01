require 'git-utils/command'

class SyncFork < Command

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git sync-fork"
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns a command appropriate for executing at the command line.
  def cmd
    c = ["git checkout master"]
    c << "git fetch upstream"
    c << "git merge upstream/master"
    c.join("\n")
  end
end
