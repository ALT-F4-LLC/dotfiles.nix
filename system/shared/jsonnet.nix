# ISSUE: https://github.com/NixOS/nixpkgs/issues/239912
{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "jsonnet";
  version = "0.20.0";
  outputs = [ "out" "doc" ];

  src = pkgs.fetchFromGitHub {
    rev = "v${version}";
    owner = "google";
    repo = "jsonnet";
    sha256 = "sha256-FtVJE9alEl56Uik+nCpJMV5DMVVmRCnE1xMAiWdK39Y=";
  };

  nativeBuildInputs = [ pkgs.jekyll ];

  enableParallelBuilding = true;

  makeFlags = [
    "jsonnet"
    "jsonnetfmt"
    "libjsonnet.so"
  ];

  # Upstream writes documentation in html, not in markdown/rst, so no
  # other output formats, sorry.
  preBuild = ''
    jekyll build --source ./doc --destination ./html
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include $out/share/doc/jsonnet
    cp jsonnet $out/bin/
    cp jsonnetfmt $out/bin/
    cp libjsonnet*.so $out/lib/
    cp -a include/*.h $out/include/
    cp -r ./html $out/share/doc/jsonnet
  '';
}
