# Relocate tool state/config into XDG dirs where the tool honors an
# env var (git reads ~/.config/git/config natively, so it needs none).

# codex CLI (default ~/.codex)
export CODEX_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/codex"

# npm cache (default ~/.npm)
export npm_config_cache="${XDG_CACHE_HOME:-$HOME/.cache}/npm"

# wget: no env var for the HSTS db, so point WGETRC at a wgetrc that
# relocates it (see ~/.config/wget/wgetrc)
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
