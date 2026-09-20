{
  description = "Мой декларативный набор системных утилит и инструментов";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # Автоматическое определение архитектуры (x86_64-linux, aarch64-darwin и т.д.)
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # Профиль профилей/пакетов для установки через `nix profile install`
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.buildEnv {
            name = "user-environment";
            paths = with pkgs; [
              # Компиляторы и базовый дев-инструментарий
              rustup

              # Редакторы и оболочки
              neovim
              zsh
              oh-my-zsh
              tmux
              starship

              # Утилиты буфера обмена и системы
              wl-clipboard
              mangohud
            ];
          };
        }
      );
    };
}
