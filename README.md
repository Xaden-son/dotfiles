# xaden-dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).
The chezmoi source state lives in `home/` (see `.chezmoiroot`).

## What's inside

| Target | Source | Notes |
| --- | --- | --- |
| `~/.zshrc` | `home/dot_zshrc.tmpl` | Oh My Zsh + autosuggestions + syntax highlighting, starship prompt |
| `~/.gitconfig` | `home/dot_gitconfig.tmpl` | name + email (email asked once on `chezmoi init`) |
| `~/.config/kitty/` | `home/dot_config/kitty/` | JetBrainsMono Nerd Font, Tokyo Night theme (not on `rootless`) |
| `~/.config/starship.toml` | `home/dot_config/starship.toml` | prompt config |
| `~/.config/nvim/` | `home/dot_config/nvim/` | lazy.nvim config, plugins pinned by `lazy-lock.json` |
| `~/.oh-my-zsh` + plugins | `home/.chezmoiexternal.toml` | shallow git clones; plugins pinned to release tags |
| packages / tools | `home/packages/`, `home/run_onchange_*` | see below |

## Profiles

The profile is detected automatically when `chezmoi init` generates its config
(`home/.chezmoi.toml.tmpl`):

| Profile | Detected when | Packages | Tools in `~/.local` |
| --- | --- | --- | --- |
| `mac` | macOS | Homebrew (`packages/Brewfile`) | none (all from Homebrew) |
| `zorin` | Linux, user in group `sudo`, `admin` or `wheel` | apt (`packages/apt.txt`), asks for the sudo password | nvim, tree-sitter, starship, JetBrainsMono Nerd Font |
| `rootless` | Linux, no admin group | none | nvim, tree-sitter, starship, fzf, fd, ripgrep, clangd |

Force a profile with `CHEZMOI_PROFILE=rootless chezmoi init` (then `chezmoi apply`).

Linux tools are pinned release binaries, verified by SHA256, unpacked into
`~/.local/opt/<tool>` and symlinked into `~/.local/bin`. A tool is skipped when
the pinned version is already on `PATH`. Pinned versions: Neovim 0.12.5,
tree-sitter 0.27.0, starship 1.26.0, fzf 0.74.4, fd 10.5.0, ripgrep 15.2.0,
clangd 22.1.6 (x86_64 only upstream), JetBrainsMono Nerd Font 3.5.1.
After installing, `nvim --headless "+Lazy! restore" +qa` syncs plugins to
`lazy-lock.json` (a failure only prints a warning).

### clangd on macOS

clangd comes from the **Xcode Command Line Tools** (`/usr/bin/clangd`), so the
Brewfile does not install the multi-GB `llvm` formula. If you need a newer
clangd, `brew install llvm` and put `$(brew --prefix llvm)/bin` on `PATH`.

## Bootstrap

### 1. Install chezmoi (no `curl | sh`)

Linux (x86_64; use `linux_arm64` on aarch64):

```sh
VER=2.72.2
cd "$(mktemp -d)"
curl -fsSLO "https://github.com/twpayne/chezmoi/releases/download/v$VER/chezmoi_${VER}_linux_amd64.tar.gz"
curl -fsSLO "https://github.com/twpayne/chezmoi/releases/download/v$VER/chezmoi_${VER}_checksums.txt"
grep " chezmoi_${VER}_linux_amd64.tar.gz\$" "chezmoi_${VER}_checksums.txt" | sha256sum -c -
tar -xzf "chezmoi_${VER}_linux_amd64.tar.gz" chezmoi
mkdir -p ~/.local/bin && install -m 755 chezmoi ~/.local/bin/chezmoi
export PATH="$HOME/.local/bin:$PATH"
```

macOS: install the prerequisites first, then chezmoi from Homebrew:

```sh
xcode-select --install          # Xcode Command Line Tools (git, clang, clangd)
# Homebrew: https://brew.sh (or the .pkg from github.com/Homebrew/brew/releases)
brew install chezmoi
```

### 2. Apply

```sh
chezmoi init --apply Xaden-son
```

This clones `github.com/Xaden-son/dotfiles` (use `Xaden-son/<repo>` if the
repo has another name), asks for the git email once, detects the profile,
installs packages/tools and writes the dotfiles. On `zorin` apt asks for the
sudo password; without sudo rights it warns and continues.

To use a local checkout instead: `chezmoi init --apply --source ~/path/to/xaden-dotfiles`
(the location is remembered via `sourceDir`).

## Daily usage

| Command | What it does |
| --- | --- |
| `chezmoi add ~/.config/foo` | start managing a file (copies it into the repo) |
| `chezmoi diff` | show what `apply` would change |
| `chezmoi apply` | write the repo state to `$HOME` |
| `chezmoi update` | `git pull` the repo, then apply |
| `chezmoi cd` | open a shell in the source repo (commit/push from there) |
| `chezmoi edit ~/.zshrc` | edit the source (template) of a managed file |

## Neovim keymaps

Leader is `Space`.

| Keys | Action |
| --- | --- |
| `nvim .` | open a directory |
| `Space w` | 3-pane layout: file tree / file / terminal |
| `Ctrl+h/j/k/l` | move between windows |
| `Alt+w` | cycle windows (also from insert/terminal mode) |
| `Ctrl+s` | save |
| `Alt+Backspace` | delete previous word (insert mode) |
| `Shift+arrows` | select text |
| `Alt+Up` / `Alt+Down` | move line/selection up/down |
| `Space ff` / `Space fg` | find files / live grep (fzf-lua) |

## Credits

Neovim config adapted from
[github.com/ertugruldasgin/dotfiles](https://github.com/ertugruldasgin/dotfiles).
