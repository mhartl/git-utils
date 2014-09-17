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

  describe "description" do
    let(:alternate_branch) { 'alternate' }
    before { command.stub(:known_options).and_return([alternate_branch]) }
    its(:cmd) { should match /git checkout #{alternate_branch}/ }
  end

  describe "command-line command" do
    subject { `bin/git-sync --debug` }
    it { should match /git checkout master/ }
  end
end
