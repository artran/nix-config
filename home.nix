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
        height = 30;
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];
        modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
        modules-center = [ "sway/window" "custom/hello-from-waybar" ];
        modules-right = [ "mpd" "custom/mymodule#with-css-id" "temperature" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        "custom/hello-from-waybar" = {
          format = "hello {}";
          max-length = 40;
          interval = "once";
          exec = pkgs.writeShellScript "hello-from-waybar" ''
            echo "from within waybar"
          '';
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 10;
        font-family: Source Code Pro;
      }
      window#waybar {
        background: #16191C;
        color: #AAB2BF;
      }
      #workspaces button {
        padding: 0 5px;
      }
    '';
  };



  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
