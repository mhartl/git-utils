require 'spec_helper'

describe MergeBranch do

  let(:command) { MergeBranch.new }
  before  { command.stub(:current_branch).and_return('tau-manifesto') }
  subject { command }

  its(:cmd) { should match /git merge/ }

  shared_examples "merge-into-branch with known options" do
    subject { command }
    it "should not raise an error" do
      expect { command.parse }.not_to raise_error(OptionParser::InvalidOption)
    end
  end

  describe "with no options" do
    its(:cmd) { should match /git checkout master/ }
  end

  describe "default branch" do
    let(:command) { MergeBranch.new }

    describe "for current real repo" do
      subject { command.default_branch }
      it { should match 'master' }
    end

    describe "for repo with different default" do
      before  { command.stub(:default_branch).and_return('main') }
      subject { command.default_branch }
      it { should match 'main' }
    end
  end

  describe "with a custom development branch" do
    let(:command) { MergeBranch.new(['development']) }
    its(:cmd) { should match /git checkout development/ }
  end

  describe "with some unknown options" do
    let(:command) { MergeBranch.new(['dev', '-o', '-a', '-z', '--foo']) }
    it_should_behave_like "merge-into-branch with known options"
    its(:cmd) { should match /-a -z --foo/ }
  end

  describe "command-line command" do
    subject { `bin/git-merge-into-branch --debug development` }
    it { should match /git checkout development/ }
    it { should match /git merge --no-ff --log/ }
  end
end
