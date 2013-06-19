require 'spec_helper'

describe Command do
  let(:command) { Command.new }
  before { command.stub(:story_branch).and_return('62831853-tau-manifesto') }
  subject { command }

  it { should respond_to(:cmd) }
  it { should respond_to(:args) }
  it { should respond_to(:options) }
  it { should respond_to(:parse) }
  it { should respond_to(:story_id) }
  it { should respond_to(:story_ids) }

  its(:story_id)  { should eq  '62831853'  }
  its(:story_ids) { should eq ['62831853'] }

  describe "branches with multiple stories" do
    before do
      command.stub(:story_branch).and_return('62831853-tau-manifesto-31415926')
    end
    its(:story_ids) { should eq ['62831853', '31415926'] }
  end

  describe "when the branch name has other digit strings shorter than 8" do
    before { command.stub(:story_branch).and_return('3141592-62831853') }
    its(:story_id) { should eq '62831853' }
  end

  describe "with a story id with more than 8 digits" do
    before { command.stub(:story_branch).and_return('628318530-tau-manifesto') }
    its(:story_id) { should eq '628318530' }
  end
end