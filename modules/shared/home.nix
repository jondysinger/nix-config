# Cross-platform home-manager configuration (works on both NixOS and darwin)

{
  pkgs,
  pkgs-unstable,
  lib,
  dotfilesSrc ? null,
  ...
}:
{
  home.packages =
    (with pkgs; [
      # Neovim and dependencies
      neovim
      ripgrep
      tree-sitter

      # Linters / formatters
      hadolint
      prettier

      # Interactive CLI and development tools
      curl
      delta
      fd
      fzf
      git
      jq
      lazygit
      lsd
      tmux
      unzip
      wget
      yazi

      # Secret handling
      age
      sops
      ssh-to-age
    ])
    ++ (with pkgs-unstable; [
      # CLI AI coding tools
      codex
      claude-code
    ]);

  fonts.fontconfig.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      if [[ -n "''${GHOSTTY_RESOURCES_DIR:-}" ]]; then
        source "''${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
      fi

      if [[ -f "$HOME/.secrets.env" ]]; then
        source "$HOME/.secrets.env"
      fi
    '';
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    shellAliases = {
      ls = "lsd --group-dirs first --color=always";
      nupd = "nix flake update --flake /etc/nixos";
    };
  };

  # Customize the CLI prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = "$directory$git_branch$python$conda$character";
      directory = {
        style = "#9ccfd8 bold";
        truncation_length = 3;
        truncate_to_repo = false;
      };
      git_branch = {
        format = "[<$branch(:$remote_branch)$symbol>]($style) ";
        symbol = "";
        style = "#31748f bold";
      };
      git_status = {
        format = "[$all_status]($style) ";
        style = "#f6c177 bold";
        modified = "*";
        untracked = "";
        staged = "";
        deleted = "";
        renamed = "";
        ahead = "";
        behind = "";
        diverged = "";
        conflicted = "";
      };
      python = {
        format = "[(\\(v:$virtualenv\\))]($style) ";
        style = "#ebbcba";
      };
      conda = {
        format = "[(\\(v:$environment\\))]($style) ";
        style = "#ebbcba";
        ignore_base = true;
      };
      character = {
        success_symbol = "[%](#c4a7e7)";
        error_symbol = "[%](#eb6f92)";
      };
    };
  };

  # Link each top-level `dot_config/*` directory from the dotfiles tree into
  # `~/.config`. `dotfilesSrc` must be a path that Nix can read during flake
  # evaluation because this mapping is generated with `builtins.readDir`.
  xdg.configFile = lib.optionalAttrs (dotfilesSrc != null) (
    lib.mapAttrs' (
      name: _:
      lib.nameValuePair name {
        source = dotfilesSrc + "/dot_config/${name}";
      }
    ) (lib.filterAttrs (_: type: type == "directory") (builtins.readDir (dotfilesSrc + "/dot_config")))
  );

  # Link `dot_local/bin` from the dotfiles tree into `~/.local/bin` when that
  # directory exists.
  home.file =
    lib.optionalAttrs (dotfilesSrc != null && builtins.pathExists (dotfilesSrc + "/dot_local/bin"))
      {
        ".local/bin" = {
          source = dotfilesSrc + "/dot_local/bin";
          recursive = true;
        };
      };
}
