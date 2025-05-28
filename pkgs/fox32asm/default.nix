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
    sha256 = "sha256-aFIaVbrGVHV0UpBQSM9FE5LqIkR2KdRuK5hJs1hP+XY=";
    leaveDotGit = true; # for vergen
    fetchSubmodules = true; # for tests
  };

  checkFlags = [
    # These two fail with "Error: Label "get_rom_version" was defined more than once!" and it's a known issue
    "--skip=tests::hello_world"
    "--skip=tests::multitasking"
    # cputest is uhm NOT reproducible :sob: "failed to lock mutex; possibly poisoined: PoisonError { .. }" see fox32 discord for more info on that
    "--skip=tests::cputest"
  ];

  cargoHash = "sha256-lPb6hGlAHQh78D1ElL+pznj5P4+BNrOdEZKbbVwrSLU=";
})
