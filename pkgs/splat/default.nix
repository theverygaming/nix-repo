{
  lib,
  stdenv,
  fetchFromGitHub,
  # build tools
  cmake,
  # dependencies
  bzip2,
  zlib,
  libpng,
  libjpeg,
  gdal,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "splat";
  version = "ac51ee1457a7012f726fc2f2e3d4aad4d3e8ff73";

  src = fetchFromGitHub {
    owner = "hoche";
    repo = "splat";
    rev = finalAttrs.version;
    sha256 = "sha256-C3Wa6ejwPHYHeOcRgg75me8o4vZ6GHTzmTqZwPZgHns=";
  };

  patches = [
    # splat always wants to download gtest, patch it to allow building offline
    ./use-nix-googletest.patch
    # build utils along with SPLAT!
    ./with-utils.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    bzip2
    zlib
    libpng
    libjpeg
    gdal
    gtest
  ];
})
