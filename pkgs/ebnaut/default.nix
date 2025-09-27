# TODO: figure out how to pin version
{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ebnaut";
  version = "1.1";

  # use finalAttrs.version when you finally figured out how to pin it
  src = fetchurl {
    urls = [
      # abelian.org is no longer online - Paul, who ran it, sadly passed away...
      # "http://abelian.org/ebnaut/ebnaut.c"
      "https://web.archive.org/web/20250922113411/https://abelian.vvsindia.com/ebnaut/ebnaut.c"
    ];
    sha256 = "sha256-ZPV2bdQ2O+IDx9q3oVOpx8150EK6IvwRa3n0xREYS4s=";
  };

  unpackPhase = ''
    cp $src ebnaut.c
  '';

  buildPhase = ''
    mkdir -p "$out"/bin
    gcc -std=gnu99 -Wall -O3 -o "$out"/bin/ebnaut ebnaut.c -lm -lpthread
  '';
})
