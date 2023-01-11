{ enablePulseAudio ? false }: {
  config = {
    allowUnfree = true;
    pulseaudio = enablePulseAudio;
  };

  overlays = [ (import ./overlays.nix) ];
}
