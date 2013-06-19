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

  def branch
    `git rev-parse --abbrev-ref HEAD`.strip
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
      check_git_utils
      command.run!
      return 0
    end
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