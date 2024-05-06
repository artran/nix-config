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

  home.file."/home/ray/.config/waybar/style.css".source = ./waybar-config/styles/translucent.css;
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "cpu" "memory" "temperature" "clock" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "󰇮";
            "4" = "";
            "5" = "";
            urgent = "";
            # active = "";
            # default = "";
          };
          sort-by-number = true;
        };
        cpu = {
          interval = 10;
          format = "{}% ";
          max-length = 10;
        };
        memory = {
          interval = 30;
          format = "{}% ";
          max-length = 10;
        };
        temperature = {
          format = "{temperatureC}°C ";
        };
        clock = {
          interval = 60;
          format = "{:%H:%M}";
          max-length = 25;
        };
      };
    };
    # style = ''
    #   * {
    #     border: none;
    #     border-radius: 10;
    #     font-family: JetBrains Mono;
    #   }
    #
    #   window#waybar {
    #     background: #16191C;
    #     color: #AAB2BF;
    #   }
    #
    #   #window {
    #     padding: 0 8px;
    #     /* background-color: #ffdd77; */
    #     /* color: #16191C; */
    #   }
    #
    #   #workspaces button {
    #     padding: 0 4px;
    #   }
    #
    #   #workspaces button.active {
    #     background-color: rgba(0,0,0,0.3);
    #     color:#c9545d;
    #   }
    #
    #   #workspaces button.urgent {
    #     background-color: #eb4d4b;
    #   }
    #
    #   #cpu, #memory, #temperature, #clock {
    #     padding: 0 8px;
    #     margin: 0 2px;
    #     background-color: #30ccff;
    #     color: #16191C;
    #   }
    # '';
  };

  programs.vim = {
    enable = true;
    extraConfig = ''
      set nocompatible
      set backspace=indent,eol,start
      set list listchars=tab:\|_,trail:·
      set autoindent
      set softtabstop=4
      set ruler
      set hlsearch
      colorscheme koehler
      filetype plugin indent on
      syntax on
      autocmd BufNewFile,BufRead *.rs set filetype=rust
    '';

    settings = {
      expandtab = true;
      tabstop = 8;
      shiftwidth = 4;
      number = true;
      relativenumber = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "Ray Tran";
    userEmail = "ray@artran.co.uk";
    signing.key = "0x9F7502000A746EAB1111EEA79881D5BAA518C0A3";
    signing.signByDefault = true;
    aliases = {
      stat = "status";
      co = "checkout";
      loggraph = "log --oneline --graph --decorate --all";
      su = "submodule update";
    };
    extraConfig = {
      color = {
        status = "auto";
        branch = "auto";
        interactive = "auto";
        diff = "auto";
      };
      push = {
        default = "simple";
      };
      core = {
        excludesfile = "~/.gitignore";
        autocrlf = "input";
        pager = "less -FX";
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      pull = {
        rebase = true;
      };
      filter = {
        lfs = {
          process = "git-lfs filter-process";
          required = true;
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
        };
      };
      log = {
        showSignature = true;
      };
      init = {
        defaultbranch = "main";
      };
    };
  };

  programs.ssh = {
    enable = true;
    compression = true;
    # addKeysToAgent = "yes";
    serverAliveInterval = 240;

    matchBlocks = {
      "bitbucket.org" = {
        identityFile = "~/.ssh/id_bitbucket";
      };

      "github.com" = {
        identityFile = "~/.ssh/id_github";
      };

      "gitlab.com" = {
        identityFile = "~/.ssh/id_gitlab";
      };
    };

    extraConfig = '' 
      SetEnv TERM=xterm-256color
      IPQoS=throughput
      AddKeysToAgent yes
      IdentitiesOnly yes
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
