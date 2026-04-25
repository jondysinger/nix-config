# dotfiles

This directory contains application configuration files that are symlinked into
the home directory by Home Manager via `modules/shared/home.nix`. It is passed
to the shared home module as the `dotfilesSrc` argument during flake evaluation.

## Directory layout

### `dot_config/`

Each subdirectory here maps to a directory under `~/.config`. Home Manager reads
this directory at eval time with `builtins.readDir` and creates a symlink for
every top-level entry:

```
dot_config/nvim/    → ~/.config/nvim/
dot_config/ghostty/ → ~/.config/ghostty/
...
```

### `dot_local/bin/`

Scripts and executables placed here are linked recursively into `~/.local/bin`,
making them available on `$PATH`. This directory is optional — the link is only
created when `dot_local/bin` exists.

## Adding new configuration

- **App config**: create a subdirectory under `dot_config/` matching the app's
  XDG config directory name. Home Manager picks it up automatically on the next
  activation.
- **Scripts**: drop executables into `dot_local/bin/`. Make sure they are marked
  executable (`chmod +x`).
