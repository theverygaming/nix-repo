# TODO: figure out how to pin version
{
  lib,
  stdenv,
  fetchurl,
  # dependencies
  alsa-lib,
  ncurses,
  fftw,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ebsynth";
  version = "0.8h";

  # use finalAttrs.version when you finally figured out how to pin it
  src = fetchurl {
    urls = [
      # abelian.org is no longer online - Paul, who ran it, sadly passed away...
      # "http://abelian.org/ebnaut/ebsynth.c"
      "https://web.archive.org/web/20250922113424/https://abelian.vvsindia.com/ebnaut/ebsynth.c"
    ];
    sha256 = "sha256-CnR6Apj4QCFkKhEL1IlX1KEINOB1dfoT53SAiTOWKmc=";
  };

  unpackPhase = ''
    cp $src ebsynth.c
  '';

  buildPhase = ''
    mkdir -p "$out"/bin
    gcc -std=gnu99 -Wall -O3 -o "$out"/bin/ebsynth ebsynth.c -lasound -lncurses -lfftw3 -lm -lpthread
  '';

  buildInputs = [
    alsa-lib
    ncurses
    fftw
  ];
})
