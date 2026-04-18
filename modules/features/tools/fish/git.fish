status is-interactive || exit 0

abbr -a gb git branch
abbr -a gba git branch --all --verbose
abbr -a gbc git checkout -b
abbr -a gbd git branch --delete
abbr -a gbl git branch --verbose
abbr -a gbL git branch --all --verbose
abbr -a gbm git branch --move
abbr -a gbM git branch --move --force
abbr -a gbs git show-branch
abbr -a gbS git show-branch --all
abbr -a gbv git branch --verbose
abbr -a gbV git branch --verbose --verbose
abbr -a gbx git branch --delete
abbr -a gbX git branch --delete --force

abbr -a gc git commit --verbose
abbr -a gcF git commit --verbose --amend
abbr -a gcFS git commit --verbose --amend --gpg-sign
abbr -a gcO git checkout --patch
abbr -a gcP git cherry-pick --no-commit
abbr -a gcR git reset "HEAD^"
abbr -a gcS git commit --verbose --gpg-sign
abbr -a gcY git cherry --verbose
abbr -a gca git commit --verbose --all
abbr -a gcaS git commit --verbose --all --gpg-sign
abbr -a gcam git commit --all --message
abbr -a gcf git commit --amend --reuse-message HEAD
abbr -a gcfS git commit --amend --reuse-message HEAD --gpg-sign
abbr -a gcl git-commit-lost
abbr -a gcm git commit --message
abbr -a gcmS git commit --message --gpg-sign

abbr -a gco git checkout
abbr -a gcp git cherry-pick --ff
abbr -a gcr git revert
abbr -a gcs git show
abbr -a gcsS git show --pretty=short --show-signature
abbr -a gcy git cherry --verbose --abbrev

abbr -a gf git fetch
abbr -a gfa git fetch --all
abbr -a gfc git clone
abbr -a gfcr git clone --recurse-submodules
abbr -a gfm git pull
abbr -a gfma git pull --autostash
abbr -a gfr git pull --rebase
abbr -a gfra git pull --rebase --autostash

abbr -a giA git add --patch
abbr -a giD git diff --no-ext-diff --cached --word-diff
abbr -a giI git update-index --no-assume-unchanged
abbr -a giR git reset --patch
abbr -a giX git rm -r --force --cached
abbr -a gia git add
abbr -a gid git diff --no-ext-diff --cached
abbr -a gii git update-index --assume-unchanged
abbr -a gir git reset
abbr -a giu git add --update
abbr -a gix git rm -r --cached

set _git_log_medium_format '%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
set _git_log_oneline_format '%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n'
set _git_log_brief_format '%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'
set _git_log_tree_format '%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(dim white)<%an>%Creset'

abbr -a gl git log --topo-order --pretty=format:"'$_git_log_medium_format'"
abbr -a glS git log --show-signature
abbr -a glb git log --topo-order --pretty=format:"'$_git_log_brief_format'"
abbr -a glc git shortlog --summary --numbered
abbr -a gld git log --topo-order --stat --patch --full-diff --pretty=format:"'$_git_log_medium_format'"
abbr -a glg git log --graph --pretty=format:"'$_git_log_tree_format'" --abbrev-commit
abbr -a glo git log --topo-order --pretty=format:"'$_git_log_oneline_format'"
abbr -a gls git log --topo-order --stat --pretty=format:"'$_git_log_medium_format'"

abbr -a gm git merge
abbr -a gmC git merge --no-commit
abbr -a gmF git merge --no-ff
abbr -a gma git merge --abort
abbr -a gmt git mergetool

abbr -a gp git push
abbr -a gpa git push --all
abbr -a gpA "git push --all && git push --tags"
abbr -a gpc "git push --set-upstream origin (git-current-branch 2> /dev/null)"
abbr -a gpf git push --force-with-lease
abbr -a gpF git push --force
abbr -a gpp "git pull origin (git-current-branch 2> /dev/null) && git push origin (git-current-branch 2> /dev/null)"
abbr -a gpt git push --tags

abbr -a gr git rebase
abbr -a gra git rebase --abort
abbr -a grc git rebase --continue
abbr -a gri git rebase --interactive
abbr -a grim "git rebase --interactive (git rev-list --min-parents=2 --max-count=1 HEAD)"

abbr -a gs git status
abbr -a gsX git-stash-clear-interactive
abbr -a gsa git stash apply
abbr -a gsd git stash show --patch --stat
abbr -a gsl git stash list
abbr -a gsp git stash pop
abbr -a gss git stash save --include-untracked
abbr -a gsw git stash save --include-untracked --keep-index
abbr -a gsx git stash drop

# Tag (t)
abbr -a gt 'git tag'
abbr -a gtl 'git tag --list'
abbr -a gts 'git tag --sign'
abbr -a gtv 'git verify-tag'

abbr -a gwc git clean --dry-run
abbr -a gwd git diff --no-ext-diff
abbr -a gwS git status
abbr -a gwX git rm -r --force
abbr -a gwc git clean --dry-run
abbr -a gwd git diff --no-ext-diff
abbr -a gwr git reset --soft
abbr -a gws git status --short

abbr -a gR git remote
abbr -a gRa git remote add

abbr -a gS git submodule
abbr -a gSI git submodule update --init --recursive
abbr -a gSf git submodule foreach
abbr -a gSl git submodule status
abbr -a gSu git submodule update --remote --recursive
