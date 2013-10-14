# expand functions in the prompt
setopt prompt_subst

autoload -U compinit
compinit

_rake_does_task_list_need_generating() {
  if [[ ! -f .rake_tasks ]]; then return 0;
  else
    accurate=$(stat -f .rake_tasks)
    changed=$(stat -f Rakefile)
    return $(expr $accurate '>=' $changed)
  fi
}

_rake() {
  if [[ -f Rakefile ]]; then
    if _rake_does_task_list_need_generating; then
      rake --silent --tasks | cut -d " " -f 2 | cut -d "[" -f 1 > .rake_tasks
    fi
    compadd $(cat .rake_tasks)
  fi
}
compdef _rake rake

_thor() {
  compadd $(thor list | grep "thor " | cut -d " " -f 2)
}
compdef _thor thor

