# ──────────────────────────────────────────────────────────────────────────────
#  Hello World prompt — shell enhancements
#  Sourced from ~/.zshrc. Installed by starshelloworld-prompt/install.sh.
# ──────────────────────────────────────────────────────────────────────────────

# Ensure ~/.local/bin (where lando-hosts lives) is on PATH.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# ─── Completion ───────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select                        # arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive

# ─── History ──────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE INC_APPEND_HISTORY

# ─── Key bindings ─────────────────────────────────────────────────────────────
bindkey -e                                     # emacs keymap
bindkey '^[[1;3D' backward-word                 # Option + Left
bindkey '^[[1;3C' forward-word                  # Option + Right
bindkey '^[[1;9D' backward-word                 # Option + Left  (alt sequence)
bindkey '^[[1;9C' forward-word                  # Option + Right (alt sequence)
bindkey '^[b'     backward-word                 # Esc+b (iTerm2 Natural Text Editing)
bindkey '^[f'     forward-word                  # Esc+f
bindkey '^[[H'    beginning-of-line             # Home / Cmd + Left
bindkey '^[[F'    end-of-line                   # End  / Cmd + Right
bindkey '^[[3~'   delete-char                   # Forward delete
bindkey '^[^?'    backward-kill-word            # Option + Delete

# Up/Down search history by what's already typed on the line.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# ─── Plugins (installed via Homebrew) ─────────────────────────────────────────
if command -v brew >/dev/null 2>&1; then
  _hw_brew="$(brew --prefix)"
  [ -r "$_hw_brew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
    source "$_hw_brew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  # zsh-syntax-highlighting must be sourced last.
  [ -r "$_hw_brew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "$_hw_brew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  unset _hw_brew
fi

# ─── Lando: auto-sync /etc/hosts when a project starts ────────────────────────
# Wraps `lando` so `lando start|restart|rebuild` first ensures the project's
# hostnames resolve locally (via the lando-hosts helper).
if command -v lando >/dev/null 2>&1; then
  lando() {
    case "${1:-}" in
      start|restart|rebuild)
        if command -v lando-hosts >/dev/null 2>&1; then
          lando-hosts auto 2>/dev/null || true
        fi
        ;;
    esac
    command lando "$@"
  }
fi
