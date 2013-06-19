require 'git-utils/command'

class Sync < Command

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git sync"
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns a command appropriate for executing at the command line
  def cmd
    c = ["git checkout master"]
    c << "git pull"
    c << "git checkout #{current_branch}"
    c << argument_string(unknown_options) unless unknown_options.empty?
    c.join("\n")
  end
end