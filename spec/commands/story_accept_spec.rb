require 'spec_helper'

describe StoryAccept do

  let(:command) { StoryAccept.new(['-o', '-a']) }
  before do
    command.stub(:story_branch).and_return('62831853-tau-manifesto')
    command.stub(:already_accepted?).and_return(false)
  end
  subject { command }

  it { should respond_to(:ids_to_accept) }

  describe "ids_to_accept" do
    let(:ids) { command.ids_to_accept }
    subject { ids }

    it { should_not be_empty }
    it { should include("51204529") }
    it { should include("51106181") }
    it { should include("50566167") }

    it "should not have duplicate ids" do
      expect(ids).to eq ids.uniq
    end
  end


  its(:api_token) { should_not be_empty }

  describe "accept!" do
    before do
      command.stub(:accept!)
    end

    it "should accept each id" do
      number_accepted = command.ids_to_accept.length
      command.should_receive(:accept!).exactly(number_accepted).times
      command.run!
    end
  end

  describe "when stopping upon reading the first accepted id" do
    let(:command) { StoryAccept.new(['-o']) }
    before do
      command.stub(:story_branch).and_return('62831853-tau-manifesto')
      command.stub(:already_accepted?).and_return(false)
      command.stub(:already_accepted?).with("50566167").and_return(true)
    end
    subject { command }

    its(:ids_to_accept) { should include("51204529") }
    its(:ids_to_accept) { should include("51106181") }
    its(:ids_to_accept) { should_not include("50566167") }
  end
end