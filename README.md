# Git utilities

This repo contains some useful Git utility scripts. To install them, clone the repo or download a ZIP file and place the scripts somewhere on your path (e.g., in `~/bin` or `/usr/local/bin`). The only prerequisites are Git and bash.

The highlights are `git open` and `git undo`, which you'll never understand how you did without.

* `git amend`: alias for `git commit --amend`
* `git anal`: makes a commit with the message "Make anal changes"
* `git cleanup`: deletes every branch already merged into current branch
* `git merge-branch`: merges current branch into given branch (defaults to `master`)
* `git open`: opens the remote page for the repo
* `git switch`: switches to the first branch matching the argument
* `git undo`: undoes the last commit
