{ extraPackages ? [ ], pkgs }: with pkgs; extraPackages ++ [ curl wget vim ]
