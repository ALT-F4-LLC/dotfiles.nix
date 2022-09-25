# pulled from https://github.com/Twingate/nixpkgs/blob/87a5f86fb31888f9db6892bfebc4d9b5b9eb132e/pkgs/applications/networking/twingate/default.nix
{ autoPatchelfHook
, curl
, dpkg
, dbus
, fetchurl
, lib
, libnl
, udev
, cryptsetup
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "twingate";
  version = "1.0.60";

  src = fetchurl {
    url = "https://binaries.twingate.com/client/linux/DEB/${version}/twingate-amd64.deb";
    sha256 = "b308c422af8a33ecd58e21a10a72c353351a189df67006e38d1ec029a93d5678";
  };

  buildInputs = [ dbus curl libnl udev cryptsetup ];
  nativeBuildInputs = [ dpkg autoPatchelfHook ];

  unpackCmd = "mkdir root ; dpkg-deb -x $curSrc root";

  postPatch = ''
    while read file; do
      substituteInPlace "$file" \
        --replace "/usr/bin" "$out/bin" \
        --replace "/usr/sbin" "$out/bin"
    done < <(find etc usr/lib usr/share -type f)
  '';

  installPhase = ''
    mkdir $out
    mv etc $out/
    mv usr/bin $out/bin
    mv usr/sbin/* $out/bin
    mv usr/lib $out/lib
    mv usr/share $out/share
  '';
}
