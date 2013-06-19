require 'spec_helper'

describe Switch do

  let(:command) { Switch.new(['other-branch']) }
  before do
    command.stub(:current_branch).and_return('test-br')
    command.stub(:other_branch).and_return('other-branch')
  end
  subject { command }

  its(:cmd) { should match /git checkout #{command.other_branch}/ }

  describe "command-line command" do
    subject { `bin/git-push-branch --debug` }
    it { should match /git push origin/ }
  end
end
