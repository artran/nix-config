{ config, pkgs, ... }:

{
  home.username = "ray";
  home.homeDirectory = "/home/ray";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      "." = "source";
      ap = "ansible-playbook";
      cat = "bat";
      nv = "nvim";
      vimdiff = "nvim -d";
    };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      extraConfig = ''
        ZSH_TMUX_AUTOSTART=true
        ZSH_TMUX_AUTOCONNECT=false
      '';
      plugins = [
        "git"
        "history"
	      "ssh-agent"
	      "tmux"
      ];
    };
    initExtra = ''
      export PIPENV_VENV_IN_PROJECT=1
      eval "$(starship init zsh)"
      eval "$(zoxide init --cmd cd zsh)"
    '';
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 20;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "temperature" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 10;
        font-family: JetBrains Mono;
      }
      window#waybar {
        background: #16191C;
        color: #AAB2BF;
      }

      #workspaces button {
        padding: 0 5px;
      }
      #workspaces button:hover {
      }

      #workspaces button.focused {
        /*    box-shadow: inset 0 -2px #c9545d; */
        background-color: rgba(0,0,0,0.3);
        color:#c9545d;
        border-top: 2px solid #c9545d;
      }

      #workspaces button.urgent {
        background-color: #eb4d4b;
      }
    '';
  };



  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
