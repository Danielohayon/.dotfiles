alias g='git status -sb'
alias gh='git hist'
alias gp='git pull'
alias gpr='git pull --rebase'
alias gpp='git pull --rebase && git push'
alias gf='git fetch'
alias gfa='gf --all'
alias gb='git branch'
alias ga='git am --committer-date-is-author-date'
alias gas='ga --signoff'
alias gacs='ga --signoff'
alias gc='git commit -s'
alias gca='git commit -s --amend'
alias gcv='git commit -s --no-verify'
alias gdc='git diff --cached'
alias gdt='git diff-tree --no-commit-id --name-status -r'
alias gdw='git diff --no-ext-diff --word-diff'
alias gdv='git diff'
alias gl='git log --decorate --date=short --pretty=format:"%C(green)%cd - %C(red)%h%Creset - %C(auto)%d%C(reset) %s %C(bold blue)<%an>%Creset"'
alias gls='git log "$(git rev-parse --abbrev-ref --symbolic-full-name @{u})" --decorate --date=short --pretty=format:"%C(green)%cd - %C(red)%h%Creset - %C(auto)%d%C(reset) %s %C(bold blue)<%an>%Creset"'
alias gmf='git merge --ff-only'
alias gt='git tag'
alias grc='git rebase --continue'
alias grcd='git rebase --committer-date-is-author-date'
alias grs='git rebase --skip'
alias grl='git rebase -i HEAD^^'
alias grlc='gc -a -m "grl"'
alias gsl='git stash list'
alias gss='git stash save'
alias grso='git remote show origin'
alias gs="git show --color | sed 's/\t/.       /g' | less -R"
alias gsf='git show --pretty="" --name-only'
alias grpo='git remote prune origin'
alias gcp='git cherry-pick'
alias gcps='gcp -s'
alias gcpc='git cherry-pick --continue'
alias gpfo='git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s|* ||" | xargs git push --force origin'
alias grho='git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s|* |origin/|" | xargs git reset --hard'
alias gg='git grep -Wnp --heading --break'
alias grh='git reset --hard'
alias gpfb='git rev-parse --abbrev-ref --symbolic-full-name @{u} | awk -F / '"'"'{print $1}'"'"' | xargs git push --force'
alias grhb='git rev-parse --abbrev-ref --symbolic-full-name @{u} | xargs git reset --hard'
alias grs='git rev-parse --abbrev-ref --symbolic-full-name @{u} | awk -F / '"'"'{print $1}'"'"' | xargs git remote show'
alias grom='git rebase origin/master'
alias gpgd='git push origin HEAD:refs/drafts/master'
alias gpgr='git push origin HEAD:refs/for/$(git branch --no-color 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/")'
alias gcm='git checkout master'
alias gcmn='git checkout master_next'
alias tkdb='rm -rf /tmp/sw_kernels_build_test ; jfrog_1.42.3 rt dl --server-id=artifactory-kfs --fail-no-op --sort-by=created --sort-order=desc --limit=1 --props '\''buildType=Release;release_branch=master;OS=ubuntu20.04'\'' habanalabs-bin-local/sw_kernels_build_test/ /tmp/ ; pushd /tmp/sw_kernels_build_test/ ; tar xf sw_kernels_build_test-*.tar.gz ; cp libtpc_kernels.so $GC_KERNEL_PATH ; popd'
alias gcb='git checkout -'
alias gpfdo="git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /' | xargs git push fdo"

source ~/bin/git-completion.bash

__git_complete gp _git_pull
__git_complete gf _git_fetch
__git_complete gb _git_branch
__git_complete ga _git_am
__git_complete gc _git_commit
__git_complete gl _git_log
__git_complete gcp _git_cherry_pick
__git_complete gpfo _git_push
__git_complete grho _git_reset
__git_complete gg _git_grep

alias hl-lspci='lspci -d 1da3:'
alias jlog='_jlog(){ curl -X GET --user $USER:$JENKINS_TOKEN "$1" > /tmp/jlog.txt; }; _jlog'
