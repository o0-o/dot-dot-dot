# use nvim, vim or vi depending on availability
{ { command -v nvim >/dev/null  &&
    typeset EDITOR="nvim"
  } ||
  { command -v vim >/dev/null   &&
    typeset EDITOR="vim"
  } ||
  typeset EDITOR="vi"
}             &&

export EDITOR ||

return 1

return 0
