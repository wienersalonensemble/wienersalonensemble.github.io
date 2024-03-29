# Temporarily store uncommited changes
git stash

# Verify correct branch
git checkout develop

# Build new files
cabal v2-build webpage
cabal v2-exec webpage clean
cabal v2-exec webpage build

# Get previous files
git fetch --all
git checkout -b master --track origin/master

# Overwrite existing files with new files
cp -a _site/. .

# Commit
git add -A
git commit -m "Publish."

# Push
git push origin master:master

# Restoration
git checkout develop
git branch -D master
git stash pop
