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

  def story_branch
    `git rev-parse --abbrev-ref HEAD`.strip
  end

  # Returns the story id (or ids).
  # We extract the story id(s) from the branch name, so that, e.g.,
  # the branch `add-markdown-support-62831853` gives story_id '62831853'.
  # New as of version 0.7, we support multiple story ids in a single
  # branch name, so that `add-markdown-support-62831853-31415926` can be used
  # to update story 62831853 and story 31415926 simultaneously.
  def story_ids
    story_branch.scan(/[0-9]{8,}/)
  end

  # Returns the single story id for the common case of one id.
  def story_id
    story_ids.first
  end

  # Returns the message for the story id(s) and action (if any).
  def message
    if finish?
      label = "Finishes #{message_ids}"
    elsif deliver?
      label = "Delivers #{message_ids}"
    else
      label = message_ids
    end
    "[#{label}]"
  end

  # Returns the story ids formatted for story commits.
  # For single-id stories, this is just the number preceded by '#', as in
  # '#62831853'. For multiple-id stories, each story id is precede by '#', as in
  # '#62831853 #31415926'
  def message_ids
    story_ids.map { |id| "##{id}" }.join(' ')
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

    # Exits if the git-utils aren't installed.
    def self.check_git_utils
      if `which git-pull-request`.empty?
        msg = "Install git-utils (https://github.com/mhartl/git-utils)"
        $stderr.puts msg
        exit 1
      end
    end

    def finish?
      options.finish
    end

    def deliver?
      options.deliver
    end
end