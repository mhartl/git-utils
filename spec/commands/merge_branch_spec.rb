require 'spec_helper'

describe MergeBranch do

  let(:command) { MergeBranch.new }
  before { command.stub(:current_branch).and_return('tau-manifesto') }
  subject { command }

  its(:cmd) { should match /git merge/ }

  shared_examples "merge-branch with known options" do
    subject { command }
    it "should not raise an error" do
      expect { command.parse }.not_to raise_error(OptionParser::InvalidOption)
    end
  end

  describe "with no options" do
    its(:cmd) { should match /git checkout master/ }
  end

  describe "with a custom development branch" do
    let(:command) { MergeBranch.new(['development']) }
    its(:cmd) { should match /git checkout development/ }
  end

  describe "with some unknown options" do
    let(:command) { MergeBranch.new(['dev', '-o', '-a', '-z', '--foo']) }
    it_should_behave_like "merge-branch with known options"
    its(:cmd) { should match /-a -z --foo/ }
  end

  describe "command-line command" do
    subject { `bin/git-merge-branch --debug development` }
    it { should match /git checkout development/ }
    it { should match /git merge --no-ff --log/ }
  end
end