require 'spec_helper'

describe Command do
  let(:command) { Command.new }
  subject { command }

  it { should respond_to(:cmd) }
  it { should respond_to(:args) }
  it { should respond_to(:options) }
  it { should respond_to(:parse) }
end