require 'spec_helper'

describe StoryOpen do

  let(:command) { StoryOpen.new }
  let(:uri) { "https://www.pivotaltracker.com/story/show/#{command.story_id}" }
  before { command.stub(:story_branch).and_return('62831853-tau-manifesto') }
  subject { command }

  its(:cmd) { should eq "open #{uri}" }
end