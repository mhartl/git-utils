require 'git-utils/command'

class PushBranch < Command

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git push-branch"
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns a command appropriate for executing at the command line
  def cmd
    c = ["git push origin #{current_branch}"]
    c << argument_string(unknown_options) unless unknown_options.empty?
    c.join("\n")
  end
end