{geist-mono}: {pkgs, ...}:
{
  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file.".background-image".source = ../../config/background-image;

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.kitty = {
    enable = true;

    font = {
      name = "GeistMono NFM";
      package = geist-mono;
      size = 16;
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
}
