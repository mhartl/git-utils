require 'optparse'
require 'ostruct'
require 'git-utils/options'

class Command
  attr_accessor :args, :cmd, :options, :known_options, :unknown_options

  def initialize(args = [])
    self.args = args
    self.options = OpenStruct.new
    parse
  end

  def parse
    self.known_options   = Options::known_options(parser, args)
    self.unknown_options = Options::unknown_options(parser, args)
    parser.parse!(known_options)
  end

  def parser
    OptionParser.new
  end

  # Returns the current Git branch.
  def current_branch
    @current_branch ||= `git rev-parse --abbrev-ref HEAD`.strip
  end

  # Returns the default branch for the current repository.
  # Command retrieved from
  # https://stackoverflow.com/questions/28666357/git-how-to-get-default-branch
  def default_branch
    branch_name = `git symbolic-ref --short refs/remotes/origin/HEAD \
                   | sed 's@^origin/@@'`.strip
    if branch_name.empty?
      $stderr.puts "Repository configuration error"
      $stderr.puts "Missing reference to refs/remotes/origin/HEAD"
      $stderr.puts "Run"
      $stderr.puts "  $ git remote set-head origin <default branch>`"
      $stderr.puts "where <default branch> is the default branch name"
      $stderr.puts "(typically `main`, `master`, or `trunk`)"
      $stderr.puts "and then rerun the command"
      exit(1)
    end
    @default_branch ||= branch_name
  end

  # Returns the URL for the remote origin.
  def origin_url
    @origin_url ||= `git config --get remote.origin.url`.strip
  end

  # Returns the name of the repository service.
  # It's currently GitHub, Bitbucket, or Stash.
  # We return blank for an unknown service; the command will still
  # often work in that case.
  def service
    if origin_url =~ /github/i
      'github'
    elsif origin_url =~ /bitbucket/i
      'bitbucket'
    elsif origin_url =~ /stash/i
      'stash'
    else
      ''
    end
  end

  # Returns the protocol of the origin URL (defaults to ssh).
  def protocol
    if origin_url =~ /https?:\/\//
      'http'
    else
      'ssh'
    end
  end

  # Runs a command.
  # If the argument array contains '--debug', returns the command that would
  # have been run.
  def self.run!(command_class, args)
    debug = args.delete('--debug')
    command = command_class.new(args)
    if debug
      puts command.cmd
      return 1
    else
      command.run!
      return 0
    end
  end

  def run!
    system cmd
  end

  private

    # Returns an argument string based on given arguments.
    # The main trick is to add in quotes for option
    # arguments when necessary.
    # For example, ['-a', '-m', 'foo bar'] becomes
    # '-a -m "foo bar"'
    def argument_string(args)
      args.inject([]) do |opts, opt|
        opts << (opt =~ /^-/ ? opt : opt.inspect)
      end.join(' ')
    end

    def finish?
      options.finish
    end

    def deliver?
      options.deliver
    end
end
