require 'spec_helper'

describe StoryMerge do

  let(:command) { StoryMerge.new }
  before { command.stub(:story_branch).and_return('62831853-tau-manifesto') }
  subject { command }

  its(:cmd) { should match /git merge/ }

  shared_examples "story-merge with known options" do
    subject { command }
    it "should not raise an error" do
      expect { command.parse }.not_to raise_error(OptionParser::InvalidOption)
    end
  end

  describe "with no options" do
    its(:cmd) { should match /git checkout master/ }
    its(:cmd) do
      msg = Regexp.escape("[##{command.story_id}]")
      branch = command.story_branch
      should match /git merge --no-ff --log -m "#{msg}" #{branch}/
    end
  end

  describe "with the finish option" do
    let(:command) { StoryMerge.new(['-f']) }
    its(:cmd) do
      msg = Regexp.escape("[Finishes ##{command.story_id}]")
      branch = command.story_branch
      should match /git merge --no-ff --log -m "#{msg}" #{branch}/
    end
  end

  describe "with the delivers option" do
    let(:command) { StoryMerge.new(['-d']) }
    its(:cmd) do
      msg = Regexp.escape("[Delivers ##{command.story_id}]")
      branch = command.story_branch
      should match /git merge --no-ff --log -m "#{msg}" #{branch}/
    end
  end

  describe "with a custom development branch" do
    let(:command) { StoryMerge.new(['development']) }
    its(:cmd) { should match /git checkout development/ }
  end

  describe "with some unknown options" do
    let(:command) { StoryMerge.new(['development', '-o', '-a', '-z', '--foo']) }
    it_should_behave_like "story-merge with known options"
    its(:cmd) { should match /-a -z --foo/ }
  end

  describe "command-line command" do
    subject { `bin/git-story-merge --debug development` }
    it { should match /git checkout development/ }
    it { should match /git merge --no-ff --log/ }
  end
end