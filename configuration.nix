{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  i3_mod = "Mod4";
in
{
  imports =
    [
      (import "${home-manager}/nixos")
      /etc/nixos/hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment = {
    pathsToLink = [
      "/libexec"
    ];

    systemPackages = with pkgs; [
      dunst
      libnotify
      lxappearance
      vim
      wget
    ];
  };

  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
      };

      enable = true;
    };

    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
  };

  hardware.opengl.enable = true;
  hardware.pulseaudio.enable = true;

  home-manager.users.erikreinert = {
    home.packages = with pkgs; [
      firefox-bin
      lazygit
      vscode
    ];

    programs.alacritty = {
      enable = true;

      settings = {
        background_opacity = 0.80;

        colors = {
          primary = {
            background = "0x1a1b26";
            foreground = "0xa9b1d6";
          };

          normal = {
            black =   "0x32344a";
            red =     "0xf7768e";
            green =   "0x9ece6a";
            yellow =  "0xe0af68";
            blue =    "0x7aa2f7";
            magenta = "0xad8ee6";
            cyan =    "0x449dab";
            white =   "0x787c99";
          };

          bright = {
            black =   "0x444b6a";
            red =     "0xff7a93";
            green =   "0xb9f27c";
            yellow =  "0xff9e64";
            blue =    "0x7da6ff";
            magenta = "0xbb9af7";
            cyan =    "0x0db9d7";
            white =   "0xacb0d0";
          };
        };

        env = {
          "TERM" = "xterm-256color";
        };
      };
    };

    programs.git = {
      enable = true;
      userName  = "Erik Reinert";
      userEmail = "erik@altf4.email";
    };

    xsession.windowManager.i3 = {
      enable = true;

      config = {
        bars = [
          {
            position = "bottom";
            statusCommand = "${pkgs.i3status}/bin/i3status";
          }
        ];

        fonts = {
          names = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
        };

        gaps = {
          inner = 14;
          outer = -2;
        };

        keybindings = {
          "${i3_mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${i3_mod}+Shift+q" = "kill";

          "${i3_mod}+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -modi drun -show drun";

          "${i3_mod}+Left" = "focus left";
          "${i3_mod}+Down" = "focus down";
          "${i3_mod}+Up" = "focus up";
          "${i3_mod}+Right" = "focus right";

          "${i3_mod}+Shift+Left" = "move left";
          "${i3_mod}+Shift+Down" = "move down";
          "${i3_mod}+Shift+Up" = "move up";
          "${i3_mod}+Shift+Right" = "move right";

          "${i3_mod}+h" = "split h; exec notify-send 'Tile Horizontally'";
          "${i3_mod}+v" = "split v; exec notify-send 'Tile Vertically'";
          "${i3_mod}+f" = "fullscreen toggle";

          "${i3_mod}+s" = "layout stacking";
          "${i3_mod}+w" = "layout tabbed";
          "${i3_mod}+e" = "layout toggle split";

          "${i3_mod}+Shift+space" = "floating toggle";
          "${i3_mod}+space" = "focus mode_toggle";

          "${i3_mod}+a" = "focus parent";

          "${i3_mod}+Shift+minus" = "move scratchpad";
          "${i3_mod}+minus" = "scratchpad show";

          "${i3_mod}+1" = "workspace number 1";
          "${i3_mod}+2" = "workspace number 2";
          "${i3_mod}+3" = "workspace number 3";
          "${i3_mod}+4" = "workspace number 4";
          "${i3_mod}+5" = "workspace number 5";
          "${i3_mod}+6" = "workspace number 6";
          "${i3_mod}+7" = "workspace number 7";
          "${i3_mod}+8" = "workspace number 8";
          "${i3_mod}+9" = "workspace number 9";
          "${i3_mod}+0" = "workspace number 10";

          "${i3_mod}+Shift+1" = "move container to workspace number 1";
          "${i3_mod}+Shift+2" = "move container to workspace number 2";
          "${i3_mod}+Shift+3" = "move container to workspace number 3";
          "${i3_mod}+Shift+4" = "move container to workspace number 4";
          "${i3_mod}+Shift+5" = "move container to workspace number 5";
          "${i3_mod}+Shift+6" = "move container to workspace number 6";
          "${i3_mod}+Shift+7" = "move container to workspace number 7";
          "${i3_mod}+Shift+8" = "move container to workspace number 8";
          "${i3_mod}+Shift+9" = "move container to workspace number 9";
          "${i3_mod}+Shift+0" = "move container to workspace number 10";

          "${i3_mod}+Shift+c" = "reload";
          "${i3_mod}+Shift+r" = "restart";
          "${i3_mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

          "${i3_mod}+r" = "mode resize";
        };

        modifier = i3_mod;

        window = {
          border = 0;
          hideEdgeBorders = "none";
        };
      };

      extraConfig = ''
        default_border pixel 1
        default_floating_border normal
        smart_borders on
        smart_gaps on
      '';
    };
  };

  networking.hostName = "nixos-erikreinert";
  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true;

  security.sudo.wheelNeedsPassword = false;

  services.picom.enable = true;

  services.xserver = {
    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      autoLogin = {
        enable = true;
        user = "erikreinert";
      };

      defaultSession = "none+i3";
    };

    enable = true;

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        i3status
        i3lock
        i3blocks
        rofi
      ];
    };
  };

  sound.enable = true;

  time.timeZone = "America/Los_Angeles";

  users = {
    mutableUsers = false;

    users = {
      erikreinert = {
        hashedPassword = "";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    };
  };

  virtualisation.vmware.guest.enable = true;

  system.stateVersion = "21.11";
}
