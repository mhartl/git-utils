require 'spec_helper'

describe Open do

  let(:command) { Open.new }
  before { command.stub(:current_branch).and_return('tau-manifesto') }
  subject { command }

  its(:cmd) { should match /git / }

  it "should foo" do
    expected = %w[https://mwatson@bitbucket.org/atlassian/amps.git]
    actual   = %w[https://bitbucket.org/atlassian/amps]
    expected.zip(actual).each do |e, a|
      expect(cmd(e)).to include a
    end
  end

  describe "command-line command" do
    subject { `bin/git-open --debug` }
    # it { should_not match /\.git/ }
    # it { should match /git pull-request/ }
  end
end

def cmd(url)
  Open.new([url]).cmd
end