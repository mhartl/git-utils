require 'spec_helper'

describe PullRequest do

  let(:command) { PullRequest.new }
  before do
    command.stub(:current_branch).and_return('test-br')
  end
  subject { command }

  its(:cmd) { should match /open #{command.new_pr_url}/ }

  it "should have the right pull request URLs" do
    urls = %w[
https://mwatson@bitbucket.org/atlassian/amps.git https://bitbucket.org/atlassian/amps/pull-request/new
git@bitbucket.org:atlassian/amps.git https://bitbucket.org/atlassian/amps/pull-request/new
git@github.com:mhartl/git-utils.git https://github.com/mhartl/git-utils/pull/new/test-br
https://github.com/mhartl/git-utils.git https://github.com/mhartl/git-utils/pull/new/test-br
ssh://git@stash.atlassian.com:7999/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/pull-requests?create&sourceBranch=test-br
https://mwatson@stash.atlassian.com:7990/scm/stash/stash.git https://stash.atlassian.com:7990/projects/stash/repos/stash/pull-requests?create&sourceBranch=test-br
ssh://git@stash.atlassian.com/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/pull-requests?create&sourceBranch=test-br
https://mwatson@stash.atlassian.com/scm/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/pull-requests?create&sourceBranch=test-br
https://mwatson@stash.atlassian.com/stash/scm/stash/stash.git https://stash.atlassian.com/stash/projects/stash/repos/stash/pull-requests?create&sourceBranch=test-br
https://mwatson@stash.atlassian.com:7990/stash/scm/stash/stash.git https://stash.atlassian.com:7990/stash/projects/stash/repos/stash/pull-requests?create&sourceBranch=test-br
    ]

    urls.each_slice(2) do |origin_url, new_pr_url|
      command.stub(:origin_url).and_return(origin_url)
      expect(command.new_pr_url).to include new_pr_url
    end
  end


  describe "command-line command" do
    subject { `bin/git-pull-request --debug` }
    it { should match /git push-branch/ }
    it { should match /open/ }
  end
end
