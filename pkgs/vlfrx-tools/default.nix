{
  lib,
  stdenv,
  fetchurl,
  # dependencies
  ncurses,
  libshout,
  flac,
  libsamplerate,
  fftw,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vlfrx-tools";
  version = "0.9p";

  src = fetchurl {
    urls = [
      # abelian.org is no longer online - Paul, who ran it, sadly passed away...
      # "http://abelian.org/vlfrx-tools/vlfrx-tools-${finalAttrs.version}.tgz"
      "https://web.archive.org/web/20250922092648/https://abelian.vvsindia.com/vlfrx-tools/vlfrx-tools-${finalAttrs.version}.tgz"
    ];
    sha256 = "sha256-tq9k1tnP6bmkqOdY1OkXqzvowRkEu71OC9D/vLPyjtc=";
  };

  buildInputs = [
    ncurses
    libshout
    flac
    libsamplerate
    fftw
    libpng
  ];
  configureFlags = [
    # requires xforms which is not in nixpkgs and i did not feel like packaging it after a failed attempt
    # TODO: maybe package xforms
    "--without-x11"
  ];
})
