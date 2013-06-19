require 'spec_helper'

describe Open do

  let(:command) { Open.new }
  before do
    command.stub(:current_branch).and_return('tau-manifesto')
    # command.stub(:origin_url).and_return(origin_url)
  end
  subject { command }

  its(:cmd) { should match /git / }

  it "should foo" do
    origin_urls = %w[https://mwatson@bitbucket.org/atlassian/amps.git]
    page_urls   = %w[https://bitbucket.org/atlassian/amps]
    origin_urls.zip(page_urls).each do |origin_url, page_url|
      command.stub(:origin_url).and_return(origin_url)
      expect(command.page_url).to include page_url
    end
  end

  describe "command-line command" do
    subject { `bin/git-open --debug` }
    # it { should_not match /\.git/ }
    # it { should match /git pull-request/ }
  end
end

def cmd(url)
  Open.new([url]).cmd
end