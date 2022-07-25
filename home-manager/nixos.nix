{ config, lib, pkgs, ... }:

let i3_mod = "Mod4";
in {
  imports = [ ./home-manager.nix ];

  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file.".background-image".source = ./background-image;

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.firefox.enable = true;

  programs.gpg.enable = true;

  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#c0caf5";
      color_bad = "#f7768e";
      color_degraded = "#ff9e64";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  programs.vscode.enable = true;

  #---------------------------------------------------------------------
  # services
  #---------------------------------------------------------------------

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  #---------------------------------------------------------------------
  # xsession
  #---------------------------------------------------------------------

  xsession.windowManager.i3 = {
    enable = true;

    config = {
      bars = [{
        position = "bottom";
        statusCommand = "${pkgs.i3status}/bin/i3status";
        colors = {
          background = "#1a1b26";
          statusline = "#c0caf5";
          separator = "#3b4261";
          focusedWorkspace = {
            background = "#c0caf5";
            border = "#3b4261";
            text = "#565f89";
          };
          activeWorkspace = {
            background = "#353836";
            border = "#595B5B";
            text = "#FDF6E3";
          };
          inactiveWorkspace = {
            background = "#222D31";
            border = "#595B5B";
            text = "#EEE8D5";
          };
          bindingMode = {
            background = "#2C2C2C";
            border = "#16a085";
            text = "#F9FAF9";
          };
          urgentWorkspace = {
            background = "#FDF6E3";
            border = "#16a085";
            text = "#E5201D";
          };
        };
      }];

      fonts = { names = [ "Meslo LG M Regular Nerd Font Complete Mono" ]; };

      gaps = {
        inner = 0;
        outer = 0;
      };

      keybindings = {
        "${i3_mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        "${i3_mod}+Shift+q" = "kill";

        "${i3_mod}+d" =
          "exec --no-startup-id ${pkgs.rofi}/bin/rofi -modi drun -show drun";

        "${i3_mod}+h" = "focus left";
        "${i3_mod}+j" = "focus down";
        "${i3_mod}+k" = "focus up";
        "${i3_mod}+l" = "focus right";

        "${i3_mod}+Shift+h" = "move left";
        "${i3_mod}+Shift+j" = "move down";
        "${i3_mod}+Shift+k" = "move up";
        "${i3_mod}+Shift+l" = "move right";

        "${i3_mod}+b" = "split h; exec notify-send 'Tile Horizontally'";
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
        "${i3_mod}+Shift+e" =
          "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

        "${i3_mod}+r" = "mode resize";
      };

      modifier = i3_mod;

      window = {
        border = 0;
        hideEdgeBorders = "none";
      };
    };

    extraConfig = ''
      default_border none
      default_floating_border none
      smart_borders on
      smart_gaps on
    '';
  };
}
