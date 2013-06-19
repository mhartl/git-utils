# Git utilities

This repo contains some Git utility scripts. The only dependency is Git. The highlights are `git open`, `git pull-request`, `git push-branch`, and `git undo`, which you'll never understand how you did without.

The commands are especially useful when combined with [git-utils](https://github.com/mhartl/git-utils) gem (which, despite its name, also works with Bitbucket).

## Commands

* `git amend`: alias for `git commit --amend`
* `git anal` (use with caution): makes a commit with the message "Make anal changes"
* `git cleanup`: deletes every branch already merged into current branch (apart from `master`)
* `git merge-branch [branch]`: merges current branch into given branch (defaults to `master`)
* `git open`: opens the remote page for the repo (OS X only)
* `git polish`: makes a commit with the message "Polish"
* `git pull-request`: issues a pull request (OS X only)
* `git push-branch`: pushes the current branch up to origin
* `git delete-remote-branch <branch>`: deletes the remote branch if it is safe to do so
* `git switch <pattern>`: switches to the first branch matching the given pattern
* `git sync`: syncs the local master with remote
* `git undo`: undoes the last commit

## Aliases

Here are some suggested aliases:

    git config --global alias.mb merge-branch
    git config --global alias.pr pull-request
    git config --global alias.pb push-branch

## Further details

Some of these commands deserve further explanation.

### git merge-branch

`git merge-branch [target]` merges the current branch into the target branch (defaults to `master`). On a branch called `add-markdown-support`, `git merge-branch` is equivalent to the following:

    $ git checkout master
    $ git merge --no-ff --log add-markdown-support

Note that this effectively changes the default merge behavior from fast-forward to no-fast-forward, which makes it possible to use `git log` to see which of the commit objects together have implemented a feature on a particular branch. As noted in [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/),

> The `--no-ff` flag causes the merge to always create a new commit object, even if the merge could be performed with a fast-forward. This avoids losing information about the historical existence of a feature branch and groups together all commits that together added the feature… Yes, it will create a few more (empty) commit objects, but the gain is much bigger than that cost.

In addition, the `--log` option puts the commit messages from the individual commits in the merge message, which is especially useful for viewing the full diff represented by the commit.

### git push-branch

`git push-branch` creates a remote branch at `origin` with the name of the current branch:

    $ git branch-push
    * [new branch]      add-markdown-support -> add-markdown-support

`git push-branch` accepts any options valid for `git push`.


### git sync

`git sync` syncs the local `master` with the remote `master`. On a branch called `add-markdown-support`, `git sync` is equivalent to the following:

    $ git checkout master
    $ git pull
    $ git checkout add-markdown-support

The purpose of `git sync` is to prepare the current branch for rebasing against `master`:

    $ git sync
    $ git rebase master

(This is essentially equivalent to

    $ git fetch
    $ git rebase origin/master

but I don't like having `master` and `origin/master` be different since that means you have to remember to run `git pull` on `master` some time down the line.)

## Installation

To install the scripts, clone the repo or download a ZIP file and place the scripts somewhere on your path (e.g., in `~/bin` or `/usr/local/bin`). Here's one possible method using symlinks, assuming that `~/bin` exists and is on your path:

    cd
    mkdir repos
    cd repos/
    git clone https://github.com/mhartl/git-utils.git
    cd ~/bin
    ln -sf ~/repos/git-utils/git-* .

Using this method, you can easily update your installation by pulling in the latest changes:

    cd ~/repos/git-utils/
    git pull

To test the installation, try using one of the scripts, such as `git open`:

    cd ~/repos/git-utils
    git open

If `git open` opens a browser window with this `README`, then the installation worked.