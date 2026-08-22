{ pkgs, ... }:
let
  openaiCodex = pkgs.vscode-utils.buildVscodeExtension {
    pname = "openai-chatgpt";
    version = "26.5818.41509";
    src = pkgs.fetchurl {
      url = "https://open-vsx.org/api/openai/chatgpt/linux-x64/26.5818.41509/file/openai.chatgpt-26.5818.41509@linux-x64.vsix";
      hash = "sha256-25A9EWUAhdfBXcKxY/8V5GSN1oXNitqSZXnCDVXA8fY=";
    };
    vscodeExtPublisher = "openai";
    vscodeExtName = "chatgpt";
    vscodeExtUniqueId = "openai.chatgpt";
  };
in
{
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        openaiCodex
        esbenp.prettier-vscode
        jnoortheen.nix-ide
        tamasfe.even-better-toml
      ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "nix.serverSettings" = {
          nil.formatting.command = [ "${pkgs.nixfmt}/bin/nixfmt" ];
        };
        "nix.formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";
        "direnv.path.executable" = "${pkgs.direnv}/bin/direnv";
        "prettier.prettierPath" = "${pkgs.prettier}/bin/prettier";
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
        };
        "[toml]" = {
          "editor.defaultFormatter" = "tamasfe.even-better-toml";
          "editor.formatOnSave" = true;
        };
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };
      };
    };
  };
}
