# Git utilities

This repo contains some useful Git utility scripts. The only prerequisites are Git and bash. The highlights are `git open` and `git undo`, which you'll never understand how you did without.

* `git amend`: alias for `git commit --amend`
* `git anal`: makes a commit with the message "Make anal changes"
* `git cleanup`: deletes every branch already merged into current branch
* `git merge-branch`: merges current branch into given branch (defaults to `master`)
* `git open`: opens the remote page for the repo
* `git switch`: switches to the first branch matching the argument
* `git undo`: undoes the last commit

## Installation

To install the scripts, clone the repo or download a ZIP file and place the scripts somewhere on your path (e.g., in `~/bin` or `/usr/local/bin`). Here's one possible method using symlinks, assuming that `~/bin` exists and is on your path:
    
    cd
    mkdir repos
    cd repos/
    git clone https://github.com/mhartl/git-utils.git
    cd ~/bin
    ln -s ~/repos/git-utils/git-* .
 
To test the installation, try using one of the scripts:

    cd ~/repos/git-utils
    git open

If `git open` opens a browser window with `README`, the installation worked.