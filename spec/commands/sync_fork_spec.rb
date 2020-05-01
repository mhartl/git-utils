require 'spec_helper'

describe SyncFork do

  let(:command) { SyncFork.new }
  subject { command }

  its(:cmd) { should match /git checkout master/ }
  its(:cmd) { should match /git fetch upstream/ }
  its(:cmd) { should match /git merge upstream\/master/ }


  describe "command-line command" do
    subject { `bin/git-sync-fork --debug` }
    it { should match /git fetch upstream/ }
  end
end
