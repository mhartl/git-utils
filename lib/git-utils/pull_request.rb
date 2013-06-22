require 'git-utils/command'

class PullRequest < Command

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git pull-request"
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns the URL for a new pull request.
  def new_pr_url
    if service == 'stash' && protocol == 'ssh'
      pattern = /(.*)@([^:]*):?([^\/]*)\/([^\/]*)\/(.*)\.git/
      replacement = 'https://\2/projects/\4/repos/\5/pull-requests?create&sourceBranch=' +
                    current_branch
    elsif service == 'stash' && protocol == 'http'
      pattern = /(.*)@([^:\/]*)(:?[^\/]*)\/(.*)scm\/([^\/]*)\/(.*)\.git/
      replacement = 'https://\2\3/\4projects/\5/repos/\6/pull-requests?create&sourceBranch=' +
                    current_branch
    elsif service == 'github' && protocol == 'ssh'
      pattern = /(.*)@(.*):(.*)\.git/
      replacement = 'https://\2/\3/pull/new/' + current_branch
    elsif service == 'github' && protocol == 'http'
      pattern = /https?\:\/\/(([^@]*)@)?(.*)\.git/
      replacement = 'https://\3/pull/new/' + current_branch
    elsif service == 'bitbucket' && protocol == 'ssh'
      pattern = /(.*)@(.*):(.*)\.git/
      replacement = 'https://\2/\3/pull-request/new/'
    elsif service == 'bitbucket' && protocol == 'http'
      pattern = /https?\:\/\/(([^@]*)@)?(.*)\.git/
      replacement = 'https://\3/pull-request/new/'
    end
    origin_url.sub(pattern, replacement)
  end

  # Returns a command appropriate for executing at the command line
  def cmd
    push  = ["git push-branch"]
    push += argument_string(unknown_options) unless unknown_options.empty?
    push = push.join(" ")
    c = [push, "open #{new_pr_url}"]
    c.join("\n")
  end
end