require 'spec_helper'

describe StoryPullRequest do

  let(:command) { StoryPullRequest.new }
  before { command.stub(:story_branch).and_return('62831853-tau-manifesto') }
  before do
    command.stub(:remote_location).
            and_return('https://github.com/mhartl/foo')
  end
  subject { command }

  its(:cmd) { should match /git pull-request/ }

  describe 'origin uri parsing' do
    let(:correct_origin) { 'https://github.com/mhartl/foo' }
    subject { command.send :origin_uri }

    context 'https protocol' do
      it { should eq correct_origin }
    end

    context 'git protocol' do
      before do
        command.stub(:remote_location).
                and_return('git@github.com:mhartl/foo')
      end

      it { should eq correct_origin }
    end
  end

  describe "command-line command" do
    subject { `bin/git-story-pull-request --debug` }
    it { should_not match /\.git/ }
    it { should match /git pull-request/ }
  end
end