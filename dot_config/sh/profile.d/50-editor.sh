# use nvim, vim or vi depending on availability
if command -v nvim >/dev/null 2>&1; then
  EDITOR='nvim'
elif command -v vim >/dev/null 2>&1; then
  EDITOR='vim'
else
  EDITOR='vi'
fi
export EDITOR
