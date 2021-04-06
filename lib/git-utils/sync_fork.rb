require 'git-utils/command'

class SyncFork < Command

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git sync-fork [default]"
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns a command appropriate for executing at the command line.
  def cmd
    c = ["git checkout #{default_branch}"]
    c << "git fetch upstream"
    c << "git merge upstream/#{default_branch}"
    c.join("\n")
  end
end
