require 'spec_helper'

describe Open do

  let(:command) { Open.new }
  before do
    command.stub(:current_branch).and_return('test-br')
  end
  subject { command }

  its(:cmd) { should match /open #{command.page_url}/ }

  it "should have the right page URLs" do
    urls = %w[
https://mwatson@bitbucket.org/atlassian/amps.git https://bitbucket.org/atlassian/amps
git@bitbucket.org:atlassian/amps.git https://bitbucket.org/atlassian/amps
git@github.com:mhartl/git-utils.git https://github.com/mhartl/git-utils
https://github.com/mhartl/git-utils.git https://github.com/mhartl/git-utils
ssh://git@stash.atlassian.com:7999/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/browse?at=test-br
https://mwatson@stash.atlassian.com:7990/scm/stash/stash.git https://stash.atlassian.com:7990/projects/stash/repos/stash/browse?at=test-br
ssh://git@stash.atlassian.com/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/browse?at=test-br
https://mwatson@stash.atlassian.com/scm/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/browse?at=test-br
https://mwatson@stash.atlassian.com/stash/scm/stash/stash.git https://stash.atlassian.com/stash/projects/stash/repos/stash/browse?at=test-br
https://mwatson@stash.atlassian.com:7990/stash/scm/stash/stash.git https://stash.atlassian.com:7990/stash/projects/stash/repos/stash/browse?at=test-br
https://example.com/repos/foobar.git https://example.com/repos/foobar
    ]
    urls.each_slice(2) do |origin_url, page_url|
      command.stub(:origin_url).and_return(origin_url)
      expect(command.page_url).to include page_url
    end
  end

  describe "command-line command" do
    subject { `bin/git-open --debug` }
    it { should match /open/ }
  end
end
