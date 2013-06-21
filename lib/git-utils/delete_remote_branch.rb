require 'git-utils/command'

class DeleteRemoteBranch < Command

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git delete-remote-branch <branch>"
      opts.on("-o", "--override", "override unsafe delete") do |opt|
        self.options.override = opt
      end
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  def delete_safely?
    command = "git log ..origin/#{target_branch} 2> /dev/null"
    system(command) && `#{command}`.strip.empty?
  end

  # Returns a command appropriate for executing at the command line
  def cmd
    if delete_safely? || options.override
      c = ["git push origin :#{target_branch}"]
      c << argument_string(unknown_options) unless unknown_options.empty?
      c.join("\n")
    else
      $stderr.puts "Target branch contains unmerged commits."
      $stderr.puts "Please cherry-pick the commits or merge the branch again."
      $stderr.puts "Use -o or --override to override."
    end
  end

  private

    # Returns the name of the branch to be deleted.
    def target_branch
      self.known_options.first
    end
end