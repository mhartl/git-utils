# Git utilities

This repo contains some Git utility scripts. The highlights are `git open`, `git pull-request`, `git push-branch`, and `git undo`, which you’ll never understand how you did without.

The `git-utils` used to be pure Bash scripts, but they are now available as a Ruby gem, both because Ruby is more powerful than bash and because now `git-utils` can be included more easily as a dependency for the [pivotal-github](https://github.com/mhartl/pivotal-github/) gem. As a result, installation is easy if you have RubyGems installed:

    gem install git-utils

To learn more about how to use Git itself, see the tutorial book and online course [*Learn Enough Git to Be Dangerous*](https://www.learnenough.com/git).

## Commands

* `git amend`: alias for `git commit --amend`
* `git bump`: makes a commit with the message `"Bump version number"`
* `git cleanup`: deletes every branch already merged into current branch (apart from `master`, `staging`, `development`, and any branches listed in `~/.git-cleanup-preserved`). Pass the `-r` option to delete remote merged branches.
* `git merge-into-branch [branch]`: merges current branch into given branch (defaults to `master`)
* `git minor`: makes a commit with the message `"Make minor changes"`
* `git open`: opens the remote page for the repo (macOS & Linux)
* `git polish`: makes a commit with the message `"Polish"`
* `git pull-request`: pushes the branch and opens the remote page for issuing a new a pull request (macOS-only)
* `git push-branch`: pushes the current branch up to origin
* `git delete-remote-branch <branch>`: deletes the remote branch if it is safe to do so
* `git switch <pattern>`: switches to the first branch matching the given pattern
* `git sync [branch]`: syncs the given branch with the remote branch (defaults to master)
* `git sync-fork`: syncs the `master` branch of a fork with the original upstream `master` (assumes upstream configuration as in “[Configuring a remote for a fork](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/configuring-a-remote-for-a-fork)”)
* `git typo`: makes a commit with the message `"Fix typo"`
* `git undo`: undoes the last commit
* `git graph`: displays full repository history in graphical format; alias for `git log --graph --oneline --decorate --all --full-history --author-date-order --no-notes`

## Aliases

Here are some suggested aliases:

    git config --global alias.mib merge-into-branch
    git config --global alias.pr  pull-request
    git config --global alias.pb  push-branch

## Further details

Some of these commands deserve further explanation.

### git merge-into-branch

`git merge-into-branch [target]` merges the current branch into the target branch (defaults to `master`). On a branch called `add-markdown-support`, `git merge-into-branch` is equivalent to the following:

    $ git checkout master
    $ git merge --no-ff --log add-markdown-support

Note that this effectively changes the default merge behavior from fast-forward to no-fast-forward, which makes it possible to use `git log` to see which of the commit objects together have implemented a feature on a particular branch. As noted in [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/):

> The `--no-ff` flag causes the merge to always create a new commit object, even if the merge could be performed with a fast-forward. This avoids losing information about the historical existence of a feature branch and groups together all commits that together added the feature… Yes, it will create a few more (empty) commit objects, but the gain is much bigger than that cost.

In addition, the `--log` option puts the commit messages from the individual commits in the merge message, which is especially useful for viewing the full diff represented by the commit.

These options can be overriden (and thus restored to their defaults) by passing the options `-ff` or `--no-log`. `git merge-into-branch` accepts any options valid for `git merge`.

### git push-branch

`git push-branch` creates a remote branch at `origin` with the name of the current branch:

    $ git push-branch
    * [new branch]      add-markdown-support -> add-markdown-support

`git push-branch` accepts any options valid for `git push`.


### git sync

`git sync [branch]` syncs the given local branch  with the remote branch (defaults to master). On a branch called `add-markdown-support`, `git sync` is equivalent to the following:

    $ git checkout master
    $ git pull
    $ git checkout add-markdown-support

The main purpose of `git sync` is to prepare the current branch for merging with `master`:

    $ git sync
    $ git merge master

(This is essentially equivalent to

    $ git fetch
    $ git merge origin/master

but I don’t like having `master` and `origin/master` be different since that means you have to remember to run `git pull` on `master` some time down the line.)

## Installation

    gem install git-utils
