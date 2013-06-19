require 'spec_helper'
require 'ostruct'

describe Options do

  let(:options) { OpenStruct.new }

  let(:parser) do
    OptionParser.new do |opts|
      opts.banner = "Usage: git record [options]"
      opts.on("-m", "--message MESSAGE",
              "add a commit message (with ticket #)") do |opt| 
        options.message = opt
      end
      opts.on("-a", "--all", "commit all changed files") do |opt|
        options.all = opt
      end
      opts.on("-f", "--finish", "mark story as finished") do |opt|
        options.finish = opt
      end
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end    
  end

  # The presence of '-ff' in this list is important to test the custom
  # handling of the interaction of '-ff' and '-f'.
  let(:args) { ['-a', '-m', '"A message"', '--finish', '-ff', '--foo', 'b ar'] }

  it { should respond_to(:unknown_options) }
  it { should respond_to(:known_options) }

  describe '#unknown_options' do
    subject { Options::unknown_options(parser, args) }

    it { should     include('-ff') }
    it { should     include('--foo') }
    it { should     include('b ar') }
    it { should_not include('-a') }
    it { should_not include('-m') }
    it { should_not include('"A message"') }
    it { should_not include('--finish') }
  end

  describe '#known_options' do
    subject { Options::known_options(parser, args) }

    it { should_not include('-ff') }
    it { should_not include('--foo') }
    it { should_not include('b ar') }
    it { should     include('-a') }
    it { should     include('-m') }
    it { should     include('"A message"') }
    it { should     include('--finish') }  end
end