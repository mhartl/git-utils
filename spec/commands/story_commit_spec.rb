require 'spec_helper'

describe StoryCommit do

  let(:command) { StoryCommit.new(['-m', 'msg', '-a', '-z', '--foo']) }
  before { command.stub(:story_branch).and_return('62831853-tau-manifesto') }
  subject { command }

  it { should respond_to(:message) }

  shared_examples "story-commit with known options" do
    subject { command }

    its(:cmd)      { should match /git commit/ }
    its(:message)  { should_not be_empty }
    its(:message?) { should be_true }
    its(:all?)     { should be_true }

    describe "parse" do
      subject { command.options }

      its(:message) { should eq 'msg' }
      its(:all)     { should be_true }
    end
  end

  describe "with only known options" do
    let(:command) { StoryCommit.new(['-m', 'msg', '-a']) }
    it_should_behave_like "story-commit with known options"
  end

  describe "with a compound argument" do
    let(:command) { StoryCommit.new(['-am', 'msg']) }
    it_should_behave_like "story-commit with known options"
  end

  describe "with some unknown options" do
    let(:command) { StoryCommit.new(['-m', 'msg', '-a', '-z', '--foo']) }

    it_should_behave_like "story-commit with known options"

    it "should not raise an error" do
      expect { command.parse }.not_to raise_error(OptionParser::InvalidOption)
    end
  end

  describe '#story_id' do
    subject { command.story_id }
    it { should eq '62831853' }
  end

  describe "command with message" do
    its(:cmd) do
      should eq %(git commit -a -m "msg" -m "[##{command.story_id}]" -z --foo)
    end

    describe "when used with branches containing multiple stories" do
      before do
        command.stub(:story_branch).and_return('62831853-tau-manifesto-31415926')
      end
      its(:cmd) do
        delivered_ids = '#62831853 #31415926'
        should eq %(git commit -a -m "msg" -m "[#{delivered_ids}]" -z --foo)
      end
    end
  end

  describe "command with no message" do
    let(:command) { StoryCommit.new(['-a', '-z', '--foo']) }
    its(:cmd) do
      should eq %(git commit -a -m "[##{command.story_id}]" -z --foo)
    end
  end

  describe "command with finish flag" do
    let(:command) { StoryCommit.new(['-m', 'msg', '-f']) }
    its(:cmd) do
      should eq %(git commit -m "msg" -m "[Finishes ##{command.story_id}]")
    end

    describe "when used with branches containing multiple stories" do
      before do
        command.stub(:story_branch).and_return('62831853-tau-manifesto-31415926')
      end
      its(:cmd) do
        delivered_ids = '#62831853 #31415926'
        should eq %(git commit -m "msg" -m "[Finishes #{delivered_ids}]")
      end
    end
  end

  describe "command with deliver flag" do
    let(:command) { StoryCommit.new(['-m', 'msg', '-d']) }
    its(:cmd) do
      should eq %(git commit -m "msg" -m "[Delivers ##{command.story_id}]")
    end

    describe "when used with branches containing multiple stories" do
      before do
        command.stub(:story_branch).and_return('62831853-tau-manifesto-31415926')
      end
      its(:cmd) do
        delivered_ids = '#62831853 #31415926'
        should eq %(git commit -m "msg" -m "[Delivers #{delivered_ids}]")
      end
    end
  end

  describe "command with no story id" do
    before { command.stub(:story_branch).and_return('tau-manifesto') }
    its(:cmd) do
      should eq %(git commit -a -m "msg" -z --foo)
    end
  end

  describe "command-line command" do
    let(:command) { `bin/git-story-commit -a -m "msg" -z --debug` }
    subject { command }
    it { should match /git commit -a -m/ }
    it { should match /msg/ }
    it { should match /-z/ }
    it { should_not match /--debug/ }
  end
end