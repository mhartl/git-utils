#!/bin/sh

git init test-repo >/dev/null
cd test-repo
git checkout -b test-br 2>/dev/null
touch foo
git add foo
git commit -m "foo" >/dev/null
cat > open <<EOF
#!/bin/sh

echo \$*
EOF
chmod +x open
cat > git-push-branch <<EOF
#!/bin/sh
EOF
chmod +x git-push-branch
export PATH=`pwd`:$PATH
git remote add origin foo

test_open () {
  REMOTE=$1
  EXPECTED=$2
  git remote set-url origin $REMOTE
  RESULT=`../git-open`
  if [ "$RESULT" = "$EXPECTED" ]
  then
    echo "passed: open $REMOTE"
  else
    echo "FAILED: open: Expected $EXPECTED (for origin $REMOTE) but got $RESULT"
  fi
}

test_open https://mwatson@bitbucket.org/atlassian/amps.git https://bitbucket.org/atlassian/amps
test_open git@bitbucket.org:atlassian/amps.git https://bitbucket.org/atlassian/amps
test_open git@github.com:mhartl/git-utils.git https://github.com/mhartl/git-utils
test_open git://github.com/mhartl/git-utils.git https://github.com/mhartl/git-utils
test_open https://github.com/mhartl/git-utils.git https://github.com/mhartl/git-utils
test_open ssh://git@stash.atlassian.com:7999/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/browse?at=test-br
test_open https://mwatson@stash.atlassian.com:7990/scm/stash/stash.git https://stash.atlassian.com:7990/projects/stash/repos/stash/browse?at=test-br
test_open ssh://git@stash.atlassian.com/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/browse?at=test-br
test_open https://mwatson@stash.atlassian.com/scm/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/browse?at=test-br
test_open https://mwatson@stash.atlassian.com/stash/scm/stash/stash.git https://stash.atlassian.com/stash/projects/stash/repos/stash/browse?at=test-br
test_open https://mwatson@stash.atlassian.com:7990/stash/scm/stash/stash.git https://stash.atlassian.com:7990/stash/projects/stash/repos/stash/browse?at=test-br

test_pr () {
  REMOTE=$1
  EXPECTED=$2
  git remote set-url origin $REMOTE
  RESULT=`../git-pull-request`
  if [ "$RESULT" = "$EXPECTED" ]
  then
    echo "passed: pull-request $REMOTE"
  else
    echo "FAILED: pull-request: Expected $EXPECTED (for origin $REMOTE) but got $RESULT"
  fi
}

test_pr https://mwatson@bitbucket.org/atlassian/amps.git https://bitbucket.org/atlassian/amps/pull-request/new
test_pr git@bitbucket.org:atlassian/amps.git https://bitbucket.org/atlassian/amps/pull-request/new
test_pr git@github.com:mhartl/git-utils.git https://github.com/mhartl/git-utils/pull/new/test-br
test_pr git://github.com/mhartl/git-utils.git https://github.com/mhartl/git-utils/pull/new/test-br
test_pr https://github.com/mhartl/git-utils.git https://github.com/mhartl/git-utils/pull/new/test-br
test_pr ssh://git@stash.atlassian.com:7999/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/pull-requests?create\&sourceBranch=test-br
test_pr https://mwatson@stash.atlassian.com:7990/scm/stash/stash.git https://stash.atlassian.com:7990/projects/stash/repos/stash/pull-requests?create\&sourceBranch=test-br
test_pr ssh://git@stash.atlassian.com/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/pull-requests?create\&sourceBranch=test-br
test_pr https://mwatson@stash.atlassian.com/scm/stash/stash.git https://stash.atlassian.com/projects/stash/repos/stash/pull-requests?create\&sourceBranch=test-br
test_pr https://mwatson@stash.atlassian.com/stash/scm/stash/stash.git https://stash.atlassian.com/stash/projects/stash/repos/stash/pull-requests?create\&sourceBranch=test-br
test_pr https://mwatson@stash.atlassian.com:7990/stash/scm/stash/stash.git https://stash.atlassian.com:7990/stash/projects/stash/repos/stash/pull-requests?create\&sourceBranch=test-br

cd ..
rm -rf test-repo
