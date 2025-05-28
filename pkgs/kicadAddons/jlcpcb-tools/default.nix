# resources used:
# nix kicad addons:
# - https://github.com/NixOS/nixpkgs/blob/2795c506fe8fb7b03c36ccb51f75b6df0ab2553f/pkgs/applications/science/electronics/kicad/addons/kikit.nix
# - https://github.com/NixOS/nixpkgs/blob/2795c506fe8fb7b03c36ccb51f75b6df0ab2553f/pkgs/applications/science/electronics/kicad/addons/default.nix
# how to build that zip thingy for jlcpcb-tools:
# - https://github.com/Bouni/kicad-jlcpcb-tools/blob/8019de197c99a6023f6efeca527cd63b5686c9f4/PCM/create_pcm_archive.sh
# - https://github.com/Bouni/kicad-jlcpcb-tools/blob/8019de197c99a6023f6efeca527cd63b5686c9f4/.github/workflows/kicad-pcm.yml
{
  stdenv,
  fetchFromGitHub,
  zip,
  unzip,
  perl,
  python3,
  addonPath,
}:
stdenv.mkDerivation rec {
  pname = "kicadaddon-jlcpcb-tools";
  version = "2025.04.02";

  src = fetchFromGitHub {
    owner = "Bouni";
    repo = "kicad-jlcpcb-tools";
    rev = version;
    sha256 = "sha256-oHY58V8pNxyMQPNdGgdOD0BGw1p3egG5PxZp7yJlv+Q=";
  };

  patches = [
    # distutils doesn't exist in newer python and shit broke
    ./fix.patch
  ];

  nativeBuildInputs = [
    zip
    unzip
    perl # shasum lmao
  ];

  propagatedBuildInputs = [ ];

  buildPhase = ''
    GITHUB_ENV=/tmp/nothing sh ./PCM/create_pcm_archive.sh ${version}
  '';

  installPhase = ''
    mkdir $out
    mv PCM/KiCAD-PCM-${version}.zip $out/${addonPath}
  '';
}
