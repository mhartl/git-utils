require 'spec_helper'

describe PushBranch do

  let(:command) { PushBranch.new(['remote_branch']) }
  before do
    command.stub(:current_branch).and_return('test-br')
  end
  subject { command }

  its(:cmd) { should match /git push origin #{command.current_branch}/ }

  describe "command-line command" do
    subject { `bin/git-push-branch --debug` }
    it { should match /git push origin/ }
  end
end
