require 'spec_helper'

describe Sync do

  let(:command) { Sync.new }
  before do
    command.stub(:current_branch).and_return('test-br')
  end
  subject { command }

  its(:cmd) { should match /git checkout master/ }
  its(:cmd) { should match /git pull/ }
  its(:cmd) { should match /git checkout #{command.current_branch}/ }

  describe "command-line command" do
    subject { `bin/git-sync --debug` }
    it { should match /git checkout master/ }
  end
end
