require 'git-utils/command'

class Sync < Command

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git sync [branch]"
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns a command appropriate for executing at the command line.
  def cmd
    branch = self.known_options.first || 'master'
    c = ["git checkout #{branch}"]
    c << "git pull"
    c << "git checkout #{current_branch}"
    c.join("\n")
  end
end