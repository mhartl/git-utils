require 'optparse'

module Options

  # Returns a list of options unknown to a particular options parser
  # For example, if '-a' is a known option but '-b' and '-c' are not,
  # unknown_options(parser, ['-a', '-b', '-c']) returns ['-b', '-c'].
  # It also preserves arguments, so 
  # unknown_options(parser, ['-a', '-b', '-c', 'foo bar']) returns 
  # ['-b', '-c', 'foo bar'].
  def self.unknown_options(parser, args)
    unknown = []                                     
    recursive_parse = Proc.new do |arg_list|                   
      begin
        # Hack to handle an unknown '-ff' argument
        # The issue here is that OptParse interprets '-ff' as a '-f' option
        # applied twice. This is sort-of a feature, as it allows, e.g., '-am'
        # to set both the '-a' and '-m' options, but it interacts badly
        # with '-ff' (as used by 'git merge') when '-f' is one of the options.
        unknown << arg_list.delete('-ff') if arg_list.include?('-ff')
        parser.parse!(arg_list)
      rescue OptionParser::InvalidOption => e
        unknown.concat(e.args)
        while !arg_list.empty? && arg_list.first[0] != "-"
          unknown << arg_list.shift
        end
        recursive_parse.call(arg_list)
      end
    end
    recursive_parse.call(args.dup)
    unknown
  end

  # Returns a list of options with unknown options removed
  def self.known_options(parser, args)
    unknown = unknown_options(parser, args)
    args.reject { |arg| unknown.include?(arg) }
  end
end