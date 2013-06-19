require 'spec_helper'

describe Open do

  let(:command) { Open.new }
  before { command.stub(:current_branch).and_return('tau-manifesto') }
  subject { command }

  its(:cmd) { should match /git / }


  describe "command-line command" do
    subject { `bin/git-open --debug` }
    # it { should_not match /\.git/ }
    # it { should match /git pull-request/ }
  end
end