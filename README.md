# Git utilities

This repo contains some Git utility scripts. The only prerequisites are Git and bash. The highlights are `git open` and `git undo`, which you'll never understand how you did without.

* `git amend`: alias for `git commit --amend`
* `git anal` (use with caution): makes a commit with the message "Make anal changes"
* `git cleanup`: deletes every branch already merged into current branch
* `git merge-branch [branch]`: merges current branch into given branch (defaults to `master`)
* `git open`: opens the remote page for the repo (OS X only)
* `git switch <pattern>`: switches to the first branch matching the given pattern
* `git undo`: undoes the last commit

## Installation

To install the scripts, clone the repo or download a ZIP file and place the scripts somewhere on your path (e.g., in `~/bin` or `/usr/local/bin`). Here's one possible method using symlinks, assuming that `~/bin` exists and is on your path:
    
    cd
    mkdir repos
    cd repos/
    git clone https://github.com/mhartl/git-utils.git
    cd ~/bin
    ln -sf ~/repos/git-utils/git-* .
 
To test the installation, try using one of the scripts, such as `git open`:

    cd ~/repos/git-utils
    git open

If `git open` opens a browser window with this `README`, then the installation worked.