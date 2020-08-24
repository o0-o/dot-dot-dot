# use nvim, vim or vi depending on availability
{ command -v nvim >/dev/null  &&
  typeset EDITOR="nvim"       ||
  { command -v vim >/dev/null   &&
    typeset EDITOR="vim"
  }                           ||
  typeset EDITOR="vi"
}             &&

# update vim plugins
( nohup "${EDITOR}"                 \
    -c ':PlugInstall'               \
    -c ':PlugClean!'                \
    -c ':q!'                        \
    -c ':q!' </dev/null >/dev/null  &
)             &&

export EDITOR ||

return 1

return 0
