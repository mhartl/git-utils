require 'spec_helper'

describe DeleteRemoteBranch do

  let(:command) { DeleteRemoteBranch.new(['remote_branch']) }
  before do
    command.stub(:current_branch).and_return('test-br')
    command.stub(:delete_safely?).and_return(true)
  end
  subject { command }

  its(:cmd) { should match /git push origin :remote_branch/ }

  describe "command-line command" do
    subject { `bin/git-delete-remote-branch foobar -o --debug` }
    it { should match /git push origin/ }
  end
end
