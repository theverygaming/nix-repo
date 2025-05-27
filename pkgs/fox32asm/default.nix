# TODO: ask for more recent releases so we don't need a git version
{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fox32asm";
  version = "596e92c2ff586d18b438528949ee0f500fc45688";
  useFetchCargoVendor = true;

  src = fetchFromGitHub {
    owner = "fox32-arch";
    repo = "fox32asm";
    rev = finalAttrs.version;
    sha256 = "sha256-jLd2jzq8UjPdhNkwdWyAWvFldWU1u7Akgz8rbBeJZ3Q=";
    leaveDotGit = true; # for vergen
  };

  cargoHash = "sha256-lPb6hGlAHQh78D1ElL+pznj5P4+BNrOdEZKbbVwrSLU=";
})
