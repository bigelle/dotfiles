{
  description = "Универсальный декларативный конфиг пользователя (Home Manager + Nix)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = builtins.currentSystem or "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      username = builtins.getEnv "USER";
      homeDir = builtins.getEnv "HOME";
    in
    {
      homeConfigurations = {
        default = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ({ config, pkgs, ... }: {
              news.display = "silent";
              home.username = username;
              home.homeDirectory = homeDir;
              home.stateVersion = "24.05";

              nixpkgs.config.allowUnfree = true;

              home.packages = with pkgs; [
                neovim
                tmux
                wl-clipboard
                bat
                direnv
              ];

              programs.zsh = {
                enable = true;
                enableCompletion = true;

                oh-my-zsh = {
                  enable = true;
                  plugins = [ "git" ];
                  theme = ""; 
                };

                initExtra = ''
                  eval "$(direnv hook zsh)"
                '';
              };

              programs.starship = {
                enable = true;
                enableZshIntegration = true;
              };
            })
          ];
        };
      };
    };
}
