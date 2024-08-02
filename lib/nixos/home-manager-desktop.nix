{geist-mono}: {pkgs, ...}: let
  catppuccin-rofi = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "rofi";
    rev = "5350da41a11814f950c3354f090b90d4674a95ce";
    sha256 = "sha256-DNorfyl3C4RBclF2KDgwvQQwixpTwSRu7fIvihPN8JY=";
  };
  i3_mod = "Mod4";
in {
  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file.".background-image".source = ../../config/background-image;
  home.file.".config/rofi/catppuccin-macchiato.rasi".source = catppuccin-rofi + "/basic/.local/share/rofi/themes/catppuccin-macchiato.rasi";

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.autorandr = {
    enable = true;
    profiles = {
      default = {
        config = {
          "Virtual-1" = {
            enable = true;
            dpi = 96;
            mode = "3440x1440";
            primary = true;
            rate = "60";
          };
        };
        fingerprint = {
          "Virtual-1" = "--CONNECTED-BUT-EDID-UNAVAILABLE--Virtual-1";
        };
      };
    };
  };

  programs.firefox.enable = true;

  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#42be65";
      color_bad = "#ff7eb6";
      color_degraded = "#3ddbd9";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  programs.kitty = {
    enable = true;

    font = {
      name = "GeistMono";
      package = geist-mono;
      size = 14;
    };

    settings = {
      allow_remote_control = "yes";
      background_opacity = "0.9";
      enabled_layouts = "splits";
      hide_window_decorations = "titlebar-and-corners";
      listen_on = "unix:/tmp/kitty";
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "yes";
      macos_titlebar_color = "system";
      url_style = "single";
      wayland_titlebar_color = "system";
    };

    theme = "Tokyo Night";
  };

  programs.rofi = {
    enable = true;
    extraConfig = {
      disable-history = false;
      display-Network = " 󰤨  Network";
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      drun-display-format = "{icon} {name}";
      hide-scrollbar = true;
      icon-theme = "Oranchelo";
      location = 0;
      modi = "run,drun,window";
      show-icons = true;
      sidebar-mode = true;
      terminal = "kitty";
    };
    theme = "catppuccin-macchiato";
  };

  programs.vscode.enable = true;

  #---------------------------------------------------------------------
  # services
  #---------------------------------------------------------------------

  services.autorandr.enable = true;

  #---------------------------------------------------------------------
  # xsession
  #---------------------------------------------------------------------

  xsession.windowManager.i3 = {
    enable = true;

    config = {
      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          colors = {
            background = "#161616";
            statusline = "#dde1e6";
            separator = "#42be65";
            focusedWorkspace = {
              background = "#33b1ff";
              border = "#82cfff";
              text = "#161616";
            };
            activeWorkspace = {
              background = "#393939";
              border = "#595B5B";
              text = "#dde1e6";
            };
            inactiveWorkspace = {
              background = "#393939";
              border = "#595B5B";
              text = "#dde1e6";
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
        }
      ];

      fonts = {names = ["GeistMono"];};

      gaps = {
        inner = 0;
        outer = 0;
      };

      keybindings = {
        "${i3_mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${i3_mod}+Shift+q" = "kill";

        "${i3_mod}+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -modi drun -show drun";

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
      default_border none
      default_floating_border none
      smart_borders on
      smart_gaps on
    '';
  };
}
