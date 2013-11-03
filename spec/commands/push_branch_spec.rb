require 'spec_helper'

describe PushBranch do

  let(:command) { PushBranch.new(['remote_branch']) }
  before do
    command.stub(:current_branch).and_return('test-br')
  end
  subject { command }

  its(:cmd) do
    should match /git push --set-upstream origin #{command.current_branch}/
  end

  describe "command-line command" do
    subject { `bin/git-push-branch --debug` }
    it { should match /git push --set-upstream origin/ }
  end
end
